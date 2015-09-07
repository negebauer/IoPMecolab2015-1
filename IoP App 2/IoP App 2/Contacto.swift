//
//  Contacto.swift
//  IoP App 2
//
//  Created by Nicolás Gebauer on 15-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class Contacto: NSManagedObject {

    @NSManaged var apellidoM: String
    @NSManaged var apellidoP: String
    @NSManaged var id: NSNumber
    @NSManaged var letraO: String
    @NSManaged var nombre: String
    @NSManaged var nombreOrden: String
    @NSManaged var isContactoWeb: Bool
    @NSManaged var idWeb :Int
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, _nombre: String, _apellidoP: String, _apellidoM: String, _isContactoWeb:Bool, _idWeb:Int) -> Contacto {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Contacto", inManagedObjectContext: moc) as! IoP_App_2.Contacto
        newItem.nombre = _nombre.capitalizedString
        newItem.apellidoP = _apellidoP.capitalizedString
        newItem.apellidoM = _apellidoM.capitalizedString
        newItem.idWeb = _idWeb
        newItem.isContactoWeb = _isContactoWeb
        newItem.letraO = newItem.letraOrdenar()
        newItem.nombreOrden = newItem.nombreOrdenar()
        
        return newItem
    }
    
    func nombreCompleto() -> String {
        return (nombre != "" ? nombre: "") + " " + (apellidoP != "" ? apellidoP: "") + " " + (apellidoM != "" ? apellidoM: "")
    }
    
    func nombreOrdenar() -> String {
        let nombreConAcentos = (apellidoP != "" ? apellidoP: "") + " " + (apellidoM != "" ? apellidoM: "") + " " + (nombre != "" ? nombre: "")
        var nombreSinAcentos = ""
        for letra in nombreConAcentos {
            nombreSinAcentos = nombreSinAcentos + revisarPrimeraLetra(String(letra))
        }
        return nombreSinAcentos
    }
    
    func letraOrdenar() -> String {
        if apellidoP != "" {
            return revisarPrimeraLetra(apellidoP.substringToIndex(advance(apellidoP.startIndex, 1)))
        }
        else if apellidoM != "" {
            return revisarPrimeraLetra(apellidoM.substringToIndex(advance(apellidoM.startIndex, 1)))
        }
        else if nombre != "" {
            return revisarPrimeraLetra(nombre.substringToIndex(advance(nombre.startIndex, 1)))
        }
        return ""
    }
    
    func revisarPrimeraLetra(letra:String) -> String{
        switch letra{
        case "Á":
            return "A"
        case "É":
            return "E"
        case "Í":
            return "I"
        case "Ó":
            return "O"
        case "Ú":
            return "U"
        default:
            return letra
        }
    }
}