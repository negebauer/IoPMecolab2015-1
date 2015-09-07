//
//  ViewController.swift
//  IoP App
//
//  Created by Nicolás Gebauer on 01-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var LabelDetallesLandscape: UILabel!

    @IBOutlet weak var TablaContactos: UITableView!
    var delegateTableView : DelegateTableView?
    
    @IBAction func openAddContact(sender: AnyObject) {
        self.performSegueWithIdentifier("IdentificadorTransicionVistaListaAAgregarContacto", sender: self)
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue){
        TablaContactos.reloadData()
    }
    
    func reloadLabelLandscape(texto:String) {
        LabelDetallesLandscape.text = texto
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        detailsViewController2.LabelDetalles2.text = "aasi funciona"
        delegateTableView = DelegateTableView()
        if let delegate = delegateTableView{
            delegate.listaContactos = ListaContactos(texto: "ListaAlumnosMejorada")
            delegate.listaContactos?.referenciaALaTabla = delegate
            delegate.referenciaAlControlador = self
            delegate.labelDetallesLandscape = LabelDetallesLandscape
            TablaContactos.dataSource = delegate
            TablaContactos.delegate = delegate
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identificador = segue.identifier {
            if identificador == "IdentificadorTransicionVistaListaADetalle" {
                let controllerDetalles = segue.destinationViewController as! DetailsViewController
//                destination.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                if let nombre = delegateTableView?.contactoMostrar?.nombreCompleto {
                    controllerDetalles.stringDetalles = nombre
                }
            }
            else if identificador == "IdentificadorTransicionVistaListaAAgregarContacto" {
                let controllerAdd = segue.destinationViewController as! AddContactViewController
                controllerAdd.referenciaALaTabla = delegateTableView
            }
        }
        else {
            println("No hay un identificador")
        }
    }
}
