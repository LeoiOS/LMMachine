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

@interface LoginVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (nonatomic, weak) CLProgressHUD *loadingHUD;

@end

@implementation LoginVC

#pragma mark - UITextField 代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userNameField) {
        
        [self.pwdField becomeFirstResponder];
        
    } else if (textField == self.pwdField) {
        
        [self rightBtnClicked];
    }
    
    return YES;
}

#pragma mark - Main Code

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"帮助"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBtnClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(rightBtnClicked)];
    
    NSString *userName = [GlobalData sharedData].userName;
    
    if (userName.length > 0) {
        
        self.userNameField.text = userName;
    }
}

- (void)leftBtnClicked {
    
    NSString *message = [NSString stringWithFormat:@"%@\n当前版本为内测版本，可能存在一些 Bug。如有遇到，请摇一摇进行反馈！谢谢！\nV%@(beta) build%@\n© 北京揽梦科技有限公司",
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [LCTool showOneAlertViewWithTitle:@"帮助" message:message delegate:nil];
}

- (void)rightBtnClicked {
    
    if (self.userNameField.text.length == 0 || self.pwdField.text.length == 0) {
        
        [LCTool showOneAlertViewWithTitle:@"账号和密码不能为空。" message:nil delegate:nil];
        
        return;
    }
    
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSDictionary *params = @{@"userName" : self.userNameField.text,
                             @"pwd"      : self.pwdField.text};
    
    self.loadingHUD = [CLProgressHUD showLoadingText:@"正在登录中..." inView:self.view];
    
    [manager POST:LOGIN parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        LCLog(@"%@", responseObject);
        
        [self.loadingHUD dismissWithAnimation:YES];
        
        if ([responseObject[@"status"][@"code"] intValue]) {
            
            [LCTool showOneAlertViewWithTitle:responseObject[@"status"][@"msg"] message:nil delegate:nil];
            
        } else {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
//            [JGProgressHUD showSuccessHUD:@"登录成功"];
            
            [GlobalData sharedData].companyKey = responseObject[@"data"][@"companyKey"];
            [GlobalData sharedData].userName = self.userNameField.text;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        LCLog(@"%@", error);
        
        [self.loadingHUD dismissWithAnimation:NO];
        
        [JGProgressHUD showFailureChangHUD:@"请检查网络连接"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
