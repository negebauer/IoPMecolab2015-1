//
//  TcpListener.h
//  Test
//
//  Created by Jose Benedetto on 5/27/15.
//  Copyright (c) 2015 Jose Benedetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TcpListener : NSObject<NSStreamDelegate>
@property (assign, nonatomic) UInt32 port;

- (void)configure;

@end
