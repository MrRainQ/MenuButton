//
//  ViewController.m
//  MenuButton
//
//  Created by sen5labs on 14-8-7.
//  Copyright (c) 2014年 sen5labs. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    MyView *my = [[MyView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    [self.view addSubview:my];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
