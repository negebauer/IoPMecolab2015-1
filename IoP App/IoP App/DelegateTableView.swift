//
//  DelegateTableView.swift
//  IoP App
//
//  Created by Nicolás Gebauer on 01-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class DelegateTableView : NSObject, UITableViewDelegate, UITableViewDataSource {
    var listaAlumnos : [String] = []
    weak var referenciaAlControlador : UIViewController?
    var contactoMostrar : Contacto?
    var listaContactos : ListaContactos?
    var labelDetallesLandscape : UILabel?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let lista = listaContactos?.arrayContactos{
            return lista.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let contacto = listaContactos?.arrayContactos[indexPath.row] {
            if contacto.celdaLetra {
                let celdaLetra = tableView.dequeueReusableCellWithIdentifier("IdentificadorCeldaLetra") as! CeldaLetra
                celdaLetra.LabelLetra.text = " " + contacto.nombreCompleto
                celdaLetra.LabelLetra.backgroundColor = UIColor.lightGrayColor()
                return celdaLetra
            }
            else if !contacto.celdaLetra {
                let celdaNombre = tableView.dequeueReusableCellWithIdentifier("IdentificadorCeldaNombre") as! CeldaNombre
                celdaNombre.LabelNombre.text = contacto.nombreCompleto
                return celdaNombre
            }
            else {
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let referencia = referenciaAlControlador{
            if let contacto = listaContactos?.arrayContactos[indexPath.row] {
                contactoMostrar = contacto
                if referenciaAlControlador?.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact && referenciaAlControlador?.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact {
                    labelDetallesLandscape?.text = contacto.nombreCompleto
                }
                else if !contacto.celdaLetra {
                    referencia.performSegueWithIdentifier("IdentificadorTransicionVistaListaADetalle", sender: referencia)
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let contacto = listaContactos?.arrayContactos[indexPath.row]{
            if contacto.celdaLetra {
                return 20
            }
            else if !contacto.celdaLetra {
                return 40
            }
        }
        return 0
    }
    
    func agregarContacto(nuevoContacto:Contacto){
        //agregar contactos
        println("Se agrego un nuevo contacto")
        println("Nombre: " + nuevoContacto.nombreCompleto)
        listaContactos?.agregarContacto(nuevoContacto)
    }
}