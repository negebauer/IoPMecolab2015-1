//
//  AddContactViewController.swift
//  IoP App
//
//  Created by Nicolás Gebauer on 01-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class AddContactViewController: UIViewController {
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textApellidoPaterno: UITextField!
    @IBOutlet weak var textApellidoMaterno: UITextField!
    weak var referenciaALaTabla : DelegateTableView?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func addContact(sender: AnyObject) {
        let nuevoContacto = Contacto(_nombre: textNombre.text, _apellidoPaterno: textApellidoPaterno.text, _apellidoMaterno: textApellidoMaterno.text)
        referenciaALaTabla?.agregarContacto(nuevoContacto)
    }
}