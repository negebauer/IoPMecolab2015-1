//
//  DetailsViewController.swift
//  IoP App
//
//  Created by Nicolás Gebauer on 01-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController : UIViewController {
    @IBOutlet weak var LabelDetalles: UILabel!
    var stringDetalles = ""
    
    override func viewDidLoad() {
        LabelDetalles.text = stringDetalles
    }
}