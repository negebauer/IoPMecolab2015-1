//
//  AgregarConstraints.swift
//  RepoSnippets
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation


//----- Codigo sacado de http://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically
//Para anadir constraints a una nueva view
//Modificada para que calce en la mitad arriba
refreshControl.setTranslatesAutoresizingMaskIntoConstraints(false)

var constX = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
view.addConstraint(constX)

var constY = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: TablaContactos, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
view.addConstraint(constY)

var constW = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
refreshControl.addConstraint(constW)
//view.addConstraint(constW) also works

var constH = NSLayoutConstraint(item: refreshControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
refreshControl.addConstraint(constH)
//view.addConstraint(constH) also works
//----- Fin