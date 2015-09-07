//
//  TabBarController.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 26-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        
        //----- Codigo sacado de http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
        //Para hacer un POST request asincrono
        //Modificado para ser compatible con el formato de guasapuc
        let request = NSMutableURLRequest(URL: NSURL(string: ProjectConstants.messagesURL)!)
        request.HTTPMethod = "POST"
        request.addValue(ProjectConstants.tokenFormat, forHTTPHeaderField: "Authorization")
        let postString = ProjectConstants.generateJSONFormatMessage("56968799501", content: "Mensaje nuevo")
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
        //----- Fin
        
//        self.selectedIndex = 1
        self.selectedIndex = 0
        self.selectedIndex = 1
        
//        var chatView = self.viewControllers![1] as! ChatsViewController
//        var chatContacts = self.viewControllers![0] as! ContactsViewController
//        
//        chatView.referenciaContactListManager = chatContacts.delegateTablaContactos!.contactListManager
        
        NSLog("Ventana chat seleccionada")
    }
}
