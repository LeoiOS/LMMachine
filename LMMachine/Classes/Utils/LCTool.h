//
//  LCTool.h
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTool : NSObject

+ (void)showOneAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

+ (void)showTwoAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

@end
