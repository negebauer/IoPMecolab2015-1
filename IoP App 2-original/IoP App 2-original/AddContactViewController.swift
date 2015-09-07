//
//  AddContactViewController.swift
//  IoP App 2
//
//  Created by Nicolás Gebauer on 20-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class AddContactViewController: UIViewController {
    weak var referenciaViewController : ViewController?
    @IBOutlet weak var LabelNombre: UITextField!
    @IBOutlet weak var LabelApellidoP: UITextField!
    @IBOutlet weak var LabelApellidoM: UITextField!
    
    @IBAction func AddNewContact(sender: AnyObject) {
        if let tabla = referenciaViewController?.TablaNombres {
            referenciaViewController?.delegateTableView?.contactListManager.addNewContact(LabelNombre.text, apellidoP: LabelApellidoP.text, apellidoM: LabelApellidoM.text, referenciaTabla: tabla, isContactoWeb:false, idWeb:0)
        }
    }
    
    @IBAction func cerrarVista() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 2/3, alpha: 0.8)
    }
    
}