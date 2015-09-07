//
//  ChatListManager.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData
import UIKit

///Manager de chats
class ChatListManager {
    weak var referenciaAlViewController : ChatsViewController?
    let moc = ProjectConstants.managedObjectContext
    var chats = [ChatRoom]()
    var referenciaContactList : ContactListManager?
    
    init() {
        fetchChats()
    }
    
    ///Carga la lista de chats de la base de datos local
    func fetchChats() {
        let fetchRequest = NSFetchRequest(entityName: "ChatRoom")
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = moc!.executeFetchRequest(fetchRequest, error: nil) as? [ChatRoom] {
            chats = fetchResults
        }
        
        referenciaAlViewController?.TablaChats.reloadData()
    }
    
    func updateChats() {
        fetchChats()
        obtenerChatsServidor()
    }
    
    func obtenerChatsServidor() {
        var diccionarioIDChat = Dictionary<String,ChatRoom>()
        
        //-----     ARREGLAR    -----
        //Primero ver si mensajes nuevos para chats ya creados
//        for chat in chats {
//            
//            NSLog("chat :  user1: "+chat.user1.nombre+"  user2: "+chat.user2.nombre)
//            
//            let request = NSMutableURLRequest(URL: NSURL(string: ProjectConstants.getMessagesBetweenNumbersURL(chat.user1.numero, number2: chat.user2.numero))!)
//            request.HTTPMethod = "GET"
//            request.addValue(ProjectConstants.tokenFormat, forHTTPHeaderField: "Authorization")
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//                data, response, error in
//                
//                if error != nil {
//                    println("error=\(error)")
//                    return
//                }
//                
//                let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
//                
//                if let jsonArray = jsonSwift as? NSArray {
//                    for jsonMensaje in jsonArray {
//                        //Tengo el json con los mensajes entre un usuario y otro
//                        if let diccionarioMensaje = jsonMensaje as? Dictionary<String,NSObject> {
//                            let id = diccionarioMensaje["id"] as! String
//                            let content = diccionarioMensaje["content"] as! String
//                            let sender = diccionarioMensaje["sender"] as! String
//                            let recipient = diccionarioMensaje["recipient"] as! String
//                            let createdAt = diccionarioMensaje["createdAt"] as! String
//                            let url = diccionarioMensaje["url"] as! String
//                            
//                        }}}}
//            task.resume()}
        //-----     ARREGLAR    -----
        
        //Revisar si hay nuevos chats
        //Para ello revisemos todos los contactos que no esten en un chat
        if referenciaContactList?.contactos.count > 0 {
            for contacto in referenciaContactList!.contactos {
                if !contains(chats, {chat in return contains(chat.users, contacto)}) {
                    //Tenemos un numero que no esta en un chat
                    
                    NSLog("Viendo mensajes de: " +  contacto.numero)
                    
                    let request = NSMutableURLRequest(URL: NSURL(string: ProjectConstants.getMessagesBetweenNumbersURL(referenciaContactList!.currentUser.numero, number2: contacto.numero))!)
                    request.HTTPMethod = "GET"
                    request.addValue(ProjectConstants.tokenFormat, forHTTPHeaderField: "Authorization")
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                        data, response, error in
                        
                        if error != nil {
                            println("error=\(error)")
                            return
                        }
                        
                        let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                        
                        if let jsonArray = jsonSwift as? NSArray {
                            for jsonMensaje in jsonArray {
                                //Tengo el json con los mensajes entre un usuario y otro
                                if let diccionarioMensaje = jsonMensaje as? Dictionary<String,NSObject> {
                                    let id = diccionarioMensaje["id"] as! Int
                                    let contentSinVerificar = diccionarioMensaje["content"]
                                    var content = ""
                                    if let c = contentSinVerificar as? String {
                                        content = c
                                    }
                                    let sender = diccionarioMensaje["sender"] as! String
                                    let recipient = diccionarioMensaje["recipient"] as! String
                                    let created_at = diccionarioMensaje["created_at"] as! String
                                    let url = diccionarioMensaje["url"] as! String
                                    
                                    NSLog("sender: "+sender)
                                    NSLog("recipient: "+recipient)
                                    NSLog("content: "+content)
                                    
                                    self.checkForChatRoomForMessage(id, message: content, sender: sender, recipient: recipient, createdAt: created_at, url: url)
                                }
                            }}}
                    task.resume()
                }
            }
        }
        
        //Ahora descarguemos aquellos que nos mandaron mensajes pero que no los tenemos
        //bla
        //bla
        //bla
        
        
        referenciaAlViewController?.refreshControl.endRefreshing()
    }
    
    func checkForChatRoomForMessage(id:Int, message:String, sender:String, recipient:String, createdAt:String, url:String) {
        var user2 : Contacto?
        var userIsRecipient = false
        if sender == referenciaContactList?.currentUser.numero {
            NSLog("El otro es sender")
//            user2 = referenciaContactList!.contactos.filter({$0.numero == recipient})[0]
            if (referenciaContactList?.diccionarioNumeroContacto.indexForKey(recipient) != nil) {
                user2 = referenciaContactList!.diccionarioNumeroContacto[recipient]!
            }
            userIsRecipient = true
        }
        else if recipient == referenciaContactList?.currentUser.numero {
            NSLog("sender es: " + sender)
            NSLog("El otro es recipient")
//            user2 = referenciaContactList!.contactos.filter({$0.numero == sender})[0]
            for key in referenciaContactList!.diccionarioNumeroContacto.keys {
                NSLog("Key: "+key+" Contacto NombreNumero: "+referenciaContactList!.diccionarioNumeroContacto[key]!.nombre + " "+referenciaContactList!.diccionarioNumeroContacto[key]!.numero)
            }
            NSLog("sender que da problema: " + sender)
            if (referenciaContactList?.diccionarioNumeroContacto.indexForKey(sender) != nil) {
                user2 = referenciaContactList!.diccionarioNumeroContacto[sender]!
            }
            userIsRecipient = false
        }
        
        if contains(chats, {c in return contains(c.users, user2!)}) {
            //Ya tiene chat room
            NSLog("Encontre mensaje que ya tiene un chatroom")
            let chatRoom = chats.filter({contains($0.users, user2!) && ($0.isGroup == false)})[0]
            let nuevoMensaje = ChatMessage.createInManagedObjectContext(moc!, _id: id, _createdAt: createdAt, _message: message, _recipient: (userIsRecipient ? referenciaContactList?.currentUser : user2)!, _sender: (userIsRecipient ? user2 : referenciaContactList?.currentUser)!, _url: url)
            chatRoom.mensajes.append(nuevoMensaje)
            chatRoom.updatedAt = createdAt
        }
        else {
            //No tiene chat; room
            let nuevoMensaje = ChatMessage.createInManagedObjectContext(moc!, _id: id, _createdAt: createdAt, _message: message, _recipient: (userIsRecipient ? referenciaContactList?.currentUser : user2)!, _sender: (userIsRecipient ? user2 : referenciaContactList?.currentUser)!, _url: url)
            var users = [Contacto]()
            users.append(referenciaContactList!.currentUser)
            users.append(user2!)
            var nuevosMensajes = [ChatMessage]()
            nuevosMensajes.append(nuevoMensaje)
            let newChatRoom = ChatRoom.createInManagedObjectContext(moc!, _isGroup: false, _mensajes: nuevosMensajes, _updatedAt: createdAt, _users: users)
        }
        referenciaAlViewController?.TablaChats.reloadData()
        //saveData()
    }
    
    func saveData() {
        var error : NSError?
        if(moc!.save(&error) ) {
            if let err = error?.localizedDescription {
                NSLog("Error grabando: ")
                NSLog(error!.localizedDescription as String)
            }
        }
    }
}