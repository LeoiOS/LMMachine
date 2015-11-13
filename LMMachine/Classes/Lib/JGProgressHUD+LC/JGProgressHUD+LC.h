//
//  JGProgressHUD+LC.h
//  GuoLuKe
//
//  Created by 刘超 on 15/8/7.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "JGProgressHUD.h"

@interface JGProgressHUD (LC)

+ (void)showSuccessHUD:(NSString *)title;
+ (void)showFailureHUD:(NSString *)title;
+ (instancetype)showLoadingHUD:(NSString *)title;

+ (void)showSuccessChangHUD:(NSString *)title;
+ (void)showFailureChangHUD:(NSString *)title;
+ (instancetype)showLoadingChangHUD:(NSString *)title;

@end
