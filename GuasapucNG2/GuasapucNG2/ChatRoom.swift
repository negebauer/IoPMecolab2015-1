//
//  ChatRoom.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class ChatRoom: NSManagedObject {

    @NSManaged var admin: String
    @NSManaged var id: NSNumber
    @NSManaged private var isGroup: NSNumber
    @NSManaged var nombreChat: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var user: User
    @NSManaged private var chatMembers: NSSet   //Set de Contacto
    @NSManaged private var chatMessages: NSSet  //Set de ChatMessage
    
    /// Returns the array of chatMessages sorted
    var arrayMessage: [ChatMessage] {
        var tempArray = chatMessages.allObjects as! [ChatMessage]
        tempArray.sortInPlace({ message1, message2 in return !isDate1GreaterThanDate2(message1.createdAt, date2: message2.createdAt) })
        return tempArray
    }
    
    /// Returns the number of the chat destinatary if this chatRoom is not a group
    var number: String {
        let arrayMembers = chatMembers.allObjects as! [Contacto]
        if arrayMembers.count > 0 && !group {
            return arrayMembers[0].numero
        }
        return ""
    }
    
    /// Returns all the numbers that take part in this chatRoom only if it's a group
    var numbers: [String] {
        let arrayMembers = chatMembers.allObjects as! [Contacto]
        if arrayMembers.count > 0 && group {
            var arrayNumbers = [String]()
            for contact in arrayMembers {
                arrayNumbers.append(contact.numero)
            }
            return arrayNumbers
        }
        return [""]
    }
    
    /// Returns true if the chatRoom is a group, false if else
    var group: Bool {
        return Bool(isGroup)
    }
    
    var ultimoMensaje: String {
        let lastMessage = arrayMessage.last?.content
        return lastMessage != nil ? lastMessage! : "THERE IS NO LAST MESSAGE"
    }

    class func new(moc: NSManagedObjectContext, _isGroup: Bool, _nombreChat: String, _admin: String, _id: Int) -> ChatRoom {
        let newChat = NSEntityDescription.insertNewObjectForEntityForName("ChatRoom", inManagedObjectContext: moc) as! GuasapucNG2.ChatRoom
        newChat.user = User.currentUser!
        newChat.nombreChat = _nombreChat
        newChat.isGroup = _isGroup
        newChat.updatedAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        newChat.admin = _admin
        newChat.id = _id
        
        return newChat
    }
    
    ///Adds a contact to this chatRoom members. Returns true if success, false if duplicated or failed.
    /// Also adds this chatRoom to the contact's chatRooms reference.
    func addMemberToChat(contact: Contacto) -> Bool {
        var arrayMembers = chatMembers.allObjects as? [Contacto]
        if arrayMembers == nil { return false }
        if !(arrayMembers!).contains(contact) {
            arrayMembers!.append(contact)
            chatMembers = NSSet(array: arrayMembers!)
            contact.addChatRoom(self)
            return true
        }
        return false
    }
    
    /// Adds a chatMessage to this chatRooms messages. Returns true if success, false if duplicated or failed.
    /// Also adds this chatRoom to the chatMessage chatRoom reference.
    /// Also updates the chatRoom updatedAt if the chatMessage.createdAt is more recent
    func addChatMessageToChat(message: ChatMessage) -> Bool {
        var messages = chatMessages.allObjects as! [ChatMessage]
        if !messages.contains(message) {
            messages.append(message)
            chatMessages = NSSet(array: messages)
            if isDate1GreaterThanDate2(message.createdAt, date2: updatedAt) {
                updatedAt = message.createdAt
            }
            return true
        }
        return false
    }
    
    /// Checks if a given message is in this chatRoom
    func containsMessageWithID(id: Int) -> Bool {
        let messages = chatMessages.allObjects as! [ChatMessage]
        if messages.contains({message in message.id == id}) {
            return true
        }
        return false
    }
}