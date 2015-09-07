//
//  ViewController.swift
//  IoP App 2
//
//  Created by Nicolás Gebauer on 08-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController { //, referenciaPadre {
    @IBOutlet weak var LabelDetallesLandscape: UILabel!
    @IBOutlet weak var TablaNombres : UITableView!
    var delegateTableView : DelegateTableView?
    
    @IBAction func AddContactButton(sender: AnyObject) {
        self.performSegueWithIdentifier("TransicionVistaAddContact", sender: self)
    }
    
    @IBAction func SyncData(sender: AnyObject) {
        var url = NSURL()
        
        #if TARGET_IPHONE_SIMULATOR
            
            url = NSURL(string: "http://0.0.0.0:3000/contactos.json")!
            
            #else
            
            url = NSURL(string: "http://nicolass-macbook-pro.local:3000/contactos.json")!
            
            #endif

        delegateTableView?.contactListManager.syncContactosWeb(url, tabla: TablaNombres)
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue){
        
    }
    
    func updateLabelLandscape(texto:String) {
        LabelDetallesLandscape.text = texto
    }

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegateTableView = DelegateTableView()
        delegateTableView?.referenciaAlControlador = self
        TablaNombres.dataSource = delegateTableView
        TablaNombres.delegate = delegateTableView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "TransicionVistaDetalle" {
                let detalles = segue.destinationViewController as! DetailsViewController
                detalles.stringDetalles = delegateTableView!.nombreDetalle
            }
            else if id == "TransicionVistaAddContact" {
                let addContact = segue.destinationViewController as! AddContactViewController
                addContact.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                addContact.referenciaViewController = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

