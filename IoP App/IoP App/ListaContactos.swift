//
//  ListaContactos.swift
//  IoP App
//
//  Created by Nicolás Gebauer on 05-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation

class ListaContactos {
    var arrayContactos : [Contacto] = []
    var nombreArchivoAsociado : String?
    weak var referenciaALaTabla : DelegateTableView?
    let filemgr = NSFileManager.defaultManager()
    
    init(texto:String){
        nombreArchivoAsociado = texto
        armarLista()
    }
    
    func armarLista() {
    let filePath = NSBundle.mainBundle().pathForResource(nombreArchivoAsociado, ofType:"nicgeb")
        if let path = filePath {
            let possibleContent = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            let arrayNombres = possibleContent?.componentsSeparatedByString("\r\n")
            var listaCompleta : [String] = []
            var ultimaLetra = ""
            //Como sacar un trozo de string
            //str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 2), end: advance(str.endIndex, -1)))
            for nombre in arrayNombres!{
                var nombreOrdenado : String = nombre.capitalizedString
                var contactoNuevo = procesarContacto(nombreOrdenado)
                let primeraLetra = contactoNuevo.letraOrdenar()
                if primeraLetra != ultimaLetra{
                    ultimaLetra = primeraLetra
                    arrayContactos.append(Contacto(_nombre: "", _apellidoPaterno: ultimaLetra, _apellidoMaterno: ""))
                }
                arrayContactos.append(contactoNuevo)
            }
        }
    }
    
    func procesarContacto(nombreCompleto:String) -> Contacto {
        let arrayCompleto = nombreCompleto.componentsSeparatedByString(";")
        let apellidoP = arrayCompleto[0]
        let apellidoM = arrayCompleto[1]
        let nombre = arrayCompleto[2]
        return Contacto(_nombre: nombre, _apellidoPaterno: apellidoP, _apellidoMaterno: apellidoM)
    }
    
    func agregarContacto(nuevoContacto:Contacto) {
        arrayContactos.append(nuevoContacto)
        arrayContactos.sort({n1, n2 in return n1.letraOrdenar() < n2.letraOrdenar()})
        actualizarArchivo()
        arrayContactos = []
        armarLista()
    }
    
    func actualizarArchivo() {
        var error: NSError?
        let filePath = NSBundle.mainBundle().pathForResource(nombreArchivoAsociado, ofType:"nicgeb")
        if let path = filePath {
//            if filemgr.removeItemAtPath(path, error: &error) {
//                println("Remove successful")
//            } else {
//                println("Remove failed: \(error!.localizedDescription)")
//            }
            
            filemgr.createFileAtPath(path, contents: nil, attributes: nil)
            listaNombres().writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
    
    func listaNombres() -> String {
        var stringCompleto = ""
        for i in (0...arrayContactos.count - 1) {
            if !arrayContactos[i].celdaLetra && i < arrayContactos.count - 2 {
                stringCompleto += (arrayContactos[i].nombreCompletoParaArchivo + "\r\n")
            }
            else if !arrayContactos[i].celdaLetra {
                stringCompleto += (arrayContactos[i].nombreCompletoParaArchivo + "\r")
            }
        }
        return stringCompleto
    }
}