//
//  ViewController.swift
//  IoPTarea2
//
//  Created by Nicolás Gebauer on 25-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var TablaContactos: UITableView!
    var delegateTableView : DelegateTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegateTableView = DelegateTableView()
        delegateTableView!.armarListaBonita()
        delegateTableView!.referenciaAlControlador = self
        TablaContactos.dataSource = delegateTableView
        TablaContactos.delegate = delegateTableView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controllerDetalles = segue.destinationViewController as DetailsLista
        controllerDetalles.stringDetalles = delegateTableView!.listaAlumnos[delegateTableView!.numeroCelda]
    }
}
