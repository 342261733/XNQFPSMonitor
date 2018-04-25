//
//  ViewController.m
//  MonitorDemo
//
//  Created by semyon on 2018/4/23.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import "ViewController.h"
#import "XNQMonitorManager.h"
#import "XNQFPSMonitor.h"

@interface ViewController () {
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [XNQMonitorManager start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
