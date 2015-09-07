//
//  CreateGroupTableViewCell.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 30-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class CreateGroupTableViewCell: UITableViewCell {

    weak var refChatViewController: ChatViewController!
    
    @IBAction func CreateNewGroup(sender: AnyObject) {
        if let ref = refChatViewController {
            ref.performSegueWithIdentifier("IDCrearChatGrupal", sender: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
