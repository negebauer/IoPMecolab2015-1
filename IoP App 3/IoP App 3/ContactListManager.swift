//
//  ContactListManager.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import AddressBook
import AddressBookUI

///Manager de contactos
class ContactListManager : NSObject, ABPeoplePickerNavigationControllerDelegate {
    weak var referenciaAlViewController: ContactsViewController?
    var adbk : ABAddressBook!
    ///Lista de contactos
    var contactos = [Contacto]()
    var letra = ContactListManager.getLetra()
    ///Array con contactos y letras de indice
    var arrayOrdenado = [Contacto]()
    var letrasIndice = [String]()
    ///Manager base de datos local
    let moc = ProjectConstants.managedObjectContext
    var diccionarioNumeroNombre = Dictionary<String,String>()
    var currentUser = ContactListManager.getCurrentUser()
    var diccionarioNumeroContacto = Dictionary<String,Contacto>()
    
    class func getLetra() -> Contacto {
        let fetchRequest = NSFetchRequest(entityName: "Contacto")
        let revisarUsuario = NSPredicate(format: "id == %X", -1)
        fetchRequest.predicate = revisarUsuario
        if let fetchResults = ProjectConstants.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
            if fetchResults.count == 0 {
                let userContact = Contacto.createInManagedObjectContext(ProjectConstants.managedObjectContext!, _nombre: "", _id: -1, _numero: "")
                return userContact
            }
            else {
                return fetchResults[0]
            }
        }
        NSLog("WARNING: Hubo un problema cargando letra")
        return Contacto()
    }

    class func getCurrentUser() -> Contacto {
        let fetchRequest = NSFetchRequest(entityName: "Contacto")
        let revisarUsuario = NSPredicate(format: "id == %X", 0)
        fetchRequest.predicate = revisarUsuario
        if let fetchResults = ProjectConstants.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
            if fetchResults.count == 0 {
                let userContact = Contacto.createInManagedObjectContext(ProjectConstants.managedObjectContext!, _nombre: ProjectConstants.user, _id: 0, _numero: ProjectConstants.userNumber)
                return userContact
            }
            else {
                return fetchResults[0]
            }
        }
        NSLog("WARNING: Hubo un problema cargando contacto usuario")
        return Contacto()
    }
    
    override init() {
        super.init()
        fetchContactos()
    }
    
    ///Carga la lista de contactos de la base de datos local
    func fetchContactos() {
        let fetchRequest = NSFetchRequest(entityName: "Contacto")
        let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = moc!.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
            contactos = fetchResults
            contactos.removeAtIndex(find(contactos, currentUser)!)
            contactos.removeAtIndex(find(contactos, letra)!)
            generarListaOrdenada()
        }
    }
    
    func generarListaOrdenada() {
        letrasIndice.removeAll(keepCapacity: false)
        arrayOrdenado.removeAll(keepCapacity: false)
        diccionarioNumeroContacto.removeAll(keepCapacity: false)
        for c in contactos {
            if c == currentUser || c == letra{
                NSLog("Me salte current user o letra")
                continue
            }
            if !contains(letrasIndice, c.letraOrdenar()) {
                letrasIndice.append(c.letraOrdenar())
                arrayOrdenado.append(letra)
            }
            arrayOrdenado.append(c)
            diccionarioNumeroContacto[c.numero] = c
        }
        NSLog("Lista ordenada hecha")
        NSLog("Largo lista contactos: " + String(contactos.count))
        NSLog("Largo lista ordenada: " + String(arrayOrdenado.count))
    }
    
    func saveData() {
        var error : NSError?
        if(moc!.save(&error) ) {
            if let err = error?.localizedDescription {
                NSLog("Error grabando: ")
                NSLog(error!.localizedDescription as String)
            }
        }
    }
    
    ///Funciona saca de http://stackoverflow.com/questions/24752627/accessing-ios-address-book-with-swift-array-count-of-zero
    ///Muestra los nombres de todos los contactos en consola
    func getAddressBookContacts() {
        if !self.determineStatus() {
            //----- Codigo sacado de http://www.ioscreator.com/tutorials/display-an-alert-view-in-ios8-with-swift
            //Para hacer una alerta
            let alertController = UIAlertController(title: "No autorizado", message:
                "La aplicación no está autorizada para acceder a los contactos.\nPara solucionarlo abre\nAjustes > Privacidad > Contactos\ny autoriza a IoP App 3", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ups :(", style: UIAlertActionStyle.Default,handler: nil))
            
            referenciaAlViewController?.presentViewController(alertController, animated: true, completion: nil)
            //----- Fin

            return
        }
        //Aqui tenemos todos los contactos de la agenda, hay que compararlos con los web para solo almacenar aquellos que estan en ambos lugares
        let people = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray as [ABRecord]
        diccionarioNumeroNombre = Dictionary<String,String>()
        for person in people {
            if ABRecordCopyCompositeName(person) != nil {
                let phone : ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
                if ABMultiValueCopyArrayOfAllValues(phone) != nil {
                    let nombre = ABRecordCopyCompositeName(person).takeRetainedValue() as! String
                    let phoneArray : NSArray = ABMultiValueCopyArrayOfAllValues(phone).takeRetainedValue()
                    let numero = limpiarNumero(phoneArray[0] as! String)
//                    NSLog("Nombre: "+nombre + "\tNumero: "+numero)
                    diccionarioNumeroNombre[limpiarNumero(numero)] = nombre
                }
            }
        }
    }
    
    func obtenerNumerosTelefonoRegistradosConSuID() {
        var diccionarioIDNumeroTelefono = Dictionary<Int,String>()
        
        let request = NSMutableURLRequest(URL: NSURL(string: ProjectConstants.usersURL)!)
        request.HTTPMethod = "GET"
        request.addValue(ProjectConstants.tokenFormat, forHTTPHeaderField: "Authorization")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonContacto in jsonArray {
                    if let diccionarioContacto = jsonContacto as? Dictionary<String,NSObject> {
                        //esto es solo porque ya se como viene el json
//                        let nombre = diccionarioContacto["nombre"] as! String
                        let numero = diccionarioContacto["phone_number"] as! String
                        let id = diccionarioContacto["id"] as! Int
//                        NSLog("Numero: " + numero + "\tid: " + String(id))
                        diccionarioIDNumeroTelefono[id] = numero
                    }}}
            self.compareWebWithLocalContacts(diccionarioIDNumeroTelefono)
        }
        task.resume()
    }
    
    func compareWebWithLocalContacts(diccionarioIDNumeroWeb:Dictionary<Int,String>) {
        for id in diccionarioIDNumeroWeb.keys {
            //Tenemos un match! Un contacto nuestro tiene la app instalada :D
            if diccionarioNumeroNombre.indexForKey(diccionarioIDNumeroWeb[id]!) != nil {
                //Veamos si este contacto ya esta en nuestro Database
                let fetchRequest = NSFetchRequest(entityName: "Contacto")
                let revisarId = NSPredicate(format: "id == %X", id)
                fetchRequest.predicate = revisarId
                if let fetchResults = moc!.executeFetchRequest(fetchRequest, error: nil) as? [Contacto] {
                    //Si no esta, lo agregamos
                    if fetchResults.count == 0 {
                        let numero = diccionarioIDNumeroWeb[id]
                        let nombre = diccionarioNumeroNombre[numero!]
                        addNewContact(nombre!, id: id, numero: numero!, reload: false)
                    }
                    //Si esta, editar si ha cambiado
                    else if fetchResults.count == 1 {
                        let contactoLocal = fetchResults[0]
                        //Revisemos si ha cambiado, si es asi lo actualizamos
                        let numero = diccionarioIDNumeroWeb[id]
                        let nombre = diccionarioNumeroNombre[numero!]
                        
                        if contactoLocal.numero != numero || contactoLocal.nombre != nombre {
                            contactoLocal.nombre = nombre!
                            contactoLocal.numero = numero!
                            saveData()
                        }
                    }
                }
            }
        }
        fetchContactos()
        referenciaAlViewController?.TablaContactos.reloadData()
        self.referenciaAlViewController?.refreshControl.endRefreshing()
    }
    
    func addNewContact(nombre:String, id:Int, numero:String, reload:Bool) {
        // Create the contacto
        if let moc = moc {
            var newContacto = Contacto.createInManagedObjectContext(moc, _nombre: nombre, _id: id, _numero: numero)
            if reload {
                fetchContactos()
                referenciaAlViewController?.TablaContactos.reloadData()
            }
            saveData()
        }
    }
    
    func updateContacts() {
        getAddressBookContacts()
        obtenerNumerosTelefonoRegistradosConSuID()
    }
    
    func limpiarNumero(num:String) -> String {
        var numLimpio = ""
        for letra in num {
            if letra == "(" || letra == ")" || letra == "+" || letra == "-" || letra == " "{
                
            }
            else {
                numLimpio += String(letra)
            }
        }
        
        let components = numLimpio.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
        
        return join("", components)
    }
    
    ///Funcion sacada de http://stackoverflow.com/questions/24752627/accessing-ios-address-book-with-swift-array-count-of-zero
    ///Crea el address book
    func createAddressBook() -> Bool {
        if self.adbk != nil {
            return true
        }
        var err : Unmanaged<CFError>? = nil
        let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            println(err)
            self.adbk = nil
            return false
        }
        self.adbk = adbk
        return true
    }
    
    ///Funcion sacada de http://stackoverflow.com/questions/24752627/accessing-ios-address-book-with-swift-array-count-of-zero
    ///Revisa el permiso para acceder a los contactos. Si permiso, retorna el addrress book.
    func determineStatus() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .Authorized:
            return self.createAddressBook()
        case .NotDetermined:
            var ok = false
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        ok = self.createAddressBook()
                    }
                }
            }
            if ok == true {
                return true
            }
            self.adbk = nil
            return false
        case .Restricted:
            self.adbk = nil
            return false
        case .Denied:
            self.adbk = nil
            return false
        }
    }
}