//
//  MachineModel.h
//  LMMachine
//
//  Created by 苑金仓 on 15/11/14.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachineModel : NSObject

@property (nonatomic, copy) NSString *signalLevel;
@property (nonatomic, copy) NSString *lastmodUser;
@property (nonatomic, copy) NSString *lastmodTime;
@property (nonatomic, copy) NSString *companyKey;
@property (nonatomic, copy) NSString *machineMac;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *isValid;
@property (nonatomic, copy) NSString *idx;
@property (nonatomic, copy) NSString *machineId;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *posX;
@property (nonatomic, copy) NSString *posY;
@property (nonatomic, copy) NSString *machineRegin;
@property (nonatomic, copy) NSString *machineReginCN;
@property (nonatomic, copy) NSString *machineAddr;
@property (nonatomic, copy) NSString *machineDistance;
@property (nonatomic, copy) NSString *machineIpAddr;
@property (nonatomic, copy) NSString *machineWifiName;
@property (nonatomic, copy) NSString *machineWifiPwd;

@end

/*
 "signalLevel": "",
 "lastmodUser": "",
 "lastmodTime": "2015-06-06 19:40:56",
 "companyKey": "866b3779-4774-45bf-9828-65f818578b5c",
 "machineMac": "0013ef702cb3\n",
 "createTime": "1433590856000",
 "isValid": "Y",
 "idx": "1",
 "machineId": "1234567A009",
 "deleteTime": "",
 "posX": "116.424850",
 "posY": "40.003548",
 "machineRegin": "OWN",
 "machineReginCN": "本公考勤机",
 "machineAddr": "北京市朝阳区北苑路170号院-5",
 "machineDistance": "100",
 "machineIpAddr": "",
 "machineWifiName": "",
 "machineWifiPwd": ""
 */