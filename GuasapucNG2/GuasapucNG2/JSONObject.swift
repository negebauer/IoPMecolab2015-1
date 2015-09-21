//
//  JSONObject.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 20-09-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// Contains the information of each JSONObject
class JSONObject : NSObject {
    
    enum TiposDeJSON {
        case
        ChatRoom,
        ChatMessage,
        MiembroChat
    }
    
    var id: Int?
    var title: String?
    var url_message: String?
    var group: Bool?
    var admin: String?
    var mime_type: String?
    var url_file: String?
    var phone_number: String?
    var name: String?
    var content: String?
    var sender: String?
    var conversation_id: Int?
    var created_at: String?
    
    /// Checks if the JSONObject has the information that it should have.
    func compliesWithType(type: TiposDeJSON) -> Bool {
        switch type {
        case .ChatRoom:
            return isChatRoom()
        case .ChatMessage:
            return isChatMessage()
        case .MiembroChat:
            return isChatMember()
        }
    }
    
    /// Checks if the JSONObject has information about a file.
    func hasFile() -> Bool {
        if mime_type != "" && url_file != "" {
            return true
        }
        return false
    }
    
    /// Checks if JSONObject represents a chatRoom.
    private func isChatRoom() -> Bool {
        /* Formato de cada json
        "id": 19,
        "title": "titulo",
        "group": true,
        "admin": 56962448489
        */
        if id != nil && title != nil && group != nil && admin != nil {
            return true
        }
        return false
    }
    
    /// Checks if JSONObject represents a chatMessage.
    private func isChatMessage() -> Bool {
        /* Formato de cada json
        "id": 1000,
        "sender": "56962448489",
        "content": null,
        "conversation_id": 103,
        "created_at": "2015-09-07T14:56:57.212Z",
        "file": {
            "url": "http://guasapuc.herokuapp.com/system/message_contents/contents/000/000/151/original/1441637814957.jpg?1441637817",
            "mime_type": "image/jpeg"
        },
        "url": "http://guasapuc.herokuapp.com/messages/1000.json"
        */
        
        if id != nil && sender != nil && content != nil && conversation_id != nil && created_at != nil && url_message != nil {
            // Mensaje normal
            url_file = ""
            mime_type = ""
            return true
        } else if id != nil && sender != nil && mime_type != nil && url_file != nil && conversation_id != nil && created_at != nil && url_message != nil {
            // Mensaje con archivo
            content = "Click to view image"
            return true
        }
        return false
    }
    
    /// Checks if JSONObject representes the information of a chatRoom member.
    private func isChatMember() -> Bool {
        /* Formato de cada json
        "id": 60,
        "name": "user4",
        "phone_number": "44",
        "url": "http://localhost:3000/users/60.json"
        */
        if id != nil && name != nil && phone_number != nil && url_message != nil {
            return true
        }
        return false
    }
    
}
