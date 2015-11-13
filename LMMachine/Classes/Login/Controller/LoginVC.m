//
//  LoginVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LoginVC.h"
#import "AFNetworking.h"
#import "LCTool.h"
#import "JGProgressHUD+LC.h"
#import "CLProgressHUD+LC.h"
#import "GlobalData.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (nonatomic, weak) CLProgressHUD *loadingHUD;

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
    
    self.loadingHUD = [CLProgressHUD showLoadingText:@"正在登录中..." inView:self.view];
    
    [manager POST:LOGIN parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        LCLog(@"%@", responseObject);
        
        if ([responseObject[@"status"][@"code"] intValue]) {
            
            [LCTool showOneAlertViewWithTitle:responseObject[@"status"][@"msg"] message:nil delegate:nil];
             
        } else {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
            [self.loadingHUD dismissWithAnimation:YES];
            [JGProgressHUD showSuccessHUD:@"登录成功"];
            
            [GlobalData sharedData].companyKey = responseObject[@"data"][@"companyKey"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [self.loadingHUD dismissWithAnimation:YES];
        [JGProgressHUD showFailureHUD:@"登录失败"];
    }];
}

@end
