//
//  GlobalData.m
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

+ (instancetype)sharedData {
    
    static GlobalData *gd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gd = [[GlobalData alloc] init];
    });
    return gd;
}

@end
