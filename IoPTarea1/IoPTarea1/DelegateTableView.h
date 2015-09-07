//
//  DelegateTableView.h
//  IoPTarea1
//
//  Created by Nicolás Gebauer on 22-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DelegateTableView : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UIViewController *referenciaAlControlador;
@property (strong, nonatomic) NSString *nombreCelda;
@property (assign, nonatomic) NSInteger numeroCelda;
@property (strong, nonatomic) NSArray *listaAlumnos;

@end