//
//  TablaChatsDelegate.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 05-09-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

/// Delegate that manages the representation of the chatRooms.
class TablaChatsDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var refChatManager: ChatManager!
    weak var refChatViewController: ChatViewController!
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        refChatViewController.performSegueWithIdentifier("IDMostrarChatRoom", sender: refChatManager.chatsList[indexPath.row - 1])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refChatManager.chatsList.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("IDCeldaCrearGrupo", forIndexPath: indexPath) as? CreateGroupTableViewCell
            
            cell?.refChatViewController = refChatViewController
            
            return cell != nil ? cell! : UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IDCeldaChat", forIndexPath: indexPath) as? ChatRoomTableViewCell
        
        cell?.LabelNombreChat.text = refChatManager.chatsList[indexPath.row - 1].nameChat
        cell?.LabelUltimoMensaje.text = refChatManager.chatsList[indexPath.row - 1].ultimoMensaje
        
        return cell != nil ? cell! : UITableViewCell()
    }
}