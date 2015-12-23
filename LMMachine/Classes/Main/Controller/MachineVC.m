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
#import "LCTool.h"
#import "AFNetworking.h"
#import "CLProgressHUD+LC.h"
#import "JGProgressHUD+LC.h"
#import "GlobalData.h"

#define MAP_VIEW_WIDTH  CGRectGetWidth(self.view.bounds)
#define MAP_VIEW_HEIGHT (320.0f * (SCREEN_H - 64.0f) / 603.0f)

// x lng
// y lag
typedef void(^ConvertBlock)(BOOL success, NSString *x, NSString *y);

@interface MachineVC () <MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopC;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *backLocationBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, strong) CLProgressHUD *loadingHUD;
/**
 *  是否定位完成 默认正在定位
 */
@property (nonatomic, assign, getter = isLocationed) BOOL locationed;

@property (nonatomic, assign) BOOL        isFirstLocated;

@property (nonatomic, strong) NSArray     *dataArray;

@property (nonatomic, copy  ) NSString    *locationCN;

@property (nonatomic, strong) UIImageView *redWaterView;
@property (nonatomic, strong) UIButton    *locationBtn;
@property (nonatomic, strong) UIImage     *imageLocated;
@property (nonatomic, strong) UIImage     *imageNotLocate;

@end

@implementation MachineVC

#pragma mark - Utility

- (void)clearMapView {
    
    if (self.mapView) {
        
        self.mapView.showsUserLocation = NO;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        self.mapView.delegate = nil;
    }
}

- (void)clearSearch {
    
    if (self.search) self.search.delegate = nil;
}

#pragma mark - Main Code

- (MAMapView *)mapView {
    
    if (!_mapView) {
        
        CGFloat mapViewW = MAP_VIEW_WIDTH;
        CGFloat mapViewH = MAP_VIEW_HEIGHT;
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64.0f, mapViewW, mapViewH)];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.logoCenter = CGPointMake(CGRectGetWidth(_mapView.bounds) - 36.0f, 310.0f);
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        [_mapView setZoomLevel:16.5f animated:YES];
        
        MAUserLocationRepresentation *userLR = [[MAUserLocationRepresentation alloc] init];
        userLR.showsAccuracyRing = NO;
        [_mapView updateUserLocationRepresentation:userLR];
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
        
        CGFloat mapViewW = MAP_VIEW_WIDTH;
        CGFloat mapViewH = MAP_VIEW_HEIGHT;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"myRedPin"];
        iconView.frame = CGRectMake(0, 0, 44.0f, 72.0f);
        iconView.center = CGPointMake(mapViewW * 0.5f, mapViewH * 0.5f + 64.0f);
        _iconView = iconView;
    }
    
    return _iconView;
}

- (void)initRedWaterView {
    
    UIImage *image = [UIImage imageNamed:@"wateRedBlank"];
    self.redWaterView = [[UIImageView alloc] initWithImage:image];
    
    self.redWaterView.frame = CGRectMake(self.view.bounds.size.width * 0.5f - image.size.width * 0.5f,
                                         MAP_VIEW_HEIGHT * 0.5f - image.size.height + 64.0f,
                                         image.size.width,
                                         image.size.height);
    
    self.redWaterView.center = CGPointMake(CGRectGetWidth(self.view.bounds) * 0.5f,
                                           MAP_VIEW_HEIGHT * 0.5f + 64.0f - CGRectGetHeight(self.redWaterView.bounds) * 0.5f);
    
    [self.view addSubview:self.redWaterView];
}

- (void)initLocationButton {
    
    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
    
    self.locationBtn = [[UIButton alloc] init];
    self.locationBtn.frame = CGRectMake(MAP_VIEW_WIDTH * 0.07f,
                                        MAP_VIEW_HEIGHT * 0.8f + 64.0f,
                                        40.0f,
                                        40.0f);
    self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.locationBtn.backgroundColor = [UIColor colorWithRed:234.0f / 255.0f
                                                       green:234.0f / 255.0f
                                                        blue:234.0f / 255.0f
                                                       alpha:1.0f];
    self.locationBtn.layer.cornerRadius = 3.0f;
    [self.locationBtn addTarget:self action:@selector(backLocationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    
    [self.view addSubview:self.locationBtn];
}

- (void)redWaterAnimimate {
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGPoint center = self.redWaterView.center;
        center.y -= 20;
        [self.redWaterView setCenter:center];
        
    } completion:nil];
    
    [UIView animateWithDuration:0.45f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGPoint center = self.redWaterView.center;
        center.y += 20;
        [self.redWaterView setCenter:center];
        
    } completion:nil];
}

- (NSMutableArray *)locationArray {
    
    if (!_locationArray) {
        
        _locationArray = [[NSMutableArray alloc] init];
    }
    return _locationArray;
}

- (NSArray *)dataArray {
    
    return @[[NSString stringWithFormat:@"%@", self.locationCN],
             [NSString stringWithFormat:@"%ld", self.distance]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!self.mapView) {
        
        [self.view addSubview:self.mapView];
        
//        [self.view bringSubviewToFront:self.backLocationBtn];
    }
    
//    if (!self.iconView) {
//        
//        [self.view addSubview:self.iconView];
//    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
    
//    [self.view bringSubviewToFront:self.backLocationBtn];
//    
//    [self.view addSubview:self.iconView];
    
    [self setupMainUI];
}

- (void)setupMainUI {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBtnClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightBtnClicked)];
    
    self.tableViewTopC.constant = MAP_VIEW_HEIGHT + 64.0f;
    
    [self initRedWaterView];
    
    [self initLocationButton];
}

/**
 *  back to location position
 */
- (void)backLocationBtnClicked {
    
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow) {
        
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
        
    } else {
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}

- (void)leftBtnClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearMapView];
    
    [self clearSearch];
}

- (void)rightBtnClicked {
    
    if (!CLLocationCoordinate2DIsValid(self.centerCoordinate) || !self.isLocationed) {
        
        return [LCTool showOneAlertViewWithTitle:@"请等待定位完成。" message:nil delegate:nil];
    }
    
    self.loadingHUD = [CLProgressHUD showLoadingText:@"正在上传中..." inView:self.view];
    
    
    LCLog(@"%@ %@ (%f, %f)", [GlobalData sharedData].companyKey, self.machineId, self.centerCoordinate.longitude, self.centerCoordinate.latitude);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSDictionary *params = @{@"companyKey"  : [GlobalData sharedData].companyKey,
                             @"machineId"   : self.machineId,
                             @"pos"         : [NSString stringWithFormat:@"%f,%f", self.centerCoordinate.longitude, self.centerCoordinate.latitude],
                             @"machineAddr" : self.locationLabel.text};
    
    [manager GET:COORDINATE parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        LCLog(@"%@", responseObject);
        
        [self.loadingHUD dismissWithAnimation:YES];
        
        if ([responseObject[@"status"][@"code"] intValue]) {
            
            [LCTool showOneAlertViewWithTitle:responseObject[@"status"][@"msg"] message:nil delegate:nil];
            
        } else {
            
            [JGProgressHUD showSuccessHUD:@"上传成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [self.loadingHUD dismissWithAnimation:YES];
        
        [JGProgressHUD showFailureHUD:@"上传失败"];
    }];
}

/**
 *  地图转换体系转换 `GPS 设备` -> `百度坐标体系`
 *  BDNMB
 *
 *  @param coordinate 坐标
 *  @param success    成功 Block
 */
- (void)convertCoordinate:(CLLocationCoordinate2D)coordinate success:(ConvertBlock)success {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    self.loadingHUD = [CLProgressHUD showLoadingText:@"正在上传中..." inView:self.view];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geoconv/v1/?coords=%f,%f&from=3&ak=Kibmiw44rTjERp8Gsfhfyw5h&output=json",
                        coordinate.longitude,
                        coordinate.latitude];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        LCLog(@"%@", responseObject);
        
        if (![responseObject[@"status"] intValue] && [responseObject[@"result"] count] > 0) {
            
            success(YES, responseObject[@"result"][0][@"x"], responseObject[@"result"][0][@"y"]);
            
        } else {
            
            [self.loadingHUD dismissWithAnimation:YES];
            
            [LCTool showOneAlertViewWithTitle:@"上传失败" message:@"百度地图坐标转换接口失效，请联系揽梦科技。（http://www.lanmengkeji.com）" delegate:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [self.loadingHUD dismissWithAnimation:YES];
        
        [LCTool showOneAlertViewWithTitle:@"上传失败" message:@"百度地图坐标转换接口失效，请联系揽梦科技（http://www.lanmengkeji.com）。" delegate:nil];
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"MachineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.accessoryType =
    indexPath.section == 1
    ? UITableViewCellAccessoryDisclosureIndicator
    : UITableViewCellAccessoryNone;
    
    cell.textLabel.text = [self noNullString:self.dataArray[indexPath.section]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"当前位置";
        
    } else if (section == 1) {
        
        return @"设置考勤机有效距离";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        
    }
}

#pragma mark - MAMapView 代理

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    self.locationed = NO;
//    self.locationLabel.text = @"定位中...";
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    self.centerCoordinate = mapView.centerCoordinate;
    
//    LCLog(@"(%f, %f)", mapView.centerCoordinate.longitude, mapView.centerCoordinate.latitude);
//
//    [self.locationArray removeAllObjects];
//
//    [self nearWithCoordinate:self.centerCoordinate];
    
    [self reGoecodeSearchWithCoordinate:self.centerCoordinate];
    
    [self redWaterAnimimate];
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated {
    
    if (mode == MAUserTrackingModeNone) {
        
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
        
    } else {
        
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
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
        
        self.locationed = YES;
        self.locationCN = response.regeocode.formattedAddress;
        self.locationLabel.text = [self noNullString:self.locationCN];
        
        [self.tableView reloadData];
        
//        NSString *result = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
//                            response.regeocode.formattedAddress,
//                            response.regeocode.addressComponent,
//                            response.regeocode.roads,
//                            response.regeocode.roadinters,
//                            response.regeocode.pois];
//        LCLog(@"\n%@", result);
        
    }
}

- (NSString *)noNullString:(NSString *)string {
    
    if (string.length > 0 && ![string isEqualToString:@"(null)"]) {
        
        return string;
        
    } else {
        
        return @"";
    }
}

@end