//
//  LoginVC.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LoginVC.h"
#import "AFNetworking.h"

@interface LoginVC ()

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
    
    
}

@end
