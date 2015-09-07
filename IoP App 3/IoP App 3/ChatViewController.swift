//
//  ChatViewController.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

///Ventana del chat donde se pueden leer, escribir y enviar mensajes
class ChatViewController : UIViewController {
    
    func enviarMensaje() {
        //----- Codigo sacado de http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
        //Para hacer un POST request asincrono
        //Modificado para ser compatible con el formato de guasapuc
        let request = NSMutableURLRequest(URL: NSURL(string: ProjectConstants.messagesURL)!)
        request.HTTPMethod = "POST"
        request.addValue(ProjectConstants.tokenFormat, forHTTPHeaderField: "Authorization")
        let postString = ProjectConstants.generateJSONFormatMessage(ProjectConstants.userNumber, content: "Mensaje prueba swift 1")
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
    }
}