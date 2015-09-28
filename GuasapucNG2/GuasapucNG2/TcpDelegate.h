//
//  TcpDelegate.h
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 08-06-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TcpDelegate <NSObject>

- (void)receivedNewLocationUpdate: (NSString*)locationString;
- (void)crearServidor;

@end