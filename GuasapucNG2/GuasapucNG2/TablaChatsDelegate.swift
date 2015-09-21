//
//  TablaChatsDelegate.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 05-09-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

/// Delegate that manages the representation of the chatRooms.
class TablaChatsDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var refChatManager: ChatManager!
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}