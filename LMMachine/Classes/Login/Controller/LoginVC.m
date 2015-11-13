//
//  LoginVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LoginVC.h"
#import "AFNetworking.h"
#import "LCProgressHUD.h"
#import "LCTool.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation LoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(rightBtnClicked)];
}

- (void)rightBtnClicked {
    
    if (self.userNameField.text.length == 0 || self.pwdField.text.length == 0) {
        
        [LCTool showOneAlertViewWithTitle:@"账号和密码不能为空" message:nil delegate:nil];
        
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSDictionary *params = @{@"userName" : self.userNameField.text,
                             @"pwd"      : self.pwdField.text};
    
    [LCProgressHUD showLoading:@"请稍候..."];
    
    [manager POST:LOGIN parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        LCLog(@"%@", responseObject);
        
        if ([responseObject[@"status"][@"code"] intValue]) {
            
            [LCTool showOneAlertViewWithTitle:responseObject[@"status"][@"msg"] message:nil delegate:nil];
             
        } else {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
            [LCProgressHUD showSuccess:@"登录成功"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [LCProgressHUD showInfoMsg:@"登录失败"];
    }];
}

@end
