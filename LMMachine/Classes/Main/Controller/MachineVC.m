//
//  MachineVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "MachineVC.h"
#import <MAMapKit/MAMapKit.h>

@interface MachineVC () <MAMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabelViewTopC;

@end

@implementation MachineVC

- (MAMapView *)mapView {
    
    if (!_mapView) {
        
        CGFloat mapViewW = CGRectGetWidth(self.view.bounds);
        CGFloat mapViewH = mapViewW * 2 / 3;
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64.0f, mapViewW, mapViewH)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        [_mapView setZoomLevel:16.1f animated:YES];
        
//        _mapView.centerCoordinate
    }
    
    return _mapView;
}

- (UIImageView *)iconView {
    
    if (!_iconView) {
        
        CGFloat mapViewW = CGRectGetWidth(self.view.bounds);
        CGFloat mapViewH = mapViewW * 2 / 3;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"myRedPin"];
        iconView.frame = CGRectMake(0, 0, 44.0f, 72.0f);
        iconView.center = CGPointMake(mapViewW * 0.5f, mapViewH * 0.5f + 64.0f);
        _iconView = iconView;
    }
    
    return _iconView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!self.mapView) {
        
        [self.view addSubview:self.mapView];
    }
    
    if (!self.iconView) {
        
        [self.view addSubview:self.iconView];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"考勤机位置";
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.iconView];
    
    [self setupMainUI];
}

- (void)setupMainUI {
    
    self.tabelViewTopC.constant = CGRectGetWidth(self.view.bounds) * 2 / 3;
    
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

#pragma mark - MAMapView 代理

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    LCLog(@"(%f, %f)", mapView.centerCoordinate.longitude, mapView.centerCoordinate.latitude);
}

@end