//
//  CLProgressHUD+LC.h
//  GuoLuKe
//
//  Created by 刘超 on 15/8/4.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "CLProgressHUD.h"

@interface CLProgressHUD (LC)

/**
 *  显示HUD到View上
 *
 *  @param text 文字
 *  @param view view
 *
 *  @return HUD
 */
+ (instancetype)showLoadingText:(NSString *)text inView:(UIView *)view;

/**
 *  显示HUD到Window上
 *
 *  @param text 文字
 *
 *  @return HUD
 */
+ (instancetype)showLoadingInWindowText:(NSString *)text;

@end
