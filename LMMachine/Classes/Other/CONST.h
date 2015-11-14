//
//  CONST.h
//  LMMachine
//
//  Created by Leo on 15/11/13.
//  Copyright © 2015年 Leo. All rights reserved.
//  接口

#ifndef CONST_h
#define CONST_h



// 主机接口
#define ENV 10

#if ENV == 100  // 生产服务器
#define HOST    @"http://yun.lanmengkeji.com/mobile"

#elif ENV == 10
#define HOST    @"http://123.57.67.53:1010/mobile"

#elif ENV == 91
#define HOST    @"http://123.57.67.53:9191/mobile"

#elif ENV == 90
#define HOST    @"http://123.57.67.53:9090/mobile"

#elif ENV == 80
#define HOST    @"http://123.57.67.53:8080/mobile"

#elif ENV == 80235
#define HOST    @"http://192.168.1.235:8080/mobile"

#endif



// 登录
#define LOGIN       HOST @"/system/user/login"

// 考勤机
#define MACHINE     HOST @"/system/update/company/machine"

// 上传考勤机坐标
#define COORDINATE  HOST @"/system/company/machine/coordinate"




#endif /* CONST_h */
