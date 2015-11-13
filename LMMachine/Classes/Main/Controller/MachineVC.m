//
//  MachineVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "MachineVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MachineVC () <MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabelViewTopC;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) NSMutableArray *locationArray;

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
    }
    
    return _mapView;
}

- (AMapSearchAPI *)search {
    
    if (!_search) {
        
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    
    return _search;
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

- (NSMutableArray *)locationArray {
    
    if (!_locationArray) {
        
        _locationArray = [[NSMutableArray alloc] init];
    }
    return _locationArray;
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
    
    self.search;
    
    self.tabelViewTopC.constant = CGRectGetWidth(self.view.bounds) * 2 / 3;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightBtnClicked)];
}

- (void)rightBtnClicked {
    
    
}

- (void)nearWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    AMapNearbySearchRequest *request = [[AMapNearbySearchRequest alloc] init];
    request.center = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.radius = 10000;
    request.timeRange = 10000;
    request.searchType = AMapNearbySearchTypeDriving;   // 驾车距离，AMapNearbySearchTypeLiner表示直线距离
    
    [self.search AMapNearbySearch:request];
}

- (void)reGoecodeSearchWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
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
    
    self.centerCoordinate = mapView.centerCoordinate;
    
    LCLog(@"(%f, %f)", mapView.centerCoordinate.longitude, mapView.centerCoordinate.latitude);
    
    [self.locationArray removeAllObjects];
    
//    [self nearWithCoordinate:self.centerCoordinate];
    
    [self reGoecodeSearchWithCoordinate:self.centerCoordinate];
}

#pragma mark - AMapSearch 代理

- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response {
    
    if (!response.infos.count) return;
    
    for (AMapNearbyUserInfo *info in response.infos) {
        
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        anno.title = info.userID;
        anno.subtitle = [[NSDate dateWithTimeIntervalSince1970:info.updatetime] descriptionWithLocale:[NSLocale currentLocale]];
        anno.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
        
        [self reGoecodeSearchWithCoordinate:anno.coordinate];
        
//        [_mapView addAnnotation:anno];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if (response.regeocode != nil) {
        
//        NSString *result = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
//                            response.regeocode.formattedAddress,
//                            response.regeocode.addressComponent,
//                            response.regeocode.roads,
//                            response.regeocode.roadinters,
//                            response.regeocode.pois];
//        LCLog(@"\n%@", result);
    }
}

@end