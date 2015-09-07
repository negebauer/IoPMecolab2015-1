//
//  TablaContactosDelegate.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 26-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TablaChatsDelegate : NSObject, UITableViewDelegate, UITableViewDataSource {
    weak var referenciaAlViewController : ChatsViewController?
    var chatListManager = ChatListManager()
    
    func updateChats() {
        chatListManager.updateChats()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCellWithIdentifier("IDCeldaChat") as! CeldaChat
        NSLog("indexPath.row: " + String(indexPath.row))
        NSLog("count chats: "+String(chatListManager.chats.count))
        
        let chat = chatListManager.chats[indexPath.row]
        celda.LabelNombreChat.text = chat.users[1].nombre
        //println(chat.mensajes)
        print(chat.mensajes.count)
        celda.LabelUltimoMensaje.text = chat.mensajes[chat.mensajes.count - 1].message
        
//        celda.LabelNombreChat.text = chatListManager.chats[indexPath.row].user1.nombre
//        celda.LabelUltimoMensaje.text = (chatListManager.chats[indexPath.row].mensajes[-1] as! ChatMessage).message
        
        return celda
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListManager.chats.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}