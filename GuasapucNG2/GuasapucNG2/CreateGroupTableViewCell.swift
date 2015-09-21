//
//  CreateGroupTableViewCell.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 30-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// Cell that hosts the "CreateNewGroup" button.
class CreateGroupTableViewCell: UITableViewCell {

    weak var refChatViewController: ChatViewController!
    
    /// Shows the view that allows the creation of a new group chatRoom.
    @IBAction func createNewGroup(sender: AnyObject) {
        if let ref = refChatViewController {
            ref.performSegueWithIdentifier("IDCrearChatGrupal", sender: self)
        }
    }

}
