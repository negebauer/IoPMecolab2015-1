//
//  Contacto.swift
//  IoP App
//
//  Created by Nicolás Gebauer on 02-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation

class Contacto{
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    var nombreCompleto = ""
    var celdaLetra = false
    var nombreCompletoParaArchivo = ""
    
    init(_nombre:String, _apellidoPaterno:String, _apellidoMaterno:String) {
        nombre = _nombre.capitalizedString + ""
        apellidoPaterno = _apellidoPaterno.capitalizedString + ""
        apellidoMaterno = _apellidoMaterno.capitalizedString + ""
        celdaLetra = false
        if nombre == "" && apellidoMaterno == "" && count(apellidoPaterno) == 1 {
            celdaLetra = true
            nombreCompleto = apellidoPaterno
        }
        else if apellidoPaterno == "" && apellidoMaterno == "" {
            nombreCompleto = nombre
            nombreCompletoParaArchivo = "" + ";" + "" + ";" + nombre
        }
        else if apellidoPaterno == "" && nombre == "" {
            nombreCompleto = apellidoMaterno
            nombreCompletoParaArchivo = "" + ";" + apellidoMaterno + ";" + ""
        }
        else if nombre == "" && apellidoMaterno == "" {
            nombreCompleto = apellidoPaterno
            nombreCompletoParaArchivo = apellidoPaterno + ";" + "" + ";" + ""
        }
        else if apellidoMaterno == "" {
            nombreCompleto = nombre + " " + apellidoPaterno
            nombreCompletoParaArchivo = apellidoPaterno + ";" + "" + ";" + nombre
        }
        else if apellidoPaterno == "" {
            nombreCompleto = nombre + " " + apellidoMaterno
            nombreCompletoParaArchivo = "" + ";" + apellidoMaterno + ";" + nombre
        }
        else {
            nombreCompleto = nombre + " " + apellidoPaterno + " " + apellidoMaterno
            nombreCompletoParaArchivo = apellidoPaterno + ";" + apellidoMaterno + ";" + nombre
        }
    }
    
    func letraOrdenar() -> String {
        if apellidoPaterno != "" {
            return revisarPrimeraLetra(apellidoPaterno.substringToIndex(advance(apellidoPaterno.startIndex, 1)))
        }
        else if apellidoMaterno != "" {
            return revisarPrimeraLetra(apellidoMaterno.substringToIndex(advance(apellidoMaterno.startIndex, 1)))
        }
        else if nombre != "" {
            return revisarPrimeraLetra(nombre.substringToIndex(advance(nombre.startIndex, 1)))
        }
        else {
            return ""
        }
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