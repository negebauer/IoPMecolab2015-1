//
//  ChatRoom.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class ChatRoom: NSManagedObject {

    @NSManaged var id:Int
    @NSManaged var admin: String
    @NSManaged var isGroup: Bool
    @NSManaged var nombreChat: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var chatNumbers: NSSet
    @NSManaged var chatMembers: NSSet
    @NSManaged var chatMessages: NSOrderedSet
    @NSManaged var user: User
    
    class func new(moc: NSManagedObjectContext, _isGroup:Bool, _nombreChat:String, _numbers:[String], _members:[Contacto], _messages:[ChatMessage], _admin:String, _id:Int) -> ChatRoom {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatRoom", inManagedObjectContext: moc) as! GuasapucNG.ChatRoom
        newItem.user = Common.getCurrentUser()
        newItem.nombreChat = _nombreChat
        newItem.isGroup = _isGroup
        newItem.updatedAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        Common.synced(self, closure: {
            for num in _numbers {
                newItem.addNumberToChat(num)
            }
            for member in _members {
                newItem.addMemberToChat(member)
            }
            for message in _messages {
                newItem.addMessageToChat(message)
            }
        })
        newItem.admin = _admin
        newItem.id = _id
        
        return newItem
    }
    
    class func new(moc: NSManagedObjectContext, _isGroup:Bool, _nombreChat:String, _admin:String, _id:Int) -> ChatRoom {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatRoom", inManagedObjectContext: moc) as! GuasapucNG.ChatRoom
        newItem.user = Common.getCurrentUser()
        newItem.nombreChat = _nombreChat
        newItem.isGroup = _isGroup
        newItem.updatedAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        newItem.admin = _admin
        newItem.id = _id
        
        return newItem
    }
    
    ///Returns the numbers in the chat
    func getChatNumbers() -> Set<String> {
        let numbers = chatNumbers as! Set<String>
        return numbers
    }
    
    //Adds a new number to the chat
    func addNumberToChat(num:String) {
        var numbers = chatNumbers as! Set<String>
        numbers.insert(num)
        chatNumbers = numbers
    }
    
    ///Returns the contacts in the chat
    func getChatMembers() -> Set<Contacto> {
        let members = chatMembers as! Set<Contacto>
        return members
    }
    
    ///Adds a new contact to the chat
    func addMemberToChat(c:Contacto) {
        var members = chatMembers as! Set<Contacto>
        members.insert(c)
        chatMembers = members
        Common.saveData()
    }
    
    ///Adds an array of new contacts to the chat
    func addMembersToChat(array:[Contacto]) {
        for c in array {
            addMemberToChat(c)
        }
    }

    ///Returns the messages in the chat
    func getMessagesInChat() -> [ChatMessage] {
        if chatMessages.count == 0 { return [ChatMessage]() }
        let messages = chatMessages.array as! [ChatMessage]
        return messages
    }
    
    ///Adds a message to the chat and updates updatedAt attribute if necessary
    func addMessageToChat(message:ChatMessage) {
        var messages: [ChatMessage]!
        if chatMessages.count == 0 {
            messages = [ChatMessage]()
        }
        else {
            messages = chatMessages.array as! [ChatMessage]
        }
        messages.append(message)
        chatMessages = NSOrderedSet(array: messages)
        if Common.isDateGreaterThanDate(message.createdAt, date2: updatedAt) {
            updatedAt = message.createdAt
        }
        message.asignarChatRoom(self)
        Common.saveData()
    }
    
    ///Adds an array of messages to the chat and updates updatedAt attribute if necessary
    func addMessagesToChat(array:[ChatMessage]) {
        for m in array {
            addMessageToChat(m)
        }
    }
    
    ///Retorna el ultimo mensaje enviado en el chat
    func getLastMessage() -> String {
        if chatMessages.count == 0 {
            return "---"
        }
        let messages = chatMessages.array as! [ChatMessage]
        return last(messages)!.content
    }
}
