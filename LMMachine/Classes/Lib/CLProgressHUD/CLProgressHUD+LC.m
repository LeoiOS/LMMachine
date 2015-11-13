//
//  CLProgressHUD+LC.m
//  GuoLuKe
//
//  Created by 刘超 on 15/8/4.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "CLProgressHUD+LC.h"

@interface CLProgressHUD ()

@property (nonatomic, strong) CLProgressHUD *hud;

@end

@implementation CLProgressHUD (LC)

+ (instancetype)showLoadingText:(NSString *)text inView:(UIView *)view {
    
    CLProgressHUD *hud = [[CLProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.text  = text;
    hud.shape = CLProgressHUDShapeLinear;
    hud.type  = CLProgressHUDTypeDarkForground;
    [hud showWithAnimation:YES];
    
    return hud;
}

+ (instancetype)showLoadingInWindowText:(NSString *)text {
    
    return [self showLoadingText:text inView:[UIApplication sharedApplication].keyWindow];
}

@end
