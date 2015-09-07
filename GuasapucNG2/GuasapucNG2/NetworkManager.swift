//
//  NetworkManager.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI
import CoreData
import UIKit

class NetworkManager: NSObject {
    static func getIFAddresses() -> [String] {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }}}}}
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
    static func getLocalAddress() -> String {
        let addresses = self.getIFAddresses()
        if addresses.count == 0 { NSLog("ERROR obteniendo id"); return "0"}
        else {
            for a in addresses {
                let b = a.componentsSeparatedByString(".")
                if b[0] == "192" && b[1] == "168" {
                    return a
                }
            }
            if addresses.count == 2 { return addresses[1] }
            return addresses[0]
        }
    }
}
