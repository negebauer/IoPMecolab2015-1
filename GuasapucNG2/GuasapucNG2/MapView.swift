//
//  LocationView.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 22-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class MapView: UIViewController, CLLocationManagerDelegate, NSStreamDelegate, TcpDelegate {
    @IBOutlet weak var Map: MKMapView!
    weak var chatManager: ChatManager!
    var diccionarioNumeroAnnotation = Dictionary<String, MKAnnotation>()
    let manager = CLLocationManager()
    var servers = [TcpListener]()
    var clients = [Client]()
    var lastSentLocation = ""
    
    @IBAction func ShowMyLocation(sender: AnyObject) {
        switch Map.userTrackingMode {
        case .None:
            Map.setUserTrackingMode(.Follow, animated: true)
            return
        case .Follow:
            Map.setUserTrackingMode(.FollowWithHeading, animated: true)
            return
        case .FollowWithHeading:
            Map.setUserTrackingMode(.None, animated: true)
            return
        }
    }
    
    @IBAction func RefreshLocations(sender: AnyObject) {
        destruirServidores()
        destruirClientes()
        crearServidor()
        crearClientes()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        enviarLocalizacionAContactos()
    }
    
    func enviarLocalizacionAContactos() {
        let loc = generarJSONLocalizacion()
        if clients.count == 0 || lastSentLocation == loc { return }
        NSLog("Enviando localizacion: %@", loc)
        var clientsDelete = [Client]()
        for client in clients { if client.shouldKill { clientsDelete.append(client) } }
        for client in clientsDelete { client.kill(); clients.removeAtIndex(clients.indexOf(client)!) }
        if (loc == lastSentLocation) { return }
        for client in clients { if client.opened { client.sendLocation(loc) } }
        lastSentLocation = loc
    }
    
    func generarJSONLocalizacion() -> String {
        //NSLog("La verdadera localizacion es lan: \(manager.location.coordinate.latitude) lng: \(manager.location.coordinate.longitude)")
        let latitude: Double = manager.location!.coordinate.latitude 
        let longitude: Double = manager.location!.coordinate.longitude 
        let obj: [String: AnyObject?] = [
            "lat": latitude,
            "lng": longitude,
            "phone": User.currentUser?.number]
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(obj as! [String: AnyObject], options: NSJSONWritingOptions.init(rawValue: 0))
        let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        return jsonString
    }
    
    func receivedNewLocationUpdate(jsonString: String!) {
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
        let jsonDictionary = jsonSwift as! Dictionary<String,NSObject>
        NSLog("Recibiendo localizacion: "+String(stringInterpolationSegment: jsonDictionary))
        let lat = jsonDictionary["lat"] as! Double
        let lng = jsonDictionary["lng"] as! Double
        let phone = jsonDictionary["phone"] as! String
        updateLocationForNumber(phone, lat: lat, lng: lng)
    }
    
    func updateLocationForNumber(number:String, lat:Double, lng:Double) {
        if !(diccionarioNumeroAnnotation.keys.contains(number)) {
            let annotation = MKPointAnnotation()
            annotation.title = chatManager.getNameForContactNumber(number)
            annotation.subtitle = number
            diccionarioNumeroAnnotation[number] = annotation as MKAnnotation
            Map.addAnnotation(annotation)
        }
        //let oldCoordinates = diccionarioNumeroAnnotation[number]!.coordinate
        let newCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        print("newCoordinates lat: \(newCoordinates.latitude) lng: \(newCoordinates.longitude)")
        //if oldCoordinates.latitude == newCoordinates.latitude && oldCoordinates.longitude == newCoordinates.longitude { return }
        let pointAnnotation = diccionarioNumeroAnnotation[number] as! MKPointAnnotation
        pointAnnotation.coordinate = newCoordinates
        diccionarioNumeroAnnotation[number] = pointAnnotation as MKAnnotation
    }
    
    func crearServidor() {
        let server = TcpListener()
        server.configure()
        server.delegate = self
        //let port = servers.count == 0 ? server.port : servers[0].port
        servers.append(server)
        let request = CreateRequest.shareLocationWithUsers(String(server.port), users: ["56961567267", "56968799501", "56983362592", "56962448489", "56989060056", "56981362982"])
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("ERROR compartiendo ubicación: \(error)")
                return
            }

            if self.servers.count == 1 { self.crearClientes() }
        }
        task.resume()
    }
    
    func crearClientes() {
        lastSentLocation == ""
        let request = CreateRequest.sharedLocations()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("ERROR compartiendo ubicación: \(error)")
                return
            }
            
            let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    if let jsonDictionary = jsonMensaje as? Dictionary<String, NSObject> {
                        let ip = jsonDictionary["ip"] as! String
                        let port = jsonDictionary["port"] as! String
                        let client = Client()
                        self.clients.append(client)
                        self.lastSentLocation = "" //Para forzar enviar ubicacion a nuevos
                        
                        //BORRAR
                        NSLog("Intentando conectar client a ip: \(ip) port: \(UInt32(Int(port)!))")
                        //if ip == Common.getLocalAddress() { continue }
                        client.connectToServerSocket(ip, port: UInt32(Int(port)!))
                    }}}
            // if self.clients.count == 0 { Common.crearAlerta("Error clientes", mensaje: "No pude crear ningun cliente", view: self) }
        }
        task.resume()
    }
    
    func destruirServidores() {
        for s in servers { s.kill() }
        servers = [TcpListener]()
    }
    
    func destruirClientes() {
        for c in clients { c.kill() }
        clients = [Client]()
    }

    @IBAction func SetSharingLocation(sender: AnyObject) {
        let button = sender as! UISwitch
        switch button.on {
        case true:
            NSLog("Boton prendido")
            destruirClientes()
            destruirServidores()
            crearServidor()
            manager.startUpdatingLocation()
            return
        case false:
            NSLog("Boton apagado")
            destruirServidores()
            destruirClientes()
            manager.stopUpdatingLocation()
            Map.removeAnnotations(Map.annotations)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.startUpdatingLocation()
        
        NSLog("ip: %@", IPGetter.getLocalAddress())
        NSLog("Todas las ip: " + String(stringInterpolationSegment: IPGetter.getIFAddresses()))
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        Map.showsUserLocation = true
    }
}