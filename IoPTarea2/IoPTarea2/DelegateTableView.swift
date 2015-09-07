//
//  DelegateTableView.swift
//  IoPTarea2
//
//  Created by Nicolás Gebauer on 25-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class DelegateTableView : NSObject, UITableViewDelegate, UITableViewDataSource{
    var listaAlumnos : [String] = []
    weak var referenciaAlControlador : UIViewController?
    var numeroCelda : Int = 0
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaAlumnos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nombre: String = listaAlumnos[indexPath.row]
        if nombre.utf16Count == 1{
            let celdaLetra = tableView.dequeueReusableCellWithIdentifier("IdentificadorCeldaLetra") as CeldaLetra
            celdaLetra.LabelLetra.text = nombre
            celdaLetra.LabelLetra.backgroundColor = UIColor.lightGrayColor()
//            celdaLetra.LabelLetra.textColor = UIColor.lightTextColor()
            return celdaLetra
        }
        else{
            let celdaNombre = tableView.dequeueReusableCellWithIdentifier("IdentificadorCeldaNombre") as CeldaNombre
            celdaNombre.LabelNombre.text = nombre
            return celdaNombre
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if referenciaAlControlador != nil{
            let nombre: String = listaAlumnos[indexPath.row]
            if nombre.utf16Count == 1{
                //No hacer nada
            }
            else{
                numeroCelda = indexPath.row
                referenciaAlControlador?.performSegueWithIdentifier("IdentificadorTransicionVistaListaADetalle", sender: referenciaAlControlador)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var nombre: String = listaAlumnos[indexPath.row]
        if nombre.utf16Count == 1{
            return 20
        }
        else{
            return 40
        }
    }
    
    func armarListaBonita() {
        let possibleContent = String(contentsOfFile: "/Users/Nico/Documents/Xcode/IoPTarea2/IoPTarea2/ListaAlumnos.txt", encoding: NSUTF8StringEncoding, error: nil)
        let arrayNombres = possibleContent?.componentsSeparatedByString("\n")
        var listaCompleta : Array<String> = []
        var listaNombres : [String]
        var ultimaLetra = ""
        //Como sacar un trozo de string
        //str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 2), end: advance(str.endIndex, -1)))
        for nombre in arrayNombres!{
            var nombreOrdenado : String = nombre.capitalizedString
            var primeraLetraSinRevisar = nombreOrdenado.substringToIndex(advance(nombreOrdenado.startIndex, 1))
            var primeraLetraRevisada : String = ""
            switch primeraLetraSinRevisar{
            case "Á":
                primeraLetraRevisada = "A"
            case "É":
                primeraLetraRevisada = "E"
            case "Í":
                primeraLetraRevisada = "I"
            case "Ó":
                primeraLetraRevisada = "O"
            case "Ú":
                primeraLetraRevisada = "U"
            default:
                primeraLetraRevisada = primeraLetraSinRevisar
            }
            if primeraLetraRevisada != ultimaLetra{
                ultimaLetra = primeraLetraRevisada
                listaCompleta.append(ultimaLetra)
            }
            listaCompleta.append(nombreOrdenado)
        }
        listaAlumnos = listaCompleta
    }
}