//
//  ViewController.m
//  IoPTarea1
//
//  Created by Nicolás Gebauer on 22-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import "ViewController.h"
#import "DelegateTableView.h"
#import "DetailsViewController.h"

@interface ViewController ()

@property (strong, nonatomic) DelegateTableView *CreatorTablaNombres;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _CreatorTablaNombres = [[DelegateTableView alloc] init];
    _CreatorTablaNombres.referenciaAlControlador = self;
    _CreatorTablaNombres.numeroCelda = 0;
    
    //Cargar la lista de alumnos usando código de http://stackoverflow.com/questions/3295527/cocoa-touch-loading-a-text-file-into-an-array
    //pull the content from the file into memory
    NSData* data = [NSData dataWithContentsOfFile:@"/Users/Nico/Documents/Xcode/IoPTarea1/IoPTarea1/ListaAlumnos.txt"];
    //convert the bytes from the file into a string
    NSString* string = [[NSString alloc] initWithBytes:[data bytes]
                                                 length:[data length]
                                               encoding:NSUTF8StringEncoding];
    
    //split the string around newline characters to create an array
    NSString* delimiter = @"\n";
    NSArray* items = [string componentsSeparatedByString:delimiter];
    
    //Revisar lista de alumnos para crear nueva lista con letras solitarias para hacer celdas pequeñas
    NSMutableArray *listaCompleta = [NSMutableArray arrayWithObjects:nil];
    NSString *ultimaLetraVista = @"";
    for (NSString *string in items) {
        
        NSString *primeraLetraNuevoNombre = [string substringWithRange: NSMakeRange (0, 1)];
        primeraLetraNuevoNombre = [primeraLetraNuevoNombre capitalizedString];
        if ([primeraLetraNuevoNombre isEqualToString:@"Á"] ) {
            primeraLetraNuevoNombre = @"A";
        }
        else if ([primeraLetraNuevoNombre isEqualToString:@"É"] ) {
            primeraLetraNuevoNombre = @"E";
        }
        else if ([primeraLetraNuevoNombre isEqualToString:@"Í"] ) {
            primeraLetraNuevoNombre = @"I";
        }
        else if ([primeraLetraNuevoNombre isEqualToString:@"Ó"] ) {
            primeraLetraNuevoNombre = @"O";
        }
        else if ([primeraLetraNuevoNombre isEqualToString:@"Ú"] ) {
            primeraLetraNuevoNombre = @"U";
        }
        
        NSString *string2 = [string capitalizedString];
        
        if (![primeraLetraNuevoNombre isEqualToString:ultimaLetraVista]) {
            ultimaLetraVista = [string substringWithRange: NSMakeRange (0, 1)];
            [listaCompleta addObject:ultimaLetraVista];
        }
        [listaCompleta addObject:string2];
    }
    
    _CreatorTablaNombres.listaAlumnos = listaCompleta;
    _TablaEstudiantes.dataSource = _CreatorTablaNombres;
    _TablaEstudiantes.delegate = _CreatorTablaNombres;
//    _TablaEstudiantes.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailsViewController *controllerDetalles = segue.destinationViewController;
    controllerDetalles.stringDetalles = [_CreatorTablaNombres.listaAlumnos objectAtIndex:_CreatorTablaNombres.numeroCelda];
}

@end
