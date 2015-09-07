//
//  ContactsViewController.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 26-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import Foundation

class ContactsViewController: UIViewController {
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var NavigationBar: UINavigationBar!
    @IBOutlet weak var TablaContactos: UITableView!
    var delegateTablaContactos : TablaContactosDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        delegateTablaContactos = TablaContactosDelegate()
        delegateTablaContactos?.referenciaAlViewController = self
        delegateTablaContactos?.contactListManager.referenciaAlViewController = self
        
        var chatTab = self.tabBarController?.viewControllers![1] as! ChatsViewController
        chatTab.referenciaContactListManager = delegateTablaContactos?.contactListManager
        
        TablaContactos.delegate = delegateTablaContactos
        TablaContactos.dataSource = delegateTablaContactos
        
        //----- Codigo sacado de http://stackoverflow.com/questions/26109581/pull-to-refresh-in-swift
        //Para anadir un pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.TablaContactos.addSubview(refreshControl)
        //----- Fin
        
        //----- Codigo sacado de http://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically
        //Para anadir constraints a una nueva view
        //Modificada para que calce en la mitad arriba
        refreshControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constX = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(constX)
        
        var constY = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: NavigationBar, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 0.1, constant: 0)
        view.addConstraint(constY)
        
        var constW = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        refreshControl.addConstraint(constW)
        //view.addConstraint(constW) also works
        
        var constH = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        refreshControl.addConstraint(constH)
        //view.addConstraint(constH) also works
        //----- Fin

        delegateTablaContactos?.updateContacts()
        
        NSLog("Contact view loaded")
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        
        delegateTablaContactos?.updateContacts()
    }
    
    override func viewDidAppear(animated: Bool) {
        NSLog("Contact view appeared")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

