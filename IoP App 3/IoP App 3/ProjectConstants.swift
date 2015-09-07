//
//  ProjectConstants.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProjectConstants {
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    static let userC = Contacto() as Contacto
    
    static let usersURL = "http://guasapuc.herokuapp.com/users.json"
    static let messagesURL = "http://guasapuc.herokuapp.com/api/messages"
    static let tokenFormat = "Token token=jQQNqGlnI2gvLKOG4KeMaQtt"
    static let token = "jQQNqGlnI2gvLKOG4KeMaQtt"
    static let user = "Nicolas Gebauer"
    static let userNumber = "56962448489"
    
    static func getMessagesToNumberURL(number:String) -> String {
        return messagesURL + ".json?phone_number=" + number
    }
    
    static func getMessagesBetweenNumbersURL(number1:String, number2:String) -> String {
        return messagesURL + "/conversation?phone_first=" + number1 + "&phone_second=" + number2
    }
    
    static func generateJSONFormatMessage(sender:String, recipient:String, content:String) -> String {
        return "sender=" + sender + "&recipient=" + recipient + "&content=" + content
    }
    
    static func generateJSONFormatMessage(recipient:String, content:String) -> String {
        return "sender=" + userNumber + "&recipient=" + recipient + "&content=" + content
    }
}