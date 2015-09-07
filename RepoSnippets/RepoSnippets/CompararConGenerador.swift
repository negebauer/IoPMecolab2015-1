//
//  CompararConGenerador.swift
//  RepoSnippets
//
//  Created by Nicolás Gebauer on 29-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation


//Generador
{n1, n2 in return n1.letraOrdenar() < n2.letraOrdenar()}

if elements.filter({ el in el == 5 }).count > 0 {
}

if elements.filter({$0 == 5}).count > 0 {
}

//https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html

var filteredArray = arrayOfUsers.filter( { (user: UserDetails) -> Bool in
    return user.userID == "1"
})