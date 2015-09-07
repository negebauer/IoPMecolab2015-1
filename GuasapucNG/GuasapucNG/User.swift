//
//  User.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var numero: String
    @NSManaged var chatRooms: NSSet

    class func new(moc: NSManagedObjectContext, _numero:String) -> User {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! GuasapucNG.User
        newItem.numero = _numero
        
        return newItem
    }
}
