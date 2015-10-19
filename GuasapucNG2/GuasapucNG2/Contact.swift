//
//  Contact.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var number: String
    @NSManaged var chatRooms: NSSet //Set de ChatRoom

    
    class func new(moc: NSManagedObjectContext, name: String, number: String) -> Contact {
        let newContact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: moc) as! GuasapucNG2.Contact
        newContact.name = name
        newContact.number = number
        
        return newContact
    }
    
    ///Ads a chatRoom to this Contact. Returns true if success, false if duplicated or failed
    func addChatRoom(chatRoom: ChatRoom) -> Bool {
        var arrayChats = chatRooms.allObjects as? [ChatRoom]
        if arrayChats == nil { return false }
        if !(arrayChats!).contains(chatRoom) {
            arrayChats!.append(chatRoom)
            chatRooms = NSSet(array: arrayChats!)
            return true
        }
        return false
    }
    
    ///Removes a chatRoom from this Contact. Returns true if success, false if doesn't exist or failed
    func removeChatRoom(chatRoom: ChatRoom) -> Bool {
        var arrayChats = chatRooms.allObjects as? [ChatRoom]
        if arrayChats == nil { return false }
        if (arrayChats!).contains(chatRoom) {
            arrayChats!.removeAtIndex((arrayChats!).indexOf(chatRoom)!)
            return true
        }
        return false
    }
    
}
