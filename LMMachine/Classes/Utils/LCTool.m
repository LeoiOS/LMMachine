//
//  LCTool.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LCTool.h"

@implementation LCTool

+ (void)showOneAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)showTwoAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
