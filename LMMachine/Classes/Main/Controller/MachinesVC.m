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
#import "MJExtension.h"
#import "GlobalData.h"
#import "JGProgressHUD+LC.h"
#import "MachineModel.h"
#import "LCTool.h"
#import "MachineVC.h"

@interface MachinesVC () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *machines;

@end

@implementation MachinesVC

- (NSArray *)machines {
    
    if (!_machines) {
        _machines = [[NSArray alloc] init];
    }
    return _machines;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setMainUI];
}

- (void)setMainUI {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"帮助"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBtnClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(rightBtnClicked)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadRequest)];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)leftBtnClicked {
    
    NSString *message = [NSString stringWithFormat:@"%@\n当前版本为内测版本，可能存在一些 Bug。如有遇到，请摇一摇进行反馈！谢谢！\nV%@(beta) build%@\n© 北京揽梦科技有限公司",
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [LCTool showOneAlertViewWithTitle:@"帮助" message:message delegate:nil];
}

- (void)rightBtnClicked {
    
    [LCTool showTwoAlertViewWithTitle:@"你确定要注销吗？" message:nil delegate:self];
}

- (void)loadRequest {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSDictionary *params = @{@"companyKey" : [GlobalData sharedData].companyKey};
    
    [manager GET:MACHINE parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        LCLog(@"%@", responseObject);
        
        [self.tableView.mj_header endRefreshing];
        
        if ([responseObject[@"status"][@"code"] intValue]) {
            
            [LCTool showOneAlertViewWithTitle:responseObject[@"status"][@"msg"] message:nil delegate:nil];
            
        } else {
            
            [JGProgressHUD showSuccessHUD:@"加载成功"];
            
            self.machines = [MachineModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [self.tableView.mj_header endRefreshing];
        
        [JGProgressHUD showFailureHUD:@"加载失败"];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Machines2MachineSegue"]) {
        
        NSString *machineId = [(MachineModel *)sender machineId];
        MachineVC *machineVC = segue.destinationViewController;
        machineVC.title = machineId.length > 0 ? machineId : @"无 ID 考勤机";
        machineVC.machineId = machineId;
        machineVC.distance = (long)[[(MachineModel *)sender machineDistance] intValue];
    }
}

#pragma mark - UIAlertView 代理

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
    }
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.machines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MachinesCell"];
    
    NSString *machineId = [self.machines[indexPath.row] machineId];
    cell.textLabel.text = machineId.length > 0 ? machineId : @"无 ID 考勤机";
    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"Machines2MachineSegue" sender:self.machines[indexPath.row]];
}

@end
