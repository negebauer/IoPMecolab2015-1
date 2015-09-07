//
//  ChatMessage.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 29-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class ChatMessage: NSManagedObject {

    @NSManaged var createdAt: String
    @NSManaged var id: NSNumber
    @NSManaged var message: String
    @NSManaged var recipient: Contacto
    @NSManaged var sender: Contacto
    @NSManaged var url: String
    
    class func createInManagedObjectContext(moc:NSManagedObjectContext, _id:Int, _createdAt:String, _message:String, _recipient:Contacto, _sender:Contacto, _url:String) -> ChatMessage {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! IoP_App_3.ChatMessage
        
        newItem.createdAt = _createdAt
        newItem.id = _id
        newItem.message = _message
        newItem.recipient = _recipient
        newItem.sender = _sender
        newItem.url = _url
        
        return newItem
    }
}
