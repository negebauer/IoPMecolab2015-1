//
//  ViewController.swift
//  Test
//
//  Created by Jose Benedetto on 5/27/15.
//  Copyright (c) 2015 Jose Benedetto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSStreamDelegate {
    @IBOutlet weak var textMessage: UITextField!
    
    private var outputStream : NSOutputStream?;
    private var inputStream : NSInputStream?;
    
    private var server : TcpListener?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnServerUp(sender: AnyObject) {
        if (server == nil) {
            server = TcpListener()
        }
        
        if let tcp = server {
            tcp.configure();
        }
        
    }
    
    func SocketReadCallback(CFSocket!, CFSocketCallBackType, CFData!, UnsafePointer<Void>, UnsafeMutablePointer<Void>) {
    
    }

    
    @IBAction func btnConnectUp(sender: AnyObject) {
        let host : CFString = "localhost";
        var readStream : Unmanaged<CFReadStream>? = nil;
        var writeStream : Unmanaged<CFWriteStream>? = nil;
        let tcp = server!;
        
        CFStreamCreatePairWithSocketToHost(nil, host, UInt32(tcp.port), &readStream, &writeStream);
        
        inputStream = readStream!.takeRetainedValue();
        outputStream = writeStream!.takeRetainedValue();
        
        if let inStream = inputStream, let outStream = outputStream {
            inStream.delegate = self;
            outStream.delegate = self;
            
            inStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            
            inStream.open()
            outStream.open()
        }
        
    }
    
    
    @IBAction func btnSendMessageUp(sender: AnyObject) {
        let message = textMessage.text;
        let messageData = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!;
        
        outputStream!.write(UnsafePointer<UInt8>(messageData.bytes), maxLength: messageData.length);
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        
    }
    
}

