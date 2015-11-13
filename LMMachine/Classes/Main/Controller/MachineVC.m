//
//  MachineVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "MachineVC.h"
#import <MAMapKit/MAMapKit.h>
#import "LCProgressHUD.h"

@interface MachineVC () <MAMapViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    MAMapView *_mapView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabelViewTopC;

@end

@implementation MachineVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64.0f, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 2 / 3)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"考勤机位置";
    
    [self setupMainUI];
}

- (void)setupMainUI {
    
    self.tabelViewTopC.constant = CGRectGetWidth(self.view.bounds) * 2 / 3 + 64;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightBtnClicked)];
}

- (void)rightBtnClicked {
    
    
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
