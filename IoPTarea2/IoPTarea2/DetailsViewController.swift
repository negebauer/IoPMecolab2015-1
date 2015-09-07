//
//  ListDetailsViewController.swift
//  IoPTarea2
//
//  Created by Nicolás Gebauer on 29-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class DetailsLista : UIViewController {
    @IBOutlet weak var LabelDetalles: UILabel!
    var stringDetalles = ""
    
    override func viewDidLoad() {
        LabelDetalles.text = stringDetalles
    }
}