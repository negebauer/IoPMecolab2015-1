//
//  ChatManager.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AddressBook

class ChatManager {
    let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var diccionarioNumeroPersonABRecord = Dictionary<String,ABRecord>()
    var chatRooms = [ChatRoom]()
    var chatRoomsGroups = [ChatRoom]()
    weak var referenciaAlDelegate: TablaChatsDelegate!
    weak var referenciaAlDelegateGroups: TablaChatsDelegateGroups!
    
    init() {
        createArrayNumberName()
        fetchChatRooms()
    }
    
    ///Reloads data in both chat views (1on1 and groups)
    func reloadData() {
        if let ref = referenciaAlDelegateGroups {
            ref.referenciaAlViewControllerGroups.TablaChats.reloadData()
        }
        if let ref = referenciaAlDelegate {
            ref.referenciaAlViewController.TablaChats.reloadData()
        }
        
        Common.saveData()
    }
    
    func reloadData(isGroup:Bool) {
        isGroup ? referenciaAlDelegateGroups.referenciaAlViewControllerGroups.TablaChats.reloadData() : referenciaAlDelegate.referenciaAlViewController?.TablaChats.reloadData()
    }
    
    func fetchChatRooms() {
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let soloGrupos = NSPredicate(format: "isGroup == \(String(stringInterpolationSegment: true))")
        let solo1on1 = NSPredicate(format: "isGroup == \(String(stringInterpolationSegment: false))")
        let fetchRequest1on1 = NSFetchRequest(entityName: "ChatRoom")
        let fetchRequestGroup = NSFetchRequest(entityName: "ChatRoom")
        fetchRequest1on1.sortDescriptors = [sortDescriptor]
        fetchRequestGroup.sortDescriptors = [sortDescriptor]
        fetchRequest1on1.predicate = solo1on1
        fetchRequestGroup.predicate = soloGrupos
        
        if let fetchResults1on1 = Common.moc!.executeFetchRequest(fetchRequest1on1, error: nil) as? [ChatRoom] {
            chatRooms = fetchResults1on1
        }
        if let fetchResultsGroups = Common.moc!.executeFetchRequest(fetchRequestGroup, error: nil) as? [ChatRoom] {
            chatRoomsGroups = fetchResultsGroups
        }
        
        Common.saveData()
}
    
    func updateChats() {
        checkWebForNewChatRooms()
        getMessagesFromWebForAllChats()
        deleteEmptyMessagesFromAllChats()
        fetchChatRooms()
        ordenarListaChats()
        reloadData()
    }
    
    func updateChat(chatRoom:ChatRoom) {
        getMessagesFromWebForChat(chatRoom)
        deleteEmptyMessagesFromChatRoom(chatRoom)
        fetchChatRooms()
        ordenarListaChats()
        reloadData(chatRoom.isGroup)
    }
    
    func checkWebForNewChatRooms() {
        let request = Common.getRequestGetUserConversations(Common.userNumber)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    //json con todas las conversaciones donde estoy
                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                        let id = diccionarioMensaje["id"] as! Int
                        let isGroup = diccionarioMensaje["group"] as! Bool
                        let title = diccionarioMensaje["title"] as! String
                        let admin = diccionarioMensaje["admin"] as! String
                        
                        if isGroup {
                            self.checkChatRoomGroup(id, title: title, admin: admin)
                        }
                        else {
                            self.checkChatRoom(id, title: title, admin: admin)
                        }}}}
        }
        task.resume()
        
        func deprecated() {
            //        let request = NSMutableURLRequest(URL: NSURL(string: Common.getMessagesToNumberURL(Common.getCurrentUser().numero))!)
            //        request.HTTPMethod = "GET"
            //        request.addValue(Common.tokenFormatted, forHTTPHeaderField: "Authorization")
            //        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            //            data, response, error in
            //
            //            if error != nil {
            //                println("error=\(error)")
            //                return
            //            }
            //
            //            let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            //
            //            if let jsonArray = jsonSwift as? NSArray {
            //                for jsonMensaje in jsonArray {
            //                    //Tengo el json con todos los mensajes enviados a mi
            //                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String,NSObject> {
            //                        let sender = diccionarioMensaje["sender"] as! String
            //                        let recipient = diccionarioMensaje["recipient"] as! String
            //                        let numero = sender == Common.getCurrentUser().numero ? recipient : sender
            //                        self.getChatRoomWithConditions(false, numeros: [numero])
            //                    }}}}
            //        task.resume()
        }
    }
    
    func getMessagesFromWebForAllChats() {
        createArrayNumberName()
        fetchChatRooms()
        for c in chatRooms {
            getMessagesFromWebForChat(c)
        }
        for c in chatRoomsGroups {
            getMessagesFromWebForChat(c)
        }
    }
    
    func getMessagesFromWebForChat(chatRoom:ChatRoom) {
        let request = Common.getRequestGetMessagesInConversation(chatRoom.id)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String,NSObject> {
                        self.fetchChatRooms()
                        //No vamos a revisar los mensajes que yo envie
                        let sender = diccionarioMensaje["sender"] as! String
                        if sender == Common.userNumber { continue }
                        let id = diccionarioMensaje["id"] as! Int
                        if contains(chatRoom.getMessagesInChat(), {m in m.id == id}) { continue }
                        var content = ""
                        if !(diccionarioMensaje["content"] is NSNull) {
                            content = diccionarioMensaje["content"] as! String
                        }
                        let createdAtString = diccionarioMensaje["created_at"] as! String
                        let newMessage = ChatMessage.new(Common.moc!, _sender: sender, _content: content, _createdAtString: createdAtString, _id: id)
                        
                        Common.synced(chatRoom, closure: { chatRoom.addMessageToChat(newMessage) })
                        if chatRoom.isGroup {
                            if self.referenciaAlDelegateGroups != nil {
                                if self.referenciaAlDelegateGroups.referenciaAlViewControllerGroups != nil {
                                    self.referenciaAlDelegateGroups.referenciaAlViewControllerGroups.TablaChats.reloadData()
                                }
                            }
                        }
                        else { self.referenciaAlDelegate.referenciaAlViewController.TablaChats.reloadData()
                        }
                    }}}
        }
        reloadData()
        task.resume()
        
        func deprecated() {
//        let request = NSMutableURLRequest(URL: NSURL(string: Common.getMessagesBetweenNumbersURL(Common.getCurrentUser().numero, number2: chatRoom.getChatNumbers().first!))!)
//        request.HTTPMethod = "GET"
//        request.addValue(Common.tokenFormatted, forHTTPHeaderField: "Authorization")
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                println("error=\(error)")
//                return
//            }
//            
//            let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
//            
//            if let jsonArray = jsonSwift as? NSArray {
//                for jsonMensaje in jsonArray {
//                    //Tengo el json con todos los mensajes enviados entre dos numeros
//                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String,NSObject> {
//                        let sender = diccionarioMensaje["sender"] as! String
//                        let recipient = diccionarioMensaje["recipient"] as! String
//                        let id = diccionarioMensaje["id"] as! Int
//                        var content = ""
//                        if diccionarioMensaje["content"] is NSNull { }
//                        else {
//                            content = diccionarioMensaje["content"] as! String
//                        }
//                        let createdAtString = diccionarioMensaje["created_at"] as! String
//                        let createdAtDate = Common.getDateFromString(createdAtString)
//                        let numeroOtroIntegranteChat = sender == Common.getCurrentUser().numero ? recipient : sender
//                        var userIsSender = false
//                        if sender == Common.getCurrentUser().numero {
//                            userIsSender = true
//                        }
//                        let messagesThatMatch = chatRoom.getMessagesInChat().filter({m in return m.id == id})
//                        if messagesThatMatch.count > 0 {
//                            continue
//                        }
//                        let messagesThatMayMatch = chatRoom.getMessagesInChat().filter({m in return self.messageMayMatch(m, userIsSender: userIsSender, c: content)})
//                        if messagesThatMayMatch.count > 0 {
//                            if messagesThatMayMatch.count == 1 {
//                                let localMessage = messagesThatMayMatch[0]
//                                localMessage.id = id
//                                localMessage.createdAt = createdAtDate
//                                localMessage.chatRoom.updatedAt = createdAtDate
//                                self.referenciaAlDelegate.referenciaAlViewController?.TablaChats.reloadData()
//                                continue
//                            }
//                            else {
//                                NSLog("Tengo mas de un match!")
//                                continue
//                            }
//                        }
//                        let newMessage = ChatMessage.new(Common.moc!, _sender: userIsSender ? Common.getCurrentUser().numero : numeroOtroIntegranteChat, _recipient: userIsSender ? numeroOtroIntegranteChat : Common.getCurrentUser().numero, _content: content, _createdAtString: createdAtString, _id: id)
//                        Common.synced(chatRoom, closure: { chatRoom.addMessageToChat(newMessage) })
//                        Common.saveData()
//                        self.referenciaAlDelegate.referenciaAlViewController?.TablaChats.reloadData()
//                    }}}}
//        task.resume()
        }
    }
    
    func messageMayMatch(m:ChatMessage, userIsSender:Bool, c:String) -> Bool {
        let idMatch = m.id == -1
        let contentMatch = m.content == c
        let dateMatch = m.createdAt == NSDate(timeIntervalSince1970: NSTimeInterval.abs(0))
        let a = idMatch && contentMatch
        let b = dateMatch && userIsSender
        return a && b
    }
    
    func deleteEmptyMessagesFromAllChats() {
        for chat in chatRooms {
            deleteEmptyMessagesFromChatRoom(chat)
        }
        for chat in chatRoomsGroups {
            deleteEmptyMessagesFromChatRoom(chat)
        }
    }
    
    func deleteEmptyMessagesFromChatRoom(chatRoom:ChatRoom) {
        for message in  chatRoom.getMessagesInChat().filter({m in return m.content == "" || isEmpty(m.content) || m.content == " "}) {
            Common.moc?.deleteObject(message)
        }
        referenciaAlDelegate.referenciaAlViewController?.TablaChats.reloadData()
    }
    
    ///Returns the index of the chatRoom (in chatRooms) between the user and the provided number.
    ///Creates a new chatRoom if it doesn't exist. Only for 1on1 chats
    func getChatRoomIndexForNumber(number:String) -> Int {
        checkWebForNewChatRooms()
        let chatRoomsThatMatch = chatRooms.filter({c in return (c.getChatNumbers().contains(number))})
        if chatRoomsThatMatch.count == 1 {
            return find(chatRooms, chatRoomsThatMatch[0])!
        }
        else if chatRoomsThatMatch.count == 0 {
            let nombre = getNameForContactNumber(number)
            
            let newChatRoom = ChatRoom.new(Common.moc!, _isGroup: false, _nombreChat: nombre, _numbers: [number], _members: [getContactForNumber(number)], _messages: [ChatMessage](), _admin: "", _id: -1)
            
            let request = Common.getRequestCreate2UserConversation(Common.userNumber, second: number, title: nombre)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
            
                let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
                if let diccionarioMensaje = jsonSwift as? Dictionary<String, NSObject> {
                    newChatRoom.id = diccionarioMensaje["id"] as! Int
                    newChatRoom.isGroup = diccionarioMensaje["group"] as! Bool
                    newChatRoom.nombreChat = diccionarioMensaje["title"] as! String
                    newChatRoom.admin = diccionarioMensaje["admin"] as! String
                    newChatRoom.updatedAt = NSDate()
                    Common.saveData()
                }
            }
            Common.synced(chatRooms, closure: {self.chatRooms.append(newChatRoom)})
            task.resume()
            fetchChatRooms()
            return find(chatRooms, newChatRoom)!
        }
        else {
            NSLog("ERROR---\nProblema, mas de una conversacion donde deberia haber una!")
            return -1
        }
    }
    
    ///Creates a new chatRoom (Group) with the given numbers. Adds it to chatRoomsGroups. Returns the index in chatRoomsGroups
    func createNewChatRoomGroup(numbers:[String], title:String) -> Int {
        var contacts = [Contacto]()
        for n in numbers {
            contacts.append(getContactForNumber(n))
        }
        let newChatRoomGroup = ChatRoom.new(Common.moc!, _isGroup: true, _nombreChat: title, _numbers: numbers, _members: contacts, _messages: [ChatMessage](), _admin: Common.userNumber, _id: -1)
        let request = Common.getRequestCreateGroupConversation(Common.userNumber, users: numbers, title: title)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, responde, error in
            
            let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let diccionarioGrupo = jsonSwift as? Dictionary<String, NSObject> {
                newChatRoomGroup.id = diccionarioGrupo["id"] as! Int
            }
            self.reloadData()
        }
        Common.synced(chatRoomsGroups, closure: {self.chatRoomsGroups.append(newChatRoomGroup)})
        task.resume()
        fetchChatRooms()
        return find(chatRoomsGroups, newChatRoomGroup)!
    }

    ///Creates a new chatRoom (Group) if it doesn't exist. Also adds it to chatRoomsGroups
    func checkChatRoomGroup(id:Int, title:String, admin:String) {
        let fethcRequestChatRoomGroup = NSFetchRequest(entityName: "ChatRoom")
        let revisarIdChat = NSPredicate(format: "id == %X", id)
        fethcRequestChatRoomGroup.predicate = revisarIdChat
        if let fetchResultsChatRoomGroup = Common.moc?.executeFetchRequest(fethcRequestChatRoomGroup, error: nil) as? [ChatRoom] {
            if fetchResultsChatRoomGroup.count == 0 {
                //Creo nuevo chat
                let newChatRoom = ChatRoom.new(Common.moc!, _isGroup: true, _nombreChat: title, _numbers: [String](), _members: [Contacto](), _messages: [ChatMessage](), _admin: admin, _id: id)
                
                //Descargo los miembros del chat y los agrego al chat
                let requestMiembrosGrupo = Common.getRequestGetUsersInConversation(String(id))
                let taskMiembrosGrupo = NSURLSession.sharedSession().dataTaskWithRequest(requestMiembrosGrupo) {
                    data, response, error in
                    
                    let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    
                    if let jsonArray = jsonSwift as? NSArray {
                        for jsonMensaje in jsonArray {
                            if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                                let number = diccionarioMensaje["phone_number"] as! String
                                let c = self.getContactForNumber(number)
                                newChatRoom.addMemberToChat(c)
                            }}}}
                
                //Descargo los mensajes del chat y los agrego al chat
                let requestMensajesGrupo = Common.getRequestGetMessagesInConversation(id)
                let taskMensajesGrupo = NSURLSession.sharedSession().dataTaskWithRequest(requestMensajesGrupo) {
                    data, response, error in
                    
                    let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    
                    if let jsonArray = jsonSwift as? NSArray {
                        for jsonMensaje in jsonArray {
                            if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                                let id = diccionarioMensaje["id"] as? Int
                                let sender = diccionarioMensaje["sender"] as? String
                                let content = diccionarioMensaje["content"] as? String
                                let createdAtString = diccionarioMensaje["created_at"] as? String
                                if id == nil || sender == nil || content == nil || createdAtString == nil {
                                    return
                                }
                                let date = Common.getDateFromString(createdAtString!)
                                let m = self.getMessageForData(id!, sender: sender!, content: content!)
                                m.createdAt = date
                            }}}}
                
                Common.synced(chatRoomsGroups, closure: {self.chatRoomsGroups.append(newChatRoom)})
                ordenarListaChats()
                fetchChatRooms()
                reloadData()
                taskMensajesGrupo.resume()
                taskMiembrosGrupo.resume()
            }
            else if fetchResultsChatRoomGroup.count > 1 {
                NSLog("ERROR---\nTenemos un problema, el chat room con id: \(String(id)) esta repetido")
            }
        }
    }
    
    ///Creates a new chatRoom (1on1) if it doesn't exist. Also adds it to chatRooms
    func checkChatRoom(id:Int, title:String, admin:String) {
        let fethcRequestChatRoom1on1 = NSFetchRequest(entityName: "ChatRoom")
        let revisarIdChat = NSPredicate(format: "id == %X", id)
        fethcRequestChatRoom1on1.predicate = revisarIdChat
        if let fetchResultsChatRoom1on1 = Common.moc?.executeFetchRequest(fethcRequestChatRoom1on1, error: nil) as? [ChatRoom] {
            if fetchResultsChatRoom1on1.count == 0 {
                //Creo nuevo chat
                let newChatRoom = ChatRoom.new(Common.moc!, _isGroup: false, _nombreChat: title, _admin: admin, _id: id)
                
                //Descargo los miembros del chat y los agrego al chat
                let requestMiembrosGrupo = Common.getRequestGetUsersInConversation(String(id))
                let taskMiembrosGrupo = NSURLSession.sharedSession().dataTaskWithRequest(requestMiembrosGrupo) {
                    data, response, error in
                    
                    let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    
                    if let jsonArray = jsonSwift as? NSArray {
                        for jsonMensaje in jsonArray {
                            if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                                let number = diccionarioMensaje["phone_number"] as! String
                                let c = self.getContactForNumber(number)
                                newChatRoom.addMemberToChat(c)
                            }}}}
                
                //Descargo los mensajes del chat y los agrego al chat
                let requestMensajesGrupo = Common.getRequestGetMessagesInConversation(id)
                let taskMensajesGrupo = NSURLSession.sharedSession().dataTaskWithRequest(requestMensajesGrupo) {
                    data, response, error in
                    
                    let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    
                    if let jsonArray = jsonSwift as? NSArray {
                        for jsonMensaje in jsonArray {
                            if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                                let id = diccionarioMensaje["id"] as? Int
                                let sender = diccionarioMensaje["sender"] as? String
                                let content = diccionarioMensaje["content"] as? String
                                let createdAtString = diccionarioMensaje["created_at"] as? String
                                if id == nil || sender == nil || content == nil || createdAtString == nil {
                                    return
                                }
                                let date = Common.getDateFromString(createdAtString!)
                                let m = self.getMessageForData(id!, sender: sender!, content: content!)
                                m.createdAt = date
                            }}}}
                
                Common.synced(chatRooms, closure: {self.chatRoomsGroups.append(newChatRoom)})
                ordenarListaChats()
                fetchChatRooms()
                reloadData()
                taskMensajesGrupo.resume()
                taskMiembrosGrupo.resume()
            }
            else if fetchResultsChatRoom1on1.count > 1 {
                NSLog("ERROR---\nTenemos un problema, el chat room con id: \(String(id)) esta repetido")
            }
        }
    }
    
    ///Checks if message is in DB. Creates it if it's not. Returns the message
    func getMessageForData(id:Int, sender:String, content:String) -> ChatMessage {
        let fetch = NSFetchRequest(entityName: "ChatMessage")
        let revisarIdMensaje = NSPredicate(format: "id == %X", id)
        fetch.predicate = revisarIdMensaje
        if let fetchResults = Common.moc?.executeFetchRequest(fetch, error: nil) as? [ChatMessage] {
            if fetchResults.count == 0 {
                let newMessage = ChatMessage.new(Common.moc!, _sender: sender, _content: content, _id: id)
                return newMessage
            }
            else if fetchResults.count == 1 {
                return fetchResults[0]
            }
            else if fetchResults.count > 1 {
                NSLog("ERROR---\nTenemos mas de un chat para el id: \(String(id))")
                return ChatMessage()
            }
        }
        NSLog("No funciono un fetchRequest para busqueda de mensaje con id: \(String(id))")
        return ChatMessage()
    }
    
    ///Returns the Contact that matches the specified number. Creates a new one if it doesn't exist
    func getContactForNumber(number:String) -> Contacto {
        let fetchRequestContacto = NSFetchRequest(entityName: "Contacto")
        let revisarNumero = NSPredicate(format: "numero == %@", number)
        fetchRequestContacto.predicate = revisarNumero
        if let fetchResultsContacto = Common.moc?.executeFetchRequest(fetchRequestContacto, error: nil) as? [Contacto] {
            if fetchResultsContacto.count == 0 {
                let nombre = getNameForContactNumber(number)
                let newContact = Contacto.new(Common.moc!, _nombre: nombre, _numero: number)
                return newContact
            }
            else if fetchResultsContacto.count == 1{
                return fetchResultsContacto[0]
            }
            else {
                NSLog("ERROR---\nTenemos dos contactos para el mismo numero")
            }
        }
        return [Contacto]()[0]
    }
    
    func getNameForContactNumber(number:String) -> String {
        createArrayNumberName()
        let person: ABRecord? = diccionarioNumeroPersonABRecord[number]
        var nombre = ""
        let nombreRaw = ABRecordCopyCompositeName(person)
        if nombreRaw != nil {
            nombre = ABRecordCopyCompositeName(person).takeRetainedValue() as! String
        }
        nombre = nombre != "" ? nombre : number
        return nombre
    }
    
    ///Ordena los chats fijandose en el atributo updatedAt (los que no lo tienen quedan al final)
    func ordenarListaChats() {
        chatRooms.sort({c1, c2 in Common.isDateGreaterThanDate(c1.updatedAt, date2: c2.updatedAt)})
        chatRoomsGroups.sort({c1, c2 in Common.isDateGreaterThanDate(c1.updatedAt, date2: c2.updatedAt)})
    }
    
    func createArrayNumberName() {
        diccionarioNumeroPersonABRecord.removeAll(keepCapacity: false)
        let allPeople = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray
        for personRecord in allPeople {
            let phones : ABMultiValueRef = ABRecordCopyValue(personRecord, kABPersonPhoneProperty).takeRetainedValue()
            if ABMultiValueCopyArrayOfAllValues(phones) != nil {
                for numeroRaw in ABMultiValueCopyArrayOfAllValues(phones).takeRetainedValue() as NSArray {
                    let numero = Common.limpiarNumero(numeroRaw as! String)
                    if diccionarioNumeroPersonABRecord.indexForKey(numero) != nil {
                        NSLog("Hay un numero duplicado (en dos contactos)\nNumero: " + numero)
                    }
                    else {
                        diccionarioNumeroPersonABRecord[numero] = personRecord as ABRecord
                    }}}}
    }
    
    
}