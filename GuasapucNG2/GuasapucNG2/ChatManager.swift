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

protocol ChatManagerDelegate {
    func reloadChatRooms()
    var table: UITableView { get }
}

protocol ChatRoomManagerDelegate {
    
}

// MARK: - Chat manager class

class ChatManager {
    let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var diccionarioNumeroPersonABRecord = Dictionary<String,ABRecord>()
    var listaChats = [ChatRoom]()
    var moc: NSManagedObjectContext!
    var chatListDelegate: ChatManagerDelegate?              //Vista de todos los chats
    var chatRoomDelegate: ChatRoomManagerDelegate?  //Vista del ChatRoom que se esta mostrando actualmente
    
    init() {
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        fetchChatRooms()
        reload()
    }
    
    // MARK: - Chat update general functions
    
    func updateChats() {
        checkWebForNewChatRooms()
    }
    
    func updateChat(chat:ChatRoom) {
        
    }
    
    // MARK: - Chat update specific functions
    
    func checkWebForNewChatRooms() {
        let request = CreateRequest.userConversations()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                NSLog("Error checking for new chats #001\n\(error.localizedDescription)")
                return
            }
            
            let jsonSwift: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    /* Formato de cada json
                    "id": 19,
                    "title": "titulo",
                    "url": "http://localhost:3000/conversation/19.json"
                    */
                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                        let id = diccionarioMensaje["id"] as? Int
                        let isGroup = diccionarioMensaje["group"] as? Bool
                        let title = diccionarioMensaje["title"] as? String
                        let admin = diccionarioMensaje["admin"] as? String
                        
                        if id == nil || isGroup == nil || title == nil || admin == nil {
                            NSLog("Error getting a chat room info message #002")
                        }
                        
                        self.checkForChatRoom(id!, title: title!, admin: admin!, isGroup: isGroup!)
                    }
                }
            }
        }
        task.resume()
    }
    
    ///Checks the existance of a chat room. If it doesn't exist, it creates it and tries to get messages. If exist, ignores
    func checkForChatRoom(id:Int, title:String, admin:String, isGroup:Bool) {
        fetchChatRooms()
        synced(listaChats, {
            if filter(self.listaChats, {c in return c.id == id}).count > 0 {
                return  //Ya existe
            }
            if self.moc == nil {
                NSLog("Error moc is nil #003")
                return
            }
            let newChatRoom = ChatRoom.new(self.moc!, _isGroup: isGroup, _nombreChat: title, _admin: admin, _id: id)
            self.saveDatabase()
            self.getUsersOfChat(newChatRoom)
            self.fetchChatRooms()
        })
        reload()
    }
    
    ///Checks the list of users of a certain chat
    func getUsersOfChat(chat:ChatRoom) {
        let request = CreateRequest.usersInConversation(chat.id.stringValue)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                NSLog("Error getting users in conversation with id: \(chat.id) #005")
            }
            
            let jsonSwift: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    /* Formato de cada json
                    "id": 60,
                    "name": "user4",
                    "phone_number": "44",
                    "url": "http://localhost:3000/users/60.json"
                    */
                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                        let number = diccionarioMensaje["phone_number"] as? String
                        if number == nil {
                            NSLog("Error getting a user number #006")
                            return
                        }
                        let contact = self.getContactForNumber(number!)
                        chat.addMemberToChat(contact)
                        contact.addChatRoom(chat)
                    }
                }
            }
        }
    }
    
    // MARK: - Contacts managing
    
    ///Returns the Contact that matches the specified number. Creates a new one if it doesn't exist
    func getContactForNumber(number:String) -> Contacto {
        let fetchRequestContacto = NSFetchRequest(entityName: "Contacto")
        let revisarNumero = NSPredicate(format: "numero == %@", number)
        fetchRequestContacto.predicate = revisarNumero
        if let fetchResultsContacto = moc.executeFetchRequest(fetchRequestContacto, error: nil) as? [Contacto] {
            if fetchResultsContacto.count == 0 {
                let nombre = getNameForContactNumber(number)
                let newContact = Contacto.new(moc, nombre: nombre, numero: number)
                return newContact
            }
            else if fetchResultsContacto.count == 1{
                return fetchResultsContacto[0]
            }
            else {
                NSLog("ERROR---\nTenemos dos contactos para el mismo numero")
            }
        }
        return [Contacto]()[0]
    }
    
    func getNameForContactNumber(number:String) -> String {
        if !contains(diccionarioNumeroPersonABRecord.keys, number) {
            createArrayNumberName()
        }
        let person: ABRecord? = diccionarioNumeroPersonABRecord[number]
        var nombre = ""
        let nombreRaw = ABRecordCopyCompositeName(person)
        if nombreRaw != nil {
            nombre = ABRecordCopyCompositeName(person).takeRetainedValue() as! String
        }
        nombre = nombre != "" ? nombre : number
        return nombre
    }
    
    func createArrayNumberName() {
        diccionarioNumeroPersonABRecord.removeAll(keepCapacity: false)
        let allPeople = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray
        for personRecord in allPeople {
            let phones : ABMultiValueRef = ABRecordCopyValue(personRecord, kABPersonPhoneProperty).takeRetainedValue()
            if ABMultiValueCopyArrayOfAllValues(phones) != nil {
                for numeroRaw in ABMultiValueCopyArrayOfAllValues(phones).takeRetainedValue() as NSArray {
                    var numeroRawString = numeroRaw as? String
                    if numeroRawString == nil {
                        NSLog("Error un numero es nil #007")
                        return
                    }
                    let numero = limpiarNumero(numeroRawString!)
                    if diccionarioNumeroPersonABRecord.indexForKey(numero) != nil {
                        NSLog("Hay un numero duplicado (en dos contactos)\nNumero: " + numero)
                    }
                    else {
                        diccionarioNumeroPersonABRecord[numero] = personRecord as ABRecord
                    }}}}
    }
    
    // MARK: - View managing
    
    func reload() {
        if chatListDelegate != nil {
            chatListDelegate!.reloadChatRooms()
        }
    }
    
    // MARK: - Database management
    
    private func getMoc() {
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    private func fetchChatRooms() {
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let fetchRequest = NSFetchRequest(entityName: "ChatRoom")
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [ChatRoom] {
            listaChats = fetchResults
        }
    }
    
    private func saveDatabase() {
        var error: NSError?
        if let m = moc {
            if m.save(&error) { }
            else if error != nil {
                NSLog("Error grabando base de datos: \(error?.localizedDescription)")
            }
        }
    }
}
/*
//Descargo los miembros del chat y los agrego al chat
let requestMiembrosGrupo = Common.getRequestGetUsersInConversation(String(id))
let taskMiembrosGrupo = NSURLSession.sharedSession().dataTaskWithRequest(requestMiembrosGrupo) {
data, response, error in

let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)

if let jsonArray = jsonSwift as? NSArray {
for jsonMensaje in jsonArray {
if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
let number = diccionarioMensaje["phone_number"] as! String
let c = self.getContactForNumber(number)
newChatRoom.addMemberToChat(c)
}}}}

//Descargo los mensajes del chat y los agrego al chat
let requestMensajesGrupo = Common.getRequestGetMessagesInConversation(id)
let taskMensajesGrupo = NSURLSession.sharedSession().dataTaskWithRequest(requestMensajesGrupo) {
data, response, error in

let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)

if let jsonArray = jsonSwift as? NSArray {
for jsonMensaje in jsonArray {
if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
let id = diccionarioMensaje["id"] as! Int
let sender = diccionarioMensaje["sender"] as! String
let content = diccionarioMensaje["content"] as! String
let createdAtString = diccionarioMensaje["created_at"] as! String
let date = Common.getDateFromString(createdAtString)
let m = self.getMessageForData(id, sender: sender, content: content)
m.createdAt = date
}}}}

Common.synced(chatRooms, closure: {self.chatRoomsGroups.append(newChatRoom)})
ordenarListaChats()
fetchChatRooms()
reloadData()
taskMensajesGrupo.resume()
taskMiembrosGrupo.resume()
*/