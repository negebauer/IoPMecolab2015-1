//
//  TablaChatsDelegate.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TablaChatsDelegateGroups : NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var chatManager: ChatManager!
    weak var referenciaAlViewControllerGroups : ViewControllerGroups!
    var indexChatRoomAMostrar = 0
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cg = tableView.dequeueReusableCellWithIdentifier("IDCeldaBotonesGrupo") as! UITableViewCell
            return cg
        }
        let c = tableView.dequeueReusableCellWithIdentifier("IDCeldaChatRoom") as! CeldaChat
        c.LabelNombreChat.text = chatManager.chatRoomsGroups[indexPath.row - 1].nombreChat
        c.LabelUltimoMensaje.text = chatManager.chatRoomsGroups[indexPath.row - 1].getLastMessage()
        return c
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatManager.chatRoomsGroups.count + 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false) 
        if indexPath.row == 0 {
            return
        }
        indexChatRoomAMostrar = indexPath.row
        referenciaAlViewControllerGroups?.performSegueWithIdentifier("IDMostrarChatRoom", sender: referenciaAlViewControllerGroups)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            let chatRoomToDelete = chatManager.chatRoomsGroups[indexPath.row]
            Common.moc!.deleteObject(chatRoomToDelete)
            chatManager.fetchChatRooms()
            Common.saveData()
            referenciaAlViewControllerGroups?.TablaChats.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}