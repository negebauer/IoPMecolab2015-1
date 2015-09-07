//
//  ObtenerDatosDeAddressBook.swift
//  RepoSnippets
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI

//class ContactListManager : NSObject, ABPeoplePickerNavigationControllerDelegate


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
}



//Obtener datos de address book person

for person in people {

    //let p = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue() as! NSArray
    let phone : ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue();
    let phoneArray : NSArray = ABMultiValueCopyArrayOfAllValues(phone).takeRetainedValue();
    //Logea los numeros
    NSLog("Numero de telefono: " + limpiarNumero((phoneArray[0] as! String)))

    //            ABRecordCopyValue(ABRecordGetRecordType(ABRecordType(), ABPropertyID())
    //Logea los nombres
    NSLog(ABRecordCopyCompositeName(person).takeRetainedValue() as String)
}


ABMultiValueCopyArrayOfAllValues(ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()).takeRetainedValue()