//
//  GlobalData.h
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject

@property (nonatomic, copy) NSString *companyKey;
@property (nonatomic, copy) NSString *userName;

+ (instancetype)sharedData;

@end
