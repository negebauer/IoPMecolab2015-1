//
//  DelegateTableView.m
//  IoPTarea1
//
//  Created by Nicolás Gebauer on 22-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import "DelegateTableView.h"
#import "CeldaLetra.h"
#import "CeldaNombre.h"

@implementation DelegateTableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listaAlumnos count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger indexLista = indexPath.row;
    NSString *nombre = [_listaAlumnos objectAtIndex:indexLista];
    if ([nombre length] == 1){
        CeldaLetra *celda = [tableView dequeueReusableCellWithIdentifier:@"IdentificadorCeldaLetra"];
        celda.LabelLetra.text = nombre; //[NSString stringWithFormat:@" %@",nombre];
        [celda setBackgroundColor:[UIColor grayColor]];
        celda.LabelLetra.textColor = [UIColor blackColor];
        return celda;
    }
    else{
        CeldaNombre *celda = [tableView dequeueReusableCellWithIdentifier:@"IdentificadorCeldaNombre"];
        celda.LabelNombre.text = nombre;
        [celda setBackgroundColor:[UIColor whiteColor]];
        return celda;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *nombre = [_listaAlumnos objectAtIndex:indexPath.row];
    if ([nombre length] == 1){
        
    }
    else{
        _numeroCelda = indexPath.row;
        [_referenciaAlControlador performSegueWithIdentifier:@"TransicionMostrarInformacionDetallada" sender:_referenciaAlControlador];
  
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger indexLista = indexPath.row;
    NSString *nombre = [_listaAlumnos objectAtIndex:indexLista];
    if ([nombre length] == 1){
        return 15;
    }
    else{
        return 40;
    }}

@end