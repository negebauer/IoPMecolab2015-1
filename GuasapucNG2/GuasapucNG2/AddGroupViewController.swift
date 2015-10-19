//
//  AddGroupViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 20-09-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit
import AddressBook
import AddressBookUI

/// View that manages the creation of a new group.
class AddGroupViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupNameTexField: UITextField!
    @IBOutlet weak var usersToAddTable: UITableView!
    weak var refChatManager: ChatManager!
    weak var refChatViewController: ChatViewController!
    var numbers = [String]()
    var names = [String]()
    var dictionaryNumberName = Dictionary<String, String>()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 2/3, alpha: 0.8)
        usersToAddTable.delegate = self
        usersToAddTable.dataSource = self
    }
    
    // MARK: - UICalls
    
    @IBAction func createNewGroup(sender: AnyObject) {
        refChatManager.createNewChatRoomGroup(numbers, title: groupNameTexField.text!)
    }
    
    @IBAction func showPicker(sender: AnyObject) {
        let picker: ABPeoplePickerNavigationController =  ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        self.presentViewController(picker, animated: true, completion:nil)
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - ABPeoplePickerNavigationControllerDelegate methods
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
        if property == kABPersonPhoneProperty {
            let numbersValueRef: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
            let numberValueIndex = ABMultiValueGetIndexForIdentifier(numbersValueRef, identifier)
            let numberRaw = ABMultiValueCopyValueAtIndex(numbersValueRef, numberValueIndex).takeRetainedValue() as! String
            let number = cleanNumber(numberRaw)
            numbers.append(number)
            names.append(refChatManager.getNameForContactNumber(number))
            names.sortInPlace(<)
            dictionaryNumberName[number] = refChatManager.getNameForContactNumber(number)
            usersToAddTable.reloadData()
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                let number = numbers[indexPath.row]
                let name = dictionaryNumberName[number]
                names.removeAtIndex(names.indexOf(name!)!)
                numbers.removeAtIndex(names.indexOf(number)!)
                dictionaryNumberName.removeValueForKey(number)
            }
    }
    
    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "IDCellUserToAddToGroup")
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }

}