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

class ViewController: UIViewController , ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate {
    weak var chatManager: ChatManager!
    @IBOutlet weak var TablaChats: UITableView!
    var delegateChatTable : TablaChatsDelegate?
    var adbk : ABAddressBook!
    var authDone = false
    
    @IBAction func AddNewContact(sender: AnyObject) {
        let controller = ABNewPersonViewController()
        controller.newPersonViewDelegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func newPersonViewController(newPersonView: ABNewPersonViewController!, didCompleteWithNewPerson person: ABRecord!) {
        newPersonView.navigationController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func UpdateAction(sender: AnyObject) {
        delegateChatTable?.chatManager.updateChats()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        revisarAutorizacionContactos()
        cargarTabla()
        //UpdateAction(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TablaChats.reloadData()
    }
    
    func cargarTabla() {
        delegateChatTable = TablaChatsDelegate()
        delegateChatTable?.referenciaAlViewController = self
        delegateChatTable?.chatManager = chatManager
        delegateChatTable?.chatManager.referenciaAlDelegate = delegateChatTable
        
        TablaChats.delegate = delegateChatTable
        TablaChats.dataSource = delegateChatTable
    }
    
    @IBAction func showPicker(sender: AnyObject) {
        var picker: ABPeoplePickerNavigationController =  ABPeoplePickerNavigationController()

        picker.peoplePickerDelegate = self
        self.presentViewController(picker, animated: true, completion:nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
        if property == kABPersonPhoneProperty {
            self.adbk = peoplePicker.addressBook
            let numbersValueRef: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
            let numberValueIndex = ABMultiValueGetIndexForIdentifier(numbersValueRef, identifier)
            let numberRaw = ABMultiValueCopyValueAtIndex(numbersValueRef, numberValueIndex).takeRetainedValue() as! String
            let number = Common.limpiarNumero(numberRaw)
            
            delegateChatTable?.enviarMensajeAContacto(number)
            TablaChats.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        if segue.identifier == "IDMostrarChatRoom" {
            let chatRoom = delegateChatTable?.chatManager.chatRooms[delegateChatTable!.indexChatRoomAMostrar]
            let chatRoomDetails = segue.destinationViewController as! ChatRoomView
            chatRoomDetails.chatRoomToShow = chatRoom!
            chatRoomDetails.referenciaAlViewController = self
            chatManager.updateChat(chatRoom!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func revisarAutorizacionContactos() {
        if !self.authDone {
            self.authDone = true
            let stat = ABAddressBookGetAuthorizationStatus()
            switch stat {
            case .Denied, .Restricted:
                println("no access")
            case .Authorized, .NotDetermined:
                var err : Unmanaged<CFError>? = nil
                var adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
                if adbk == nil {
                    println(err)
                    return
                }
                ABAddressBookRequestAccessWithCompletion(adbk) {
                    (granted:Bool, err:CFError!) in
                    if granted {
                        self.adbk = adbk
                    } else {
                        println(err)
                    }}}}}
}

