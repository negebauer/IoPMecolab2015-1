//
//  TablaContactosDelegate.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 26-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class TablaContactosDelegate : NSObject, UITableViewDelegate, UITableViewDataSource {
    var nombreDetalle = " "
    var contactListManager = ContactListManager()
    weak var referenciaAlViewController : ContactsViewController?
    
    func updateContacts() {
        contactListManager.updateContacts()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if contactListManager.arrayOrdenado[indexPath.row] == contactListManager.letra {
            let c = contactListManager.arrayOrdenado[indexPath.row + 1]
            let celdaLetra = tableView.dequeueReusableCellWithIdentifier("IDCeldaLetra") as! CeldaLetra
            celdaLetra.LabelLetra.text = " " + c.letraOrdenar() //un pequeño espacio para que se vea mejor
            celdaLetra.backgroundColor = UIColor.lightGrayColor()
            return celdaLetra
        }
        else {
            let c = contactListManager.arrayOrdenado[indexPath.row]
            let celdaNombre = tableView.dequeueReusableCellWithIdentifier("IDCeldaNombre") as! CeldaNombre
            celdaNombre.LabelNombre.text = c.nombre
            return celdaNombre
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if contactListManager.arrayOrdenado[indexPath.row] == contactListManager.letra {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
        else {
            //SEGUE A DETALLES
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contactListManager.arrayOrdenado[indexPath.row] == contactListManager.letra {
            return 20
        }
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListManager.arrayOrdenado.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if contactListManager.arrayOrdenado[indexPath.row] == contactListManager.letra {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            //            let indexReal = NSIndexPath(forRow: (indexPath.row - letrasEnCeldas.count), inSection: indexPath.section)
            // Find the Contacto object the user is trying to delete
            let contactoToDelete = contactListManager.arrayOrdenado[indexPath.row]
            let letra = contactoToDelete.letraOrdenar()
            
            // Delete it from the managedObjectContext
            contactListManager.moc?.deleteObject(contactoToDelete)
            
            // Refresh the contact list to indicate that it's deleted
            contactListManager.fetchContactos()
            
            if !(contains(contactListManager.letrasIndice, letra)) {
                referenciaAlViewController?.TablaContactos.reloadData()
            }
            else {
                // Tell the table view to animate out that row
                referenciaAlViewController?.TablaContactos.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) //sino,             realoadData() para que se cargue la información de nuevo
            }
            
            contactListManager.saveData()
        }
    }

}