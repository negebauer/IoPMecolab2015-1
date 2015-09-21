//
//  ChatMessage.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class ChatMessage: NSManagedObject {

    @NSManaged var sender: String
    @NSManaged var createdAt: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var content: String
    @NSManaged var isFile: Bool
    @NSManaged var fileURL: String
    @NSManaged var mimeType: String
    @NSManaged var chatRoom: ChatRoom
    
    /// Creates and returns a new chatMessage. Also calls chatRoom.addChatMessageToChat to make the connection right away.
    class func new(moc: NSManagedObjectContext, sender: String, content: String, createdAt: String, id: Int, isFile: Bool, fileURL: String, mimeType: String, chatRoom: ChatRoom) -> ChatMessage {
        let newMessage = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: moc) as! GuasapucNG2.ChatMessage
        
        newMessage.sender = sender
        newMessage.content = content
        newMessage.createdAt = getDateFromString(createdAt)
        newMessage.id = id
        newMessage.isFile = isFile
        newMessage.fileURL = fileURL
        newMessage.mimeType = mimeType
        chatRoom.addChatMessageToChat(newMessage)
        
        return newMessage
    }
}
