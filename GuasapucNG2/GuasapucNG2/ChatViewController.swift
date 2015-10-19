//
//  ChatViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 30-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

/// View that manages the display of all chatRooms.
class ChatViewController: UIViewController, ChatRoomListDelegate, ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var chatManager: ChatManager!
    var tableDelegate: TablaChatsDelegate!
    var adbk = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    // MARK: - Button actions
    
    /// Refresh the local chatRooms.
    @IBAction func refreshChats(sender: AnyObject) {
        chatManager.updateChats()
    }
    
    /// Create a new contact.
    @IBAction func addNewContact(sender: AnyObject) {
        let controller = ABNewPersonViewController()
        controller.newPersonViewDelegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    /// Start a new chat.
    @IBAction func addNewChat(sender: AnyObject) {
        let picker: ABPeoplePickerNavigationController =  ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        self.presentViewController(picker, animated: true, completion:nil)
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatManager = ChatManager(chatRoomListDelegate: self, adbk: adbk)
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
    
    // MARK: - ABNewPersonViewControllerDelegate methods
    
    func newPersonViewController(newPersonView: ABNewPersonViewController, didCompleteWithNewPerson person: ABRecord?) {
        newPersonView.navigationController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - ABPeoplePickerNavigationControllerDelegate methods
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        if property == kABPersonPhoneProperty {
            let numbersValueRef: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
            let numberValueIndex = ABMultiValueGetIndexForIdentifier(numbersValueRef, identifier)
            let numberRaw = ABMultiValueCopyValueAtIndex(numbersValueRef, numberValueIndex).takeRetainedValue() as! String
            let number = cleanNumber(numberRaw)

            let chatRoomToShow = chatManager.getChatRoomForNumber(number)
            peoplePicker.dismissViewControllerAnimated(true, completion: nil)
            performSegueWithIdentifier("IDMostrarChatRoom", sender:  chatRoomToShow)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "IDMostrarChatRoom" {
            let chatRoom = sender as? ChatRoom
            let chatRoomView = segue.destinationViewController as? ChatRoomViewController
            chatRoomView?.refChatRoomToShow = chatRoom
            chatManager.chatMessageListDelegate = chatRoomView
        } else if segue.identifier == "IDCrearChatGrupal" {
            let addGroupView = segue.destinationViewController as? AddGroupViewController
            addGroupView?.refChatManager = chatManager
        }
    }

}