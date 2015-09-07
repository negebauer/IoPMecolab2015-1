//
//  POSTyGet.swift
//  RepoSnippets
//
//  Created by Nicolás Gebauer on 27-04-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation

///POST

//----- Codigo sacado de http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
//Para hacer un POST request asincrono
//Modificado para ser compatible con el formato de guasapuc
let request = NSMutableURLRequest(URL: NSURL(string: StringURL)!)
request.HTTPMethod = "POST"
request.addValue("Token token=tokenID", forHTTPHeaderField: "Authorization")
let postString = "key=value&key=value"
request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
    data, response, error in
    
    if error != nil {
        println("error=\(error)")
        return
    }
    
    println("response = \(response)")
    
    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
    println("responseString = \(responseString)")
}
task.resume()
//----- Fin

///GET

let request = NSMutableURLRequest(URL: NSURL(string: ProjectConstants.usersURL)!)
request.HTTPMethod = "GET"
request.addValue(ProjectConstants.tokenFormat, forHTTPHeaderField: "Authorization")
let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
    data, response, error in
    
    if error != nil {
        println("error=\(error)")
        return
    }
    
    println("response = \(response)")
    
    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
    println("responseString = \(responseString)")
}
task.resume()
