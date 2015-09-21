//
//  ChatViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 30-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// View that manages the display of all chatRooms.
class ChatViewController: UIViewController, ChatRoomListDelegate {

    @IBOutlet weak var tableView: UITableView!
    var chatManager: ChatManager!
    var tableDelegate: TablaChatsDelegate!
    
    // MARK: - Button actions
    
    /// Refresh the local chatRooms.
    @IBAction func refreshChats(sender: AnyObject) {
        chatManager.updateChats()
    }
    
    /// Create a new contact.
    @IBAction func addNewContact(sender: AnyObject) {
        
    }
    
    /// Start a new chat.
    @IBAction func addNewChat(sender: AnyObject) {
        
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatManager = ChatManager(chatRoomListDelegate: self)
        crearTabla()
    }
    
    func crearTabla() {
        tableDelegate = TablaChatsDelegate()
        
        tableDelegate.refChatViewController = self
        tableDelegate.refChatManager = chatManager
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
    }
    
    // MARK: - ChatManagerDelegate methods
    
    var table: UITableView {
        return tableView
    }
    
    func reloadChatRooms() {
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
