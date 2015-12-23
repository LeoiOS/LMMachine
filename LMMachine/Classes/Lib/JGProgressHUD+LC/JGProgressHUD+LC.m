//
//  JGProgressHUD+LC.m
//  GuoLuKe
//
//  Created by 刘超 on 15/8/7.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "JGProgressHUD+LC.h"

@implementation JGProgressHUD (LC)

+ (void)showSuccessHUD:(NSString *)title {
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 6.0f;
    
    HUD.textLabel.text = title;
    
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
    [HUD dismissAfterDelay:1.8f];
}

+ (void)showFailureHUD:(NSString *)title {
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 6.0f;
    
    HUD.textLabel.text = title;
    
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
    [HUD dismissAfterDelay:1.8f];
}

+ (instancetype)showLoadingHUD:(NSString *)title {
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.textLabel.text = title;
    
    HUD.square = YES;
    
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
    [HUD dismissAfterDelay:2.0];
    
    return HUD;
}

+ (void)showSuccessChangHUD:(NSString *)title {
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.textLabel.text = title;
    
    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
    [HUD dismissAfterDelay:2.0];
}

+ (void)showFailureChangHUD:(NSString *)title {
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 6.0f;
    
    HUD.textLabel.text = title;
    
    HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
    [HUD dismissAfterDelay:2.0];
}

+ (instancetype)showLoadingChangHUD:(NSString *)title; {
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.textLabel.text = title;
    
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    
    [HUD dismissAfterDelay:2.0];
    
    return HUD;
}

@end
