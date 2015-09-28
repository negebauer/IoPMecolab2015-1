//
//  ClientSocket.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 02-06-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class Client: NSObject, NSStreamDelegate {
    private var outputStream : NSOutputStream?;
    private var inputStream : NSInputStream?;
    var opened = false
    var shouldKill = false
    var ipConexion = ""
    var portConexion = 0
    
    func connectToServerSocket(ip:String, port:UInt32) {
        ipConexion = ip
        portConexion = Int(port)
        //let host: CFString = ip;
        //var readStream : Unmanaged<CFReadStream>? = nil;
        //var writeStream : Unmanaged<CFWriteStream>? = nil;
        
        NSStream.getStreamsToHostWithName(ip, port: Int(port), inputStream: &inputStream, outputStream: &outputStream)
        //CFStreamCreatePairWithSocketToHost(nil, host, port, &readStream, &writeStream);
        
        //inputStream = readStream!.takeRetainedValue();
        //outputStream = writeStream!.takeRetainedValue();
        
        if inputStream != nil && outputStream != nil {
            inputStream!.delegate = self;
            outputStream!.delegate = self;
            
            inputStream!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            outputStream!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
            inputStream!.open()
            outputStream!.open()
            NSLog("Cliente intento abrir streams")
        }
    }
    
    ///Send jsonString { "lan": , "lng": , "phone": } to the outputStream
    func sendLocation(jsonString:String) {
        let messageData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!;
        outputStream!.write(UnsafePointer<UInt8>(messageData.bytes), maxLength: messageData.length);
        NSLog("Envie la ubicacion: %@ a la conexion ip: %@ port: %i", jsonString, ipConexion, portConexion)
    }
    
    func SocketReadCallback(_: CFSocket!, _: CFSocketCallBackType, _: CFData!, _: UnsafePointer<Void>, _: UnsafeMutablePointer<Void>) {
        
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if aStream === inputStream {
            switch eventCode {
            case NSStreamEvent.ErrorOccurred:
                print("input: ErrorOccurred: \(aStream.streamError?.description)" + "ip: "+ipConexion+" port: \(portConexion)")
            case NSStreamEvent.OpenCompleted:
                print("input: OpenCompleted")
            case NSStreamEvent.HasBytesAvailable:
                print("input: HasBytesAvailable")
                
                // Here you can `read()` from `inputStream`
                
            default:
                NSLog("default input")
                break
            }
        }
        else if aStream === outputStream {
            switch eventCode {
            case NSStreamEvent.ErrorOccurred:
                print("input: ErrorOccurred: \(aStream.streamError?.description)" + "ip: "+ipConexion+" port: \(portConexion)")
                shouldKill = true
            case NSStreamEvent.OpenCompleted:
                print("output: OpenCompleted")
                opened = true
            case NSStreamEvent.HasSpaceAvailable:
                print("output: HasSpaceAvailable")
                
                // Here you can write() to `outputStream`
                
            default:
                NSLog("default output")
                break
            }
        }
    }
    
    func kill() {
        inputStream?.close()
        outputStream?.close()
    }
}