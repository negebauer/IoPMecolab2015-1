//
//  Functions.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// Returns a string transformed into a NSDate using the format "yyy-MM-dd'T'HH:mm:ss.SSS'Z'".
func getDateFromString(str: String) -> NSDate {
    let formatter = NSDateFormatter()
    formatter.dateFormat="yyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter.dateFromString(str)!
}

/// Returns a NSDate transformed into a string using the format "yyy-MM-dd'T'HH:mm:ss.SSS'Z'".
func getStringFromDate(date: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat="yyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter.stringFromDate(date)
}

/// Compares to date and returns true if date1 > date2, returns false if not.
func isDate1GreaterThanDate2(date1:NSDate, date2:NSDate) -> Bool {
    return date1.compare(date2).rawValue == 1 ? true : false
}

/// Blocks acces to lock while closure() is being executed.
func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

/// Cleans a string representing a number by deleting spaces and symbols.
func cleanNumber(num:String) -> String {
    var numLimpio = ""
    for letra in num.characters {
        if !(letra == "(" || letra == ")" || letra == "+" || letra == "-" || letra == " ") {
            numLimpio += String(letra)
        }
    }
    
    let components = numLimpio.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!$0.characters.isEmpty})
    
    return components.joinWithSeparator("")
}

/// Saves the database if there have been changes
func saveDatabase() {
    (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
}