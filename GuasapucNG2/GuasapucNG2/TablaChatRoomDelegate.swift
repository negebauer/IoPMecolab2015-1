//
//  TablaChatRoomDelegate.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 21-09-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// Delegate that manages the representation of a chatRoom.
class TablaChatRoomDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var refChatRoomToShow: ChatRoom!
    weak var refChatRoomViewController: ChatRoomViewController!
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if refChatRoomToShow.arrayMessage[indexPath.row].isFile {
            refChatRoomViewController.performSegueWithIdentifier("IDMostrarImagen", sender: refChatRoomToShow.arrayMessage[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refChatRoomToShow.arrayMessage.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellMessage = tableView.dequeueReusableCellWithIdentifier("IDCeldaMensaje", forIndexPath: indexPath) as? ChatMessageTableViewCell
        
        cellMessage?.LabelMensaje.text = refChatRoomToShow.arrayMessage[indexPath.row].content
        cellMessage?.isSentBySelf = refChatRoomToShow.arrayMessage[indexPath.row].sender == User.currentUser!.number
        
        dispatch_async(dispatch_get_main_queue(), {
            cellMessage?.loadChatBubble()
        })
        
        return cellMessage != nil ? cellMessage! : UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cellMessage = cell as? ChatMessageTableViewCell {
            cellMessage.destroyBubble()
        }
    }
}