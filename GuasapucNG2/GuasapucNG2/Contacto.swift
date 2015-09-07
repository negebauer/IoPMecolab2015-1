//
//  Contacto.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class Contacto: NSManagedObject {

    @NSManaged var nombre: String
    @NSManaged var numero: String
    @NSManaged var chatRooms: NSSet //Set de ChatRoom

    
    class func new(moc: NSManagedObjectContext, nombre:String, numero:String) -> Contacto {
        let newContact = NSEntityDescription.insertNewObjectForEntityForName("Contacto", inManagedObjectContext: moc) as! GuasapucNG2.Contacto
        newContact.nombre = nombre
        newContact.numero = numero
        
        return newContact
    }
    
    class func new(moc: NSManagedObjectContext, nombre:String, numero:String, chatRooms:[ChatRoom]) -> Contacto {
        let newContact = NSEntityDescription.insertNewObjectForEntityForName("Contacto", inManagedObjectContext: moc) as! GuasapucNG2.Contacto
        newContact.nombre = nombre
        newContact.numero = numero
        newContact.chatRooms = NSSet(array: chatRooms)
        
        return newContact
    }
    
    ///Ads a chatRoom to this Contact. Returns true if success, false if duplicated or failed
    func addChatRoom(chatRoom:ChatRoom) -> Bool {
        var arrayChats = chatRooms.allObjects as? [ChatRoom]
        if arrayChats == nil { return false }
        if !contains(arrayChats!, chatRoom) {
            arrayChats!.append(chatRoom)
            chatRooms = NSSet(array: arrayChats!)
            return true
        }
        return false
    }
    
    ///Removes a chatRoom from this Contact. Returns true if success, false if doesn't exist or failed
    func removeChatRoom(chatRoom:ChatRoom) -> Bool {
        var arrayChats = chatRooms.allObjects as? [ChatRoom]
        if arrayChats == nil { return false }
        if contains(arrayChats!, chatRoom) {
            arrayChats!.removeAtIndex(find(arrayChats!, chatRoom)!)
            return true
        }
        return false
    }
    
}
