//
//  ChatRoom.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 29-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class ChatRoom: NSManagedObject {

    @NSManaged var isGroup: Bool
    @NSManaged var mensajes: [ChatMessage]
    @NSManaged var updatedAt: String
    ///Debes asegurarte que users[0] sea currentUser
    @NSManaged var users: [Contacto]

    class func createInManagedObjectContext(moc:NSManagedObjectContext, _isGroup:Bool, _mensajes:[ChatMessage], _updatedAt:String, _users:[Contacto]) -> ChatRoom {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatRoom", inManagedObjectContext: moc) as! ChatRoom
        
        newItem.isGroup = _isGroup
        newItem.mensajes = _mensajes
        newItem.updatedAt = _updatedAt
        newItem.users = _users
        
        return newItem
    }
}
