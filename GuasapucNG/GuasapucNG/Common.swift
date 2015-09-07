//
//  Common.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI
import CoreData
import UIKit

class Common {
    static let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext //managedObjectContext
    
    static let messagesURL = "http://guasapuc.herokuapp.com/api/messages"
    static let tokenFormatted = "Token token=jQQNqGlnI2gvLKOG4KeMaQtt"
    static let token = "jQQNqGlnI2gvLKOG4KeMaQtt"
    static let user = "Nicolas Gebauer"
    static let userNumber = "56962448489" //"56981362982"
    
    static func crearAlerta(titulo:String, mensaje:String, view:UIViewController) {
        let alertController = UIAlertController(title: titulo, message:mensaje, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "oh :(", style: .Default, handler: nil))
        view.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func getCurrentUser() -> User {
        let fetchRequest = NSFetchRequest(entityName: "User")
        if let fetchResults = moc!.executeFetchRequest(fetchRequest, error: nil) as? [User] {
            if fetchResults.count == 1 {
                return fetchResults[0]
            }
        }
        return User.new(moc!, _numero: userNumber)
    }
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID.new().UUIDString)"
    }
    
    ///Creates a NSMutableURLRequest provided an URL
    static func makeRequest(url:String) -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: NSURL(string: url)!)
    }
    
    ///Adds the HTTPMethod GET to the request and the header
    static func makeGETRequest(request:NSMutableURLRequest) -> NSMutableURLRequest {
        request.HTTPMethod = "GET"
        request.addValue(self.tokenFormatted, forHTTPHeaderField: "Authorization")
        return request
    }
    
    ///Adds the HTTPMethod POST to the request and the header. Also, add JSONString as its body
    static func makePOSTRequest(request:NSMutableURLRequest, JSONString:String) -> NSMutableURLRequest {
        request.HTTPMethod = "POST"
        request.addValue(self.tokenFormatted, forHTTPHeaderField: "Authorization")
        request.HTTPBody = JSONString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    ///Adds the HTTPMethod DELETE to the request and the header
    static func makeDELETERequest(request:NSMutableURLRequest) -> NSMutableURLRequest {
        request.HTTPMethod = "DELETE"
        request.addValue(self.tokenFormatted, forHTTPHeaderField: "Authorization")
        return request
    }
    
    ///Receives two numbers and creates a conversation between them with a given title
    static func getRequestCreate2UserConversation(first:String, second:String, title:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/create_two_conversation")
        let JSONString = "first="+first+"&second="+second+"&title="+title
        return makePOSTRequest(request, JSONString: JSONString)
    }
    
    ///Receives an admin and a list of members and makes a group conversation with a given title.
    ///The admin number should not be in the users array
    static func getRequestCreateGroupConversation(admin:String, users:[String], title:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/create_group_conversation")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var obj = ["admin": admin, "users": users, "title": title]
        var jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.allZeros, error: nil)
        var jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        return makePOSTRequest(request, JSONString: jsonString)
    }
    
    static func getRequestGetUsersInConversation(id:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/get_users?conversation_id="+id)
        return makeGETRequest(request)
    }
    
    static func getRequestGetMessagesInConversation(id:Int) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/get_messages?conversation_id="+String(id))
        return makeGETRequest(request)
    }
    
    static func getRequestAddUserToConversation(number:String, id:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/add_user")
        let JSONString = "phone_number="+number+"&conversation_id="+id
        return makePOSTRequest(request, JSONString: JSONString)
    }
    
    static func getRequestDeleteUserFromConversation(number:String, id:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/remove_user?phone_number="+number+"&conversation_id="+id)
        return makeDELETERequest(request)
    }
    
    static func getRequestSendMessageToConversation(content:String, sender:String, id:Int) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/conversations/send_message")
        let JSONString = "conversation_id="+String(id)+"&sender="+sender+"&content="+content
        return makePOSTRequest(request, JSONString: JSONString)
    }
    
    static func getRequestGetUserConversations(number:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/users/get_conversations?phone_number="+number)
        return makeGETRequest(request)
    }
    
    static func getRequestGetUser(number:String) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/users/show?phone_number="+number)
        return makeGETRequest(request)
    }
    
    static func getRequestAddUserToDB(name:String, number:String, pass:String) ->NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/users")
        let JSONString = "name="+name+"&phone_number="+number+"&password="+pass
        return makePOSTRequest(request, JSONString: JSONString)
    }
    
    static func getRequestShareLocationWithUsers(port:String, users:[String]) -> NSMutableURLRequest {
        let request = makeRequest("http://guasapuc.herokuapp.com/api/v2/shared_locations")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var obj = ["sender":self.userNumber, "ip":getLocalAddress(), "port":port, "users":users]
        var jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.allZeros, error: nil)
        var jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        return makePOSTRequest(request, JSONString: jsonString)
    }
    
    static func getRequestSharedLocations() -> NSMutableURLRequest {
        let request  = makeRequest("http://guasapuc.herokuapp.com/api/v2/shared_locations?phone_number="+self.userNumber)
        return makeGETRequest(request)
    }
    
    ///Deprecated
    static func getMessagesToNumberURL(number:String) -> String {
        return messagesURL + ".json?phone_number=" + number
    }
    
    ///Deprecated
    static func getMessagesBetweenNumbersURL(number1:String, number2:String) -> String {
        return messagesURL + "/conversation?phone_first=" + number1 + "&phone_second=" + number2
    }
    
    ///Deprecated
    static func generateJSONFormatMessage(sender:String, recipient:String, content:String) -> String {
        return "sender=" + sender + "&recipient=" + recipient + "&content=" + content
    }
    
    ///Deprecated
    static func generateJSONFormatMessage(recipient:String, content:String) -> String {
        return "sender=" + self.getCurrentUser().numero + "&recipient=" + recipient + "&content=" + content
    }
    
    static func limpiarNumero(num:String) -> String {
        var numLimpio = ""
        for letra in num {
            if letra == "(" || letra == ")" || letra == "+" || letra == "-" || letra == " "{ }
            else { numLimpio += String(letra) }}
        
        let components = numLimpio.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
        
        return join("", components)
    }
    
    static func getDateFromString(str:String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat="yyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.dateFromString(str)!
    }
    
    static func isDateGreaterThanDate(date1:NSDate, date2:NSDate) -> Bool {
        return date1.compare(date2).rawValue == 1 ? true : false
    }
    
    static func saveData() {
        var error : NSError?
        if Common.moc == nil { return }
        if(Common.moc!.save(&error) ) {
            if let err = error?.localizedDescription {
                NSLog("Error grabando: ")
                NSLog(error!.localizedDescription as String)
            }
        }
    }

    static func synced(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    static func getIFAddresses() -> [String] {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }}}}}
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
    static func getLocalAddress() -> String {
        let addresses = self.getIFAddresses()
        if addresses.count == 0 { NSLog("ERROR obteniendo id"); return "0"}
        else {
            for a in addresses {
                let b = a.componentsSeparatedByString(".")
                if b[0] == "192" && b[1] == "168" {
                    return a
                }
            }
            if addresses.count == 2 { return addresses[1] }
            return addresses[0]
        }
    }
    
    ///Obtains global ip from http://ipof.in/txt. If server doesn't respond in a "reasonable" time, returns -1
    static func getGlobalAddress() -> String {
//        let data = String(contentsOfURL: NSURL(string: "http://ipof.in/txt")!, encoding: NSUTF8StringEncoding, error: nil)!
//        return data

        var ip = ""
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://ipof.in/txt")!) {(data, response, error) in
            ip = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        }
        var i = 0
        task.resume()
        while ip == "" {
            if i > 50000000 { NSLog("Mas de 50000000 iteraciones"); return "-1"}
            i++
        }
        NSLog("Numero iteraciones: "+String(i))
        return ip
    }
}