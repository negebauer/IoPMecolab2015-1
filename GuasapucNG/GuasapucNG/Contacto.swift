//
//  Contacto.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class Contacto: NSManagedObject {

    @NSManaged var nombre: String
    @NSManaged var numero: String
    @NSManaged var chatRooms: NSSet
    
    class func new(moc: NSManagedObjectContext, _nombre:String, _numero:String) -> Contacto {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Contacto", inManagedObjectContext: moc) as! GuasapucNG.Contacto
        newItem.nombre = _nombre
        newItem.numero = _numero        
        
        return newItem
    }

    ///Returns the ChatRooms that this contact participates in
    func getContactChatRooms() -> Set<ChatRoom> {
        let cr = chatRooms as! Set<ChatRoom>
        return cr
    }

}
