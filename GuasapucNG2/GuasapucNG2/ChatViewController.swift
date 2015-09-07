//
//  ChatViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 30-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, ChatManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var chatManager: ChatManager!
    var tableDelegate: TablaChatsDelegate!
    
    var table: UITableView {
        get { return tableView }
    }
    
    @IBAction func RefreshChats(sender: AnyObject) {
        chatManager.updateChats()
    }
    
    @IBAction func AddNewContact(sender: AnyObject) {
        
    }
    
    @IBAction func AddNewChat(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatManager = ChatManager()
        crearTabla()
    }
    
    func crearTabla() {
        tableDelegate = TablaChatsDelegate()
        
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadChatRooms() {
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
