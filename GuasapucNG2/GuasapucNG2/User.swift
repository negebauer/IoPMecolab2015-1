//
//  User.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import CoreData

/// Stores the user number and chatRooms that the user is participating in.
class User: NSManagedObject {

    @NSManaged var numero: String
    @NSManaged var chatRooms: NSSet //Set de ChatRoom
    @NSManaged var token: String

    weak var chatManager: ChatManager?
    
    /// Creates and returns a new user.
    class func new(moc: NSManagedObjectContext) -> User {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! GuasapucNG2.User
        newUser.numero = "56962448489"
        newUser.token = ""
        
        return newUser
    }
    
    /// Gets the user token
    func getToken() {
        let request = CreateRequest.getToken()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            let jsonContainer = JSONObjectCreator(data: data, type: JSONObject.TiposDeJSON.Token, error: error)
            let jsonObjectArray = jsonContainer.arrayJSONObjects.filter({ object in return object.phone_number! == self.numero })
            if jsonObjectArray.count > 0 {
                self.token = jsonObjectArray.first!.token!
                self.chatManager?.updateChats()
                saveDatabase()
            }
            
        }
        task.resume()
    }
    
    /// Gets/sets the current user.
    static var currentUser: User? {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
        }
        set {
            (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser = newValue
        }
    }
    
    /// Fetches the current user. Returns nil if it doesn't exits
    class func fetchUser() -> User? {
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        if let fetchResults = (try? moc?.executeFetchRequest(fetchRequest)) as? [User] {
            return fetchResults.count == 1 ? fetchResults[0] : nil
        } else {
            return nil
        }
    }
    
    /// Checks the existance of the current user. If it doesn't exist it creates a new one.
    class func checkUser() {
        currentUser = fetchUser()
        if currentUser == nil {
            let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            if moc == nil {
                NSLog("Error moc is nil #004")
                return
            }
            currentUser = new(moc!)
            do {
                try moc!.save()
            } catch let error as NSError {
                NSLog("Error grabando base de datos: \(error.localizedDescription)")
            }}
    }
    
    override var description: String {
        return
            [
                "numero = \(numero)",
                "number of chats = \(chatRooms.count)",
                "token = \(token)"
            ].joinWithSeparator("\n")
    }
}