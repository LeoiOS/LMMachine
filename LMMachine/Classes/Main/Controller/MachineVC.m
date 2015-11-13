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

@interface MachineVC () <MAMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabelViewTopC;

@end

@implementation MachineVC

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64.0f, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 2 / 3)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass= NO;
    _mapView.showsScale = NO;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapView setZoomLevel:16.1f animated:YES];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.998246, 116.418153);
    
    [_mapView addAnnotation:pointAnnotation];
    
    [self.view addSubview:_mapView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"考勤机位置";
    
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

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (updatingLocation) {
        
        // 取出当前位置的坐标
        NSLog(@"latitude : %f, longitude: %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES; // 设置气泡可以弹出，默认为 NO
        annotationView.draggable = YES;
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

@end
