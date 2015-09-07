//
//  Contacto.swift
//  IoP App 3
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData

class Contacto: NSManagedObject, NSCoding {

    @NSManaged var nombre: String
    @NSManaged var id: NSNumber
    @NSManaged var numero: String
    @NSManaged var url: String
    @NSManaged var updatedAt: NSDate
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, _nombre: String, _id:Int, _numero:String) -> Contacto {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Contacto", inManagedObjectContext: moc) as! IoP_App_3.Contacto
        newItem.nombre = _nombre.capitalizedString
        newItem.id = _id
        newItem.numero = _numero
        
        return newItem
    }
    
    func returnURL() -> NSURL {
        return NSURL(string: url)!
    }
    
    func updateURL(URL:String) {
        self.url = URL
    }
    
    func letraOrdenar() -> String {
        if nombre != "" {
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
