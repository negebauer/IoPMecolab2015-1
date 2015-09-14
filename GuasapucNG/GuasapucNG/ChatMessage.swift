//
//  ChatMessage.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class ChatMessage: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var createdAt: NSDate
    @NSManaged var sender: String
    @NSManaged var chatRoom: ChatRoom
    @NSManaged var id: Int
    @NSManaged var hasURL: Bool
    @NSManaged var url: String
    
    
    
    class func new(moc: NSManagedObjectContext, _sender:String, _content:String, _createdAtString:String, _id:Int) -> ChatMessage {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! GuasapucNG.ChatMessage
        
        newItem.content = _content
        newItem.sender = _sender
        newItem.createdAt = Common.getDateFromString(_createdAtString)
        newItem.id = _id
        newItem.hasURL = false
        
        return newItem
    }
    
    class func new(moc: NSManagedObjectContext, _sender:String, _content:String, _createdAtDate:NSDate, _id:Int) -> ChatMessage {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! GuasapucNG.ChatMessage
        
        newItem.content = _content
        newItem.sender = _sender
        newItem.createdAt = _createdAtDate
        newItem.id = _id
        newItem.hasURL = false
        
        return newItem
    }
    
    func asignarChatRoom(_chatRoom:ChatRoom) {
        chatRoom = _chatRoom
    }
    
    class func new(moc: NSManagedObjectContext, _sender:String, _content:String, _id:Int) -> ChatMessage {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! GuasapucNG.ChatMessage
        
        newItem.content = _content
        newItem.sender = _sender
        newItem.createdAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        newItem.id = _id
        newItem.hasURL = false
        
        return newItem
    }
    
    class func new(moc: NSManagedObjectContext, _sender:String, _content:String) -> ChatMessage {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! GuasapucNG.ChatMessage
        
        newItem.content = _content
        newItem.sender = _sender
        newItem.createdAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        newItem.id = -1
        newItem.hasURL = false
        
        return newItem
    }
    
    class func new(moc: NSManagedObjectContext, _sender:String, _content:String, _hasURL:Bool, _url:String, _id:Int) -> ChatMessage {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! GuasapucNG.ChatMessage
        
        newItem.content = _content
        newItem.sender = _sender
        newItem.createdAt = NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        newItem.id = _id
        newItem.hasURL = _hasURL
        newItem.url = _url
        
        return newItem
    }
}
