//
//  TablaChatsDelegate.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TablaChatsDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var chatManager: ChatManager!
    weak var referenciaAlViewController : ViewController!
    var indexChatRoomAMostrar = 0
    
    func enviarMensajeAContacto(numero:String) {
        indexChatRoomAMostrar = chatManager.getChatRoomIndexForNumber(numero)
        if indexChatRoomAMostrar == -1 { return }
        referenciaAlViewController?.performSegueWithIdentifier("IDMostrarChatRoom", sender: referenciaAlViewController)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCellWithIdentifier("IDCeldaChatRoom") as! CeldaChat
        c.LabelNombreChat.text = chatManager.chatRooms[indexPath.row].nombreChat
        c.LabelUltimoMensaje.text = chatManager.chatRooms[indexPath.row].getLastMessage()
        return c
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatManager.chatRooms.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        indexChatRoomAMostrar = indexPath.row
        referenciaAlViewController?.performSegueWithIdentifier("IDMostrarChatRoom", sender: referenciaAlViewController)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            let chatRoomToDelete = chatManager.chatRooms[indexPath.row]
            Common.moc!.deleteObject(chatRoomToDelete)
            chatManager.fetchChatRooms()
            Common.saveData()
            referenciaAlViewController?.TablaChats.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}