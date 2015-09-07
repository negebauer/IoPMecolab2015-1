//
//  Functions.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

func getDateFromString(str:String) -> NSDate {
    let formatter = NSDateFormatter()
    formatter.dateFormat="yyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter.dateFromString(str)!
}

func isDate1GreaterThanDate2(date1:NSDate, date2:NSDate) -> Bool {
    return date1.compare(date2).rawValue == 1 ? true : false
}

///Bloquea una objeto impidiendo ser accedido mientras se ejecuta closure()
func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

///Elimina espacios y simbolos de un string de un numero
func limpiarNumero(num:String) -> String {
    var numLimpio = ""
    for letra in num {
        if letra == "(" || letra == ")" || letra == "+" || letra == "-" || letra == " "{ }
        else { numLimpio += String(letra) }}
    
    let components = numLimpio.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
    
    return join("", components)
}