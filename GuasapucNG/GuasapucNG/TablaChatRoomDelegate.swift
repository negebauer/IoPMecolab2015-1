//
//  TablaChatRoomDelegate.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 04-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TablaChatRoomDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    weak var referenciaAlChatRoomViewController: ChatRoomView!
    var chatRoom: ChatRoom!
    var urlToShow = ""
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCellWithIdentifier("IDCeldaMensaje") as! CeldaMensaje
        let message = chatRoom.getMessagesInChat()[indexPath.row]
        if message.sender == Common.getCurrentUser().numero {
            c.bubbleString = "ChatBubble2"
        }
        else {
            c.bubbleString = "ChatBubble"
        }
        c.LabelMensaje.text = message.content
        c.loadChatBubble()
        c.messageDidAppear()
        return c
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messages = chatRoom.getMessagesInChat()
        if messages == [ChatRoom]() { return 0 }
        return chatRoom.getMessagesInChat().count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let msg = chatRoom.getMessagesInChat()[indexPath.row]
        if msg.hasURL {
            let targetURL = NSURL(string: msg.url)
            if targetURL == nil { return }
            
            if referenciaAlChatRoomViewController == nil { return }
            
            urlToShow = msg.url
            
            referenciaAlChatRoomViewController.performSegueWithIdentifier("IDShowImage", sender: self)
            
            /* Deprecated
            let application=UIApplication.sharedApplication()
            
            application.openURL(targetURL!);
            */
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! CeldaMensaje).messageDidDissapear()
    }
}