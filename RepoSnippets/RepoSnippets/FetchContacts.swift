//
//  FetchContacts.swift
//  RepoSnippets
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import CoreData


func fetchContactos() {
    let fetchRequest = NSFetchRequest(entityName: "Contacto")
    
    // Create a sort descriptor object that sorts on the "letraO"
    // property of the Core Data object
    let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
    
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