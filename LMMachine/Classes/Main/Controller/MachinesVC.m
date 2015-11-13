//
//  MachinesVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "MachinesVC.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "GlobalData.h"
#import "JGProgressHUD+LC.h"

@interface MachinesVC ()

@end

@implementation MachinesVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setMainUI];
    
    [self loadRequest];
}

- (void)setMainUI {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadRequest)];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadRequest {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSDictionary *params = @{@"companyKey" : [GlobalData sharedData].companyKey};
    
    [manager GET:MACHINE parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        LCLog(@"%@", responseObject);
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [self.tableView.mj_header endRefreshing];
        
        [JGProgressHUD showFailureHUD:@"加载失败"];
    }];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MachinesCell"];
    
    cell.textLabel.text = @"旗舰考勤机";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

@end
