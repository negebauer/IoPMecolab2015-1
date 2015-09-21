//
//  ChatRoomViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// View that manages the display of a chatRoom
class ChatRoomViewController: UIViewController, ChatMessageListDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableDelegate: TablaChatRoomDelegate!
    weak var refChatRoomToShow: ChatRoom!
    weak var refChatViewController: ChatViewController!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearTabla()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToBottom()
    }
    
    func crearTabla() {
        tableDelegate = TablaChatRoomDelegate()
        
        tableDelegate.refChatRoomViewController = self
        tableDelegate.refChatRoomToShow = refChatRoomToShow
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
    }
    
    // MARK: - Table scrolling
    
    func scrollToBottom() {
        let numberOfSections = tableView.numberOfSections - 1
        let numberOfRows = tableView.numberOfRowsInSection(numberOfSections) - 1
        let indexPath = NSIndexPath(forRow: numberOfRows, inSection: numberOfSections)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    // MARK: - ChatMessageListDelegate methods
    
    var table: UITableView {
        return tableView
    }
    
    func reloadChatRoom() {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "IDMostrarImagen" {
            let chatMessage = sender as? ChatMessage
            let imageViewer = segue.destinationViewController as? ImageViewerViewController
            imageViewer?.urlString = (chatMessage?.fileURL)!
        }
    }

}
