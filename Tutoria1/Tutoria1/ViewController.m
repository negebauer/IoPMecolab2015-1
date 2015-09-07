//
//  ViewController.m
//  Tutoria1
//
//  Created by Nicolás Gebauer on 20-03-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

#import "ViewController.h"
#import "DelegateTableView.h"
#import "DetailsViewController.h"

@interface ViewController ()

@property (nonatomic, strong) DelegateTableView* tabla;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tabla = [[DelegateTableView alloc]init];
    _tabla.referenciaViewController = self;
    _TablaTutoria.delegate = _tabla;
    _TablaTutoria.dataSource = _tabla;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailsViewController *controller = segue.destinationViewController;
    controller.stringPersonalizado = [NSString stringWithFormat:@"La celda apretada es la: %ld", _tabla.numeroCelda ];
}

@end