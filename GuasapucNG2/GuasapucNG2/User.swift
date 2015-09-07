//
//  User.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject {

    @NSManaged var numero: String
    @NSManaged var chatRooms: NSSet //Set de ChatRoom

    class func new(moc: NSManagedObjectContext) -> User {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! GuasapucNG2.User
        newUser.numero = "56962448489"
        
        return newUser
    }
    
    static var currentUser: User? {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
        }
        set {
            (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser = newValue
        }
    }
    
    class func fetchUser() -> User? {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        if let fetchResults = moc?.executeFetchRequest(fetchRequest, error: nil) as? [User] {
            return fetchResults.count == 1 ? fetchResults[0] : nil
        }
        else {
            return nil
        }
    }
    
    class func checkUser() {
        currentUser = fetchUser()
        if currentUser == nil {
            let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            if moc == nil {
                NSLog("Error moc is nil #004")
                return
            }
            currentUser = new(moc!)
            moc!.save(nil)
        }
    }
}

/*
static var currentUser: Usuario? {
get {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).usuarioApp
}
set {
    (UIApplication.sharedApplication().delegate as! AppDelegate).usuarioApp = newValue
}
}

class func fetchUser() -> Usuario? {
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "Usuario")
    if let fetchResults = moc?.executeFetchRequest(fetchRequest, error: nil) as? [Usuario] {
        return fetchResults.count == 1 ? fetchResults[0] : nil
    }
    else {
        return nil
    }
}
*/