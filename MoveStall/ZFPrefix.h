//
//  ZFPrefix.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/14.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#ifndef ZFPrefix_h
#define ZFPrefix_h

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

//屏幕宽高
#define ZFScreenW [UIScreen mainScreen].bounds.size.width
#define ZFScreenH [UIScreen mainScreen].bounds.size.height

//屏幕适配
#define ZFRatioW ZFScreenW / 414
#define ZFRatioH ZFScreenH / 736

//RGB颜色
#define ZFColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0f]

//服务器IP地址
//static NSString *IPAdress = @"192.168.1.108";
static NSString *IPAdress = @"47.52.44.209";

//本地数据库表名
static NSString *DBTableName = @"Entity";

//引入分类
#import "NSString+ZFExtension.h"
#import "UILabel+ZFExtension.h"

//第三方库
#import "MBProgressHUD.h"

//公共接口
#import "PublicAPI.h"
#import "WGS84TOGCJ02.h"

//沙盒测试，产品ID，密钥
#define StallID @"xt1001"
#define shareSecret @"26d627e1569c48cfa6b5b3884c90198b"

#endif /* ZFPrefix_h */
