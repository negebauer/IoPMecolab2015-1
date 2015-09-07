//
//  DelegateTableView.m
//  Tutoria1
//
//  Created by Nicolás Gebauer on 20-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import "DelegateTableView.h"
#import "Celda.h"

@implementation DelegateTableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Celda* celda = [tableView dequeueReusableCellWithIdentifier:@"IdentificadorTabla"];
    
    celda.labelVariable.text = [NSString stringWithFormat:@"Etiqueta numero %ld", indexPath.row];
    
    return celda;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _numeroCelda = indexPath.row;
    [_referenciaViewController performSegueWithIdentifier:@"Transicion1" sender:_referenciaViewController];
}


@end
