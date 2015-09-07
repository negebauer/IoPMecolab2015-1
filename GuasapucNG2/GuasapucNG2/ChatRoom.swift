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
    @NSManaged var isGroup: NSNumber
    @NSManaged var nombreChat: String
    @NSManaged var updatedAt: NSDate
    @NSManaged var user: User
    @NSManaged var chatMembers: NSSet   //Set de Contacto
    @NSManaged var chatMessages: NSSet  //Set de ChatMessage

    class func new(moc: NSManagedObjectContext, _isGroup:Bool, _nombreChat:String, _admin:String, _id:Int) -> ChatRoom {
        let newChat = NSEntityDescription.insertNewObjectForEntityForName("ChatRoom", inManagedObjectContext: moc) as! GuasapucNG2.ChatRoom
        newChat.user = User.currentUser!
        newChat.nombreChat = _nombreChat
        newChat.isGroup = _isGroup
        newChat.updatedAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        newChat.admin = _admin
        newChat.id = _id
        
        return newChat
    }
    
    ///Ads a contact to this chatRoom members. Returns true if success, false if duplicated or failed
    func addMemberToChat(contact:Contacto) -> Bool {
        var arrayMembers = chatMembers.allObjects as? [Contacto]
        if arrayMembers == nil { return false }
        if !contains(arrayMembers!, contact) {
            arrayMembers!.append(contact)
            chatMembers = NSSet(array: arrayMembers!)
            return true
        }
        return false
    }
    
}