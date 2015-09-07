//
//  ViewController.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 03-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class ViewControllerGroups: UIViewController {
    weak var chatManager: ChatManager!
    
    @IBOutlet weak var TablaChats: UITableView!
    var delegateChatTableGroups : TablaChatsDelegateGroups?
    
    @IBAction func CreateNewGroup(sender: AnyObject) {
        self.performSegueWithIdentifier("IDCrearNuevoGrupo", sender: self)
    }
    
    @IBAction func UpdateAction(sender: AnyObject) {
        delegateChatTableGroups?.chatManager.updateChats()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarTabla()
        //UpdateAction(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TablaChats.reloadData()
    }
    
    func cargarTabla() {
        delegateChatTableGroups = TablaChatsDelegateGroups()
        delegateChatTableGroups?.referenciaAlViewControllerGroups = self
        delegateChatTableGroups?.chatManager = chatManager
        delegateChatTableGroups?.chatManager.referenciaAlDelegateGroups = delegateChatTableGroups
        
        TablaChats.delegate = delegateChatTableGroups
        TablaChats.dataSource = delegateChatTableGroups
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        if segue.identifier == "IDMostrarChatRoom" {
            let chatRoom = delegateChatTableGroups?.chatManager.chatRoomsGroups[delegateChatTableGroups!.indexChatRoomAMostrar - 1]
            let chatRoomDetails = segue.destinationViewController as! ChatRoomView
            chatRoomDetails.chatRoomToShow = chatRoom!
            chatRoomDetails.referenciaAlViewControllerGroups = self
        }
        else if segue.identifier == "IDCrearNuevoGrupo" {
            let addGroupView = segue.destinationViewController as! AddGroupView
            addGroupView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            addGroupView.referenciaViewController = self
            addGroupView.chatManager = chatManager
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

