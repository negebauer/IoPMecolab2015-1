//
//  AddGroupView.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 20-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit
import AddressBook
import AddressBookUI

class AddGroupView: UIViewController, ABPeoplePickerNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var GroupNameTexField: UITextField!
    @IBOutlet weak var UserToAddTable: UITableView!
    var chatManager: ChatManager!
    weak var referenciaViewController : ViewControllerGroups!
    var numbers = [String]()
    var names = [String]()
    var dictionaryNumberName = Dictionary<String,String>()
    
    @IBAction func CreateNewGroup(sender: AnyObject) {
        chatManager.createNewChatRoomGroup(numbers, title: GroupNameTexField.text)
    }
    
    @IBAction func ShowPicker(sender: AnyObject) {
        var picker: ABPeoplePickerNavigationController =  ABPeoplePickerNavigationController()
        
        picker.peoplePickerDelegate = self
        self.presentViewController(picker, animated: true, completion:nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
        if property == kABPersonPhoneProperty {
            let numbersValueRef: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
            let numberValueIndex = ABMultiValueGetIndexForIdentifier(numbersValueRef, identifier)
            let numberRaw = ABMultiValueCopyValueAtIndex(numbersValueRef, numberValueIndex).takeRetainedValue() as! String
            let number = Common.limpiarNumero(numberRaw)
            numbers.append(number)
            names.append(chatManager.getNameForContactNumber(number))
            names.sort(<)
            dictionaryNumberName[number] = chatManager.getNameForContactNumber(number)
            UserToAddTable.reloadData()
        }
    }
    
    @IBAction func CerrarVista(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 2/3, alpha: 0.8)
        UserToAddTable.delegate = self
        UserToAddTable.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCellWithIdentifier("IDCeldaUsuarioAgregarAGrupo") as! CeldaUsuarioAgregarAGrupo
        c.LabelNombre.text = names[indexPath.row]
        return c
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let n = numbers[indexPath.row]
            let na = dictionaryNumberName[n]!
            names.removeAtIndex(find(names, na)!)
            numbers.removeAtIndex(find(numbers,n)!)
            dictionaryNumberName.removeValueForKey(n)
        }
    }
    
    @IBAction func HideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
}