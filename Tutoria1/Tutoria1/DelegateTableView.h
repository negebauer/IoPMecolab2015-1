//
//  DelegateTableView.h
//  Tutoria1
//
//  Created by Nicolás Gebauer on 20-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DelegateTableView : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UIViewController* referenciaViewController;
@property (assign, nonatomic) NSInteger numeroCelda;

@end
