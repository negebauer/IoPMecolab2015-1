
//
//  ChatManager.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import CoreData
import AddressBook

// MARK: - Protocols

protocol ChatRoomListDelegate {
    func reloadChatRooms()
    var table: UITableView { get }
}

protocol ChatMessageListDelegate {
    func reloadChatRoom()
    var table: UITableView { get }
}

// MARK: - Chat manager class

/// Manages everything related to getting chatRooms, sending messages, getting messages, etc. It's the core of the app.
public class ChatManager {
    weak var adbk : ABAddressBook!
    private var diccionarioNumeroPersonABRecord = Dictionary<String,ABRecord>()
    var chatsList = [ChatRoom]()
    private var moc: NSManagedObjectContext!
    var chatRoomListDelegate: ChatRoomListDelegate?              //Vista de todos los chats
    var chatMessageListDelegate: ChatMessageListDelegate?       //Vista del ChatRoom que se esta mostrando actualmente
    var timerUpdateChats = NSTimer()
    
    // MARK: - Init
    
    init(chatRoomListDelegate: ChatRoomListDelegate, adbk: ABAddressBook) {
        self.chatRoomListDelegate = chatRoomListDelegate
        self.adbk = adbk
        getMoc()
        checkMoc()
        createArrayNumberName()
        fetchChatRooms()
        reloadChatRooms()
        updateChats()
        
        User.currentUser?.chatManager = self
        
        //logStuff()
    }
    
    // MARK: - [DEVELOPING] Don't call this functions when deploying
    
    /// [DEVELOPING] Logs a lot of stuff.
    private func logStuff() {
        var nChatMessages = 0
        for chat in chatsList {
            nChatMessages += chat.arrayMessage.count
        }
        let stringLog =
            [
                "Comenzando logueo de cosas",
                "Info usuario: \(User.currentUser!.description)",
                "Nº de chatRooms: \(chatsList.count)",
                "Nº de chatMessages: \(nChatMessages)"
            ].joinWithSeparator("\n")
        NSLog(stringLog)
    }
    
    // MARK: - Chat update general functions
    
    /// Updates everything (chatRooms, chatMessages, etc.)
    func updateChats() {
        checkMoc()
        getChatRooms()
        for chat in chatsList {
            updateChat(chat)
        }
        //logStuff()
    }
    
    /// Updates everything of a chatRoom.
    func updateChat(chat: ChatRoom) {
        getMessagesForChatRoom(chat)
    }
    
    // MARK: - Get chat updates from web
    
    /// Gets all the chatRooms from the server and checks if they have a local copy. If not, then creates a new chatRoom.
    private func getChatRooms() {
        let request = CreateRequest.userConversations()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            let jsonContainer = JSONObjectCreator(data: data, type: JSONObject.TiposDeJSON.ChatRoom, error: error)
            
            for jsonObject in jsonContainer.arrayJSONObjects {
                dispatch_async(dispatch_get_main_queue(), {
                    self.checkForChatRoom(jsonObject)
                })
            }
        }
        task.resume()
    }
    
    /// Updates the chatMessages of a chatRoom
    private func getMessagesForChatRoom(chat: ChatRoom) {
        let request = CreateRequest.messagesInConversation(Int(chat.id))
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        
            if data == nil {
                return
            }
            
            let jsonContainer = JSONObjectCreator(data: data!, type: JSONObject.TiposDeJSON.ChatMessage, error: error)
            
            for jsonObject in jsonContainer.arrayJSONObjects {
                dispatch_async(dispatch_get_main_queue(), {
                    self.checkForChatMessageInChatRoom(chat, jsonObject: jsonObject)
                })
            }
        }
        task.resume()
    }
    
    /// Gets the list of users of a certain chat
    private func getUsersOfChatRoom(chat: ChatRoom) {
        let request = CreateRequest.usersInConversation(chat.id.stringValue)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            if data == nil {
                return
            }
            
            let jsonContainer = JSONObjectCreator(data: data!, type: JSONObject.TiposDeJSON.MiembroChat, error: error)
            
            for jsonObject in jsonContainer.arrayJSONObjects {
                dispatch_async(dispatch_get_main_queue(), {
                    let contact = self.getContactForNumber(jsonObject.phone_number!)
                    chat.addMemberToChat(contact)
                })
            }
        }
        task.resume()
    }
    
    // MARK: - Make updates when necessary
    
    /// Creates a new group chat room
    func createNewChatRoomGroup(numbers: [String], title: String) {
        let newChatRoom = ChatRoom.new(moc, _isGroup: true, _nameChat: title, _admin: User.currentUser!.number, _id: -1)
        let request = CreateRequest.createGroupConversation(User.currentUser!.number, users: numbers, title: title)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            synced(self.chatsList, closure: {
                let jsonContainer = JSONObjectCreator(data: data!, type: JSONObject.TiposDeJSON.NewChatRoom, error: error)
                
                for jsonObject in jsonContainer.arrayJSONObjects {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.checkForChatRoom(jsonObject, newChatRoom: newChatRoom)
                    })
                }
            })
        }
        task.resume()
        //logStuff()
    }
    
    /// Checks the existance of a chat room. If it doesn't exist, it updates it to have server info. If exist, ignores
    private func checkForChatRoom(jsonObject: JSONObject, var newChatRoom: ChatRoom? = nil) {
        fetchChatRooms()
        synced(chatsList, closure: {
            if newChatRoom != nil && !self.chatsList.contains({chat in chat.id == jsonObject.id!}) {
                // New chat created by User
                newChatRoom!.id = jsonObject.id!
                newChatRoom!.updatedAt = getDateFromString(jsonObject.created_at!)
                saveDatabase()
                self.addNewChatRoom(newChatRoom!)
                self.getUsersOfChatRoom(newChatRoom!)
            } else if !self.chatsList.contains({chat in chat.id == jsonObject.id!}) {
                // New chat downloaded from server
                newChatRoom = ChatRoom.new(self.moc, _isGroup: jsonObject.group!, _nameChat: jsonObject.title!, _admin: jsonObject.admin!, _id: jsonObject.id!)
                newChatRoom!.updatedAt = NSDate(timeIntervalSince1970: 0)
                saveDatabase()
                self.addNewChatRoom(newChatRoom!)
            }
        })
        //logStuff()
    }
    
    /// Adds a newChatRoom to the list of chat rooms
    private func addNewChatRoom(newChatRoom: ChatRoom) {
        self.chatsList.append(newChatRoom)
        self.chatsList.sortInPlace({ chat1, chat2 in return isDate1GreaterThanDate2(chat1.updatedAt, date2: chat2.updatedAt) })
        if let delegate = self.chatRoomListDelegate {
            let indexPaths = [NSIndexPath(forRow: self.chatsList.indexOf(newChatRoom)! + 1, inSection: 0)]
            delegate.table.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        self.getUsersOfChatRoom(newChatRoom)
        self.updateChat(newChatRoom)
    }
    
    /// Checks the existance of a given chatMessage. If it doesn't exist, it creates it, adds it to its corresponding chatRoom and updates the chatRoom. If exists, ignores.
    private func checkForChatMessageInChatRoom(chat: ChatRoom, jsonObject: JSONObject) {
        fetchChatRooms()
        var newChatMessage: ChatMessage?
        synced(chat, closure: {
            if !chat.containsMessageWithID(jsonObject.id!) {
                newChatMessage = ChatMessage.new(self.moc, sender: jsonObject.sender!, content: jsonObject.content!, createdAt: jsonObject.created_at!, id: jsonObject.id!, isFile: jsonObject.hasFile(), fileURL: jsonObject.url_file!, mimeType: jsonObject.mime_type!, chatRoom: chat)
                saveDatabase()
                if let delegate = self.chatMessageListDelegate {
                    let indexPaths = [NSIndexPath(forRow: chat.arrayMessage.indexOf(newChatMessage!)!, inSection: 0)]
                    delegate.table.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                if let delegate = self.chatRoomListDelegate {
                    let indexPathBefore = NSIndexPath(forRow: self.chatsList.indexOf(chat)! + 1, inSection: 0)
                    self.fetchChatRooms()
                    let indexPathAfter = NSIndexPath(forRow: self.chatsList.indexOf(chat)! + 1, inSection: 0)
                    delegate.table.moveRowAtIndexPath(indexPathBefore, toIndexPath: indexPathAfter)
                    delegate.table.reloadRowsAtIndexPaths([indexPathAfter], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            }
        })
        //logStuff()
    }
    
    // MARK: - Functions for views
    
    /// Searchs for a chatRoom that isn't a group and has the number provided. If it doesn't exist, it creates it.
    func getChatRoomForNumber(number:String) -> ChatRoom {
        fetchChatRooms()
        if chatsList.contains({ chat in chat.number == number }) {
            return chatsList.filter({ chat in chat.number == number })[0]
        } else {
            synced(chatsList, closure: {
                let newChatRoom = ChatRoom.new(self.moc, _isGroup: false, _nameChat: self.getNameForContactNumber(number), _admin: User.currentUser!.number, _id: -1)
                let request = CreateRequest.create2UserConversation(User.currentUser!.number, second: number, title: self.getNameForContactNumber(number))
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    synced(self.chatsList, closure: {
                        let jsonContainer = JSONObjectCreator(data: data!, type: JSONObject.TiposDeJSON.NewChatRoom, error: error)
                        
                        for jsonObject in jsonContainer.arrayJSONObjects {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.checkForChatRoom(jsonObject, newChatRoom: newChatRoom)
                            })
                        }
                    })
                }
                task.resume()
            })
            return getChatRoomForNumber(number)
        }
    }
    
    // MARK: - Contacts managing
    
    /// Returns the Contact that matches the specified number. Creates a new one if it doesn't exist.
    private func getContactForNumber(number: String) -> Contact {
        let fetchRequestContact = NSFetchRequest(entityName: "Contact")
        let revisarNumero = NSPredicate(format: "number == %@", number)
        fetchRequestContact.predicate = revisarNumero
        if let fetchResultsContact = (try? moc.executeFetchRequest(fetchRequestContact)) as? [Contact] {
            if fetchResultsContact.count == 0 {
                let name = getNameForContactNumber(number)
                let newContact = Contact.new(moc, name: name, number: number)
                return newContact
            } else if fetchResultsContact.count == 1{
                return fetchResultsContact[0]
            } else {
                NSLog("ERROR---\nTenemos dos contacts para el mismo number")
            }
        }
        return [Contact]()[0]
    }
    
    public func getNameForContactNumber(number: String) -> String {
        if !diccionarioNumeroPersonABRecord.keys.contains(number) {
            createArrayNumberName()
        }
        let person: ABRecord? = diccionarioNumeroPersonABRecord[number]
        var name = ""
        let nameRaw = ABRecordCopyCompositeName(person)
        if let nameRawNotNil = nameRaw {
            name = nameRawNotNil.takeRetainedValue() as String
        }
        name = name != "" ? name : number
        return name
    }
    
    private func createArrayNumberName() {
        diccionarioNumeroPersonABRecord.removeAll(keepCapacity: false)
        let allPeople = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray
        for personRecord in allPeople {
            let phones : ABMultiValueRef = ABRecordCopyValue(personRecord, kABPersonPhoneProperty).takeRetainedValue()
            if let copyArrayOfAllValues = ABMultiValueCopyArrayOfAllValues(phones) {
                for numberRaw in copyArrayOfAllValues.takeRetainedValue() as NSArray {
                    let numberRawString = numberRaw as? String
                    if numberRawString == nil {
                        NSLog("Error un number es nil #007")
                        return
                    }
                    let number = cleanNumber(numberRawString!)
                    if diccionarioNumeroPersonABRecord.indexForKey(number) != nil {
                        NSLog("Hay un number duplicado (en dos contacts)\nNumero: " + number)
                    } else {
                        diccionarioNumeroPersonABRecord[number] = personRecord as ABRecord
                    }}}}
    }
    
    // MARK: - View managing
    
    /// Reloads the list of chatRooms if the delegate is set.
    private func reloadChatRooms() {
        if let delegate = chatRoomListDelegate {
            delegate.reloadChatRooms()
        }
    }
    
    /// Reloads the list of chatMessages of a chatRoom if the delegate is set.
    private func reloadChatMessages() {
        if let delegate = chatMessageListDelegate {
            delegate.reloadChatRoom()
        }
    }
    
    // MARK: - Database management
    
    /// Checks if moc != nil. If != nil, returns true. Else, tries to getMoc() 5 times, if 5 fails returns false.
    private func checkMoc(numberOfTries: Int=0) -> Bool {
        if numberOfTries > 5 {
            NSLog("Error moc was nil more than 5 times #006")
            return false
        } else if self.moc == nil {
            NSLog("Error moc is nil #003")
            getMoc()
            return checkMoc(numberOfTries + 1)
        }
        return true
    }
    
    /// Gets the moc from the AppDelegate.
    private func getMoc() {
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    /// Updates chatsList with the latest fetch.
    private func fetchChatRooms() {
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let fetchRequest = NSFetchRequest(entityName: "ChatRoom")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            if let fetchResults = (try moc.executeFetchRequest(fetchRequest)) as? [ChatRoom] {
                chatsList = fetchResults
            }
        } catch {
            
        }
    }
    
}