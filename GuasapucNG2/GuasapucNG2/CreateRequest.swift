//
//  CreateRequest.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI
import CoreData
import UIKit

/// Manages the creation of requests
class CreateRequest {
   
    private static let host = "https://guasapuc.herokuapp.com/"
    private static let user = "Nicolas Gebauer"
    private static let userNumber = "56962448489" //"56981362982"
    private static let userLink = "\(host)users/5"
    
    static var tokenFormatted: String {
        return "Token token=\(User.currentUser!.token)"
    }
    
    static let sendFileMessageURL = "\(host)api/v2/conversations/send_file_message"
}

// Basic functions
extension CreateRequest {
    
    ///Creates a NSMutableURLRequest provided an URL
    private static func makeRequest(url:String) -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: NSURL(string: url)!)
    }
    
    ///Adds the tokenFormatted to the request
    private static func configureHTTPHeader(request:NSMutableURLRequest) -> NSMutableURLRequest {
        request.addValue(self.tokenFormatted, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    ///Adds the HTTPMethod GET to the request and the header
    private static func makeGETRequest(request:NSMutableURLRequest) -> NSMutableURLRequest {
        request.HTTPMethod = "GET"
        return self.configureHTTPHeader(request)
    }
    
    ///Adds the HTTPMethod POST to the request and the header. Also, add obj as its body in JSON format
    private static func makePOSTRequest(request:NSMutableURLRequest, obj:AnyObject) -> NSMutableURLRequest {
        request.HTTPMethod = "POST"
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions())
        request.HTTPBody = jsonData
        return self.configureHTTPHeader(request)
    }
    
    ///Adds the HTTPMethod DELETE to the request and the header
    private static func makeDELETERequest(request:NSMutableURLRequest) -> NSMutableURLRequest {
        request.HTTPMethod = "DELETE"
        return self.configureHTTPHeader(request)
    }
}

// Public functions
extension CreateRequest {
    ///Creates the request for getting the user token
    static func getToken() -> NSMutableURLRequest {
        let request = makeRequest("\(host)/users.json")
        return makeGETRequest(request)
    }
    
    ///Receives two numbers and creates a conversation between them with a given title
    static func create2UserConversation(first:String, second:String, title:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/create_two_conversation")
        let obj = ["first":first, "second":second, "title":title]
        return makePOSTRequest(request, obj: obj)
    }
    
    ///Receives an admin and a list of members and makes a group conversation with a given title.
    ///The admin number should not be in the users array, still checks for it
    static func createGroupConversation(admin:String, users:[String], title:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/create_group_conversation")
        var usersFiltered = users
        while usersFiltered.contains(admin) {
            usersFiltered.removeAtIndex(usersFiltered.indexOf(admin)!)
        }
        let obj = ["admin": admin, "users": usersFiltered, "title": title]
        return makePOSTRequest(request, obj: obj)
    }
    
    ///Request for getting users in a conversation
    static func usersInConversation(id:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/get_users?conversation_id="+id)
        return makeGETRequest(request)
    }
    
    ///Request for getting messages in a conversation
    static func messagesInConversation(id:Int) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/get_messages?conversation_id="+String(id))
        return makeGETRequest(request)
    }
    
    ///Request for adding a user to a conversation
    static func addUserToConversation(number:String, id:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/add_user")
        let obj = ["phone_number":number, "conversation_id":id]
        return makePOSTRequest(request, obj: obj)
    }
    
    ///Request to delete a user from a conversation
    static func deleteUserFromConversation(number:String, id:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/remove_user?phone_number="+number+"&conversation_id="+id)
        return makeDELETERequest(request)
    }
    
    ///Request to send a message to a conversation
    static func sendMessageToConversation(content:String, sender:String, id:Int) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/conversations/send_message")
        let obj = ["conversation_id": String(id), "phone_number": sender, "content": content]
        return makePOSTRequest(request, obj: obj)
    }
    
    ///Request to get conversations of a user
    static func userConversations(number:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/users/get_conversations?phone_number="+number)
        return makeGETRequest(request)
    }
    
    ///Request to get conversations of user self (predetermined)
    static func userConversations() -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/users/get_conversations?phone_number="+self.userNumber)
        return makeGETRequest(request)
    }
    
    ///Request to get a user
    static func getUser(number:String) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/users/show?phone_number="+number)
        return makeGETRequest(request)
    }
    
    ///Request to add a user to the web database
    static func addUserToDB(name:String, number:String, pass:String) ->NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/users")
        let obj = ["name":name, "phone_number":number, "password":pass]
        return makePOSTRequest(request, obj: obj)
    }
    
    ///Request to share location with a list of users
    static func shareLocationWithUsers(port:String, users:[String]) -> NSMutableURLRequest {
        let request = makeRequest("\(host)api/v2/shared_locations")
        let obj = ["sender":self.userNumber, "ip":IPGetter.getLocalAddress(), "port":port, "users":users]
        return makePOSTRequest(request, obj: obj)
    }

    ///Request to get what users a sharing their location with me (on what ports)
    static func sharedLocations() -> NSMutableURLRequest {
        let request  = makeRequest("\(host)api/v2/shared_locations?phone_number="+self.userNumber)
        return makeGETRequest(request)
    }
}
