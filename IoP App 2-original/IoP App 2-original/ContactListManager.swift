//
//  ContactListManager.swift
//  IoP App 2
//
//  Created by Nicolás Gebauer on 15-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit
import Foundation
import CoreData

///Manager de contactos
class ContactListManager {
    ///Lista de contactos
    var contactos = [Contacto]()
    var letra = Contacto()
    var arrayOrdenado = [Contacto]()
    var letrasIndice = [String]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init() {
        fetchContactos()
        if contactos.count == 0 {
            cargarDatosArchivo("ListaAlumnosMejorada.nicgeb")
            fetchContactos()
        }
    }
    
    ///Descarga contactos de la WebDatabase y los actualiza correctamente (solo filtra los ya bajados)
    func syncContactosWeb(url: NSURL, tabla: UITableView) {
        //Meter en un thread
        let data = NSData(contentsOfURL: url)
//        let jsonString = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        var idsContactosWeb = [Int]()
        var contactosWeb = [Contacto]()
        let fetchRequest = NSFetchRequest(entityName: "Contacto")
        let soloContactosWeb = NSPredicate(format: "idWeb > %X", 0)
        fetchRequest.predicate = soloContactosWeb
        if let fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
            contactosWeb = fetchResults
        }

        if let jsonArray = jsonSwift as? NSArray {
            for jsonContacto in jsonArray {
                if let diccionarioContacto = jsonContacto as? Dictionary<String,NSObject> {
                    //esto es solo porque ya se como viene el json
                    let nombre = diccionarioContacto["nombre"] as! String
                    let apellidoP = diccionarioContacto["apellidoP"] as! String
                    let apellidoM = diccionarioContacto["apellidoM"] as! String
                    let idWeb = diccionarioContacto["id"] as! Int
                    idsContactosWeb.append(idWeb)
                    
                    //Veamos si este contacto ya esta en nuestro Database
                    let fetchRequest = NSFetchRequest(entityName: "Contacto")
                    let revisarIdWeb = NSPredicate(format: "idWeb == %X", idWeb)
                    fetchRequest.predicate = revisarIdWeb
                    if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
                        //Si no esta, lo agregamos
                        if fetchResults.count == 0 {
                            addNewContact(nombre, apellidoP: apellidoP, apellidoM: apellidoM, referenciaTabla: tabla, isContactoWeb: true, idWeb: idWeb)
                        }
                        //Si esta, editar si ha cambiado
                        else if fetchResults.count == 1 {
                            let contactoLocal = fetchResults[0]
                            //Revisemos si ha cambiado, si es asi lo actualizamos
                            if contactoLocal.nombre != nombre || contactoLocal.apellidoP != apellidoP || contactoLocal.apellidoM != apellidoM {
                                contactoLocal.nombre = nombre
                                contactoLocal.apellidoP = apellidoP
                                contactoLocal.apellidoM = apellidoM
                                saveData()
                            }
                        }
                    }
                }
            }
            //Veamos si se borro alguno
            for c in contactosWeb {
                if !contains(idsContactosWeb, c.idWeb) {
                    managedObjectContext?.deleteObject(c)
                }
            }
            fetchContactos()
            tabla.reloadData()
            
//            if let jsonContacto0 = jsonArray[0] as? Dictionary<String,NSObject> {
//                println(jsonContacto0["nombre"] as! String)
//            }
        }
    }
    
    func addNewContact(nombre:String, apellidoP:String, apellidoM:String, referenciaTabla:UITableView, isContactoWeb:Bool, idWeb:Int) {
        // Create the contacto
        if let moc = managedObjectContext {
            var newContacto = Contacto.createInManagedObjectContext(moc, _nombre: nombre, _apellidoP: apellidoP, _apellidoM: apellidoM, _isContactoWeb: isContactoWeb, _idWeb: idWeb)
            
            // Update the array containing the table view row data
            self.fetchContactos()
            referenciaTabla.reloadData()
            
            // Animate in the new row
            // Use Swift's find() function to figure out the index of the newContacto
            // after it's been added and sorted in our arrayOrdenado
//            if let newContactoIndex = find(arrayOrdenado, newContacto) {
//                if contains(letrasIndice, newContacto.letraO) {
//                    // Create an NSIndexPath from the newContactoIndex
//                    let newContactoIndexPath = NSIndexPath(forRow: (newContactoIndex + find(letrasIndice, newContacto.letraO)!), inSection: 0)
//                    // Animate in the insertion of this row
//                    referenciaTabla.insertRowsAtIndexPaths([ newContactoIndexPath ], withRowAnimation: .Automatic)
//                }
//                else {
//                    // Create an NSIndexPath from the newContactoIndex
//                    referenciaTabla.reloadData()
//                    // Animate in the insertion of this row
//                }
//            }
            saveData()
        }
    }
    
    func saveData() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            if let err = error?.localizedDescription {
                NSLog("Error grabando: ")
                NSLog(error!.localizedDescription as String)
            }
        }
    }
    
    func generarListaOrdenada() {
        letrasIndice.removeAll(keepCapacity: false)
        arrayOrdenado.removeAll(keepCapacity: false)
        for c in contactos {
            if !contains(letrasIndice, c.letraO) {
                letrasIndice.append(c.letraO)
                arrayOrdenado.append(letra)
            }
            arrayOrdenado.append(c)
        }
        println("Lista ordenada hecha")
        println("Largo lista: " + String(arrayOrdenado.count))
    }
    
    ///Reinicia la lista de contactos
    func fetchContactos() {
        let fetchRequest = NSFetchRequest(entityName: "Contacto")
        
        // Create a sort descriptor object that sorts on the "letraO"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "nombreOrden", ascending: true)
        
        //Set the list of sort descriptors in the fetch request,
        //so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
            contactos = fetchResults
            generarListaOrdenada()
        }
        /*
        Maneras de filtrar (predicate)
                // Create a new predicate that filters out any object that
                // doesn't have a title of "Best Language" exactly.
                let predicate = NSPredicate(format: "title == %@", "Best Language")
        
                // Set the predicate on the fetch request
                fetchRequest.predicate = predicate
        
                // Search for only items using the substring "Worst"
                let predicate = NSPredicate(format: "title contains %@", "Worst")
        
                // Set the predicate on the fetch request
                fetchRequest.predicate = predicate
        */

        /*
        Combinando filtraciones (predicates)
                // Create a new predicate that filters out any object that
                // doesn't have a title of "Best Language" exactly.
                let firstPredicate = NSPredicate(format: "title == %@", "Best Language")
        
                // Search for only items using the substring "Worst"
                let thPredicate = NSPredicate(format: "title contains %@", "Worst")
                Then combine them using the NSCompoundPredicate constructor:
        
                // Combine the two predicates above in to one compound predicate
                let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [firstPredicate, thPredicate])
        
                // Set the predicate on the fetch request
                fetchRequest.predicate = predicate
        */
    }
    
    ///Cargar los contactos iniciales si no hay nada en la base de datos
    func cargarDatosArchivo(archivo:String) {
        let archivoYExtension = archivo.componentsSeparatedByString(".")
        if let filePath = NSBundle.mainBundle().pathForResource(archivoYExtension[0], ofType: archivoYExtension[1]) {
            let possibleContent = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)
            let arrayNombres = possibleContent?.componentsSeparatedByString("\r\n")
            var listaCompleta = [String]()
            for nombre in arrayNombres! {
                let nombreApellidoPApellidoM = nombre.capitalizedString.componentsSeparatedByString(";")
                if let moc = managedObjectContext {
                    Contacto.createInManagedObjectContext(moc, _nombre: nombreApellidoPApellidoM[2], _apellidoP: nombreApellidoPApellidoM[0], _apellidoM: nombreApellidoPApellidoM[1], _isContactoWeb: false, _idWeb: 0)
                }
                else {
                    println("Fallo creador manager database")
                }
            }
        }
    }
}