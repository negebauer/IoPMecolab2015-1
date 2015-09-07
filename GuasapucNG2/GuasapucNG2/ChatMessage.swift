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

    @NSManaged var content: String
    @NSManaged var createdAt: NSDate
    @NSManaged var id: NSNumber
    @NSManaged var sender: String
    @NSManaged var chatRoom: ChatRoom

}
