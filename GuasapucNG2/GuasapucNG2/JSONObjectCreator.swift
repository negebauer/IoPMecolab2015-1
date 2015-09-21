//
//  JSONObjectCreator.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 20-09-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// Gets data from a json array and returns it in a much easier way to proccess.
/// To obtain information about every json object iterate over arrayJSONObjects.
/// Each JSONObject complies with the minimum data requirements of the supplied type.
class JSONObjectCreator: NSObject {
    
    var arrayJSONObjects = [JSONObject]()
    
    /// data: the json array data to be processed.
    /// type: the type of json objects expected to be created.
    /// error: the error of the task request.
    init(data: NSData?, type: JSONObject.TiposDeJSON, error: NSError?) {
        
        if error != nil {
            NSLog("There was an error getting a json #008")
            return
        }
        
        let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        
        //let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        
        if let jsonArray = jsonSwift as? NSArray {
            for jsonMensaje in jsonArray {
                if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                    let newJSONObject = JSONObject()
                    
                    newJSONObject.id = diccionarioMensaje["id"] as? Int
                    newJSONObject.group = diccionarioMensaje["group"] as? Bool
                    newJSONObject.title = diccionarioMensaje["title"] as? String
                    newJSONObject.admin = diccionarioMensaje["admin"] as? String
                    newJSONObject.url_message = diccionarioMensaje["url"] as? String
                    newJSONObject.name = diccionarioMensaje["name"] as? String
                    newJSONObject.phone_number = diccionarioMensaje["phone_number"] as? String
                    newJSONObject.content = diccionarioMensaje["content"] as? String
                    newJSONObject.sender = diccionarioMensaje["sender"] as? String
                    newJSONObject.conversation_id = diccionarioMensaje["conversation_id"] as? Int
                    newJSONObject.created_at = diccionarioMensaje["created_at"] as? String
                    newJSONObject.token = diccionarioMensaje["api_key"] as? String
                    newJSONObject.first = diccionarioMensaje["first"] as? String
                    newJSONObject.second = diccionarioMensaje["second"] as? String
                    
                    let fileOptional = diccionarioMensaje["file"] as? [String: AnyObject]
                    if let file = fileOptional {
                        newJSONObject.url_file = file["url"] as? String
                        newJSONObject.mime_type = file["mime_type"] as? String
                    }
                    
                    if newJSONObject.compliesWithType(type) {
                        arrayJSONObjects.append(newJSONObject)
                    }
                }
            }
        }
    }
}
