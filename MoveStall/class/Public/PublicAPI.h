//
//  PublicAPI.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/20.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZFCallBack)(id obj);

@interface PublicAPI : NSObject



/**
 注册接口
 
 @param user_phone 用户手机
 @param user_password 用户密码
 @param callback 回调方法
 */
+(void)requestForRegister:(NSString *)user_phone user_password:(NSString *)user_password callback:(ZFCallBack)callback;


/**
 登录接口
 
 @param user_phone 用户手机
 @param user_password 用户密码
 @param callback 回调方法
 */
+(void)requestForLoginUser_phone:(NSString *)user_phone userpassword:(NSString *)user_password callback:(ZFCallBack)callback;


/**
 摆摊接口
 
 @param param 小摊信息参数
 @param callback 回调方法
 */
+(void)requestForPitchParam:(id)param callback:(ZFCallBack)callback;


/**
 取消摆摊接口
 
 @param param 小摊信息参数
 @param callback 回调方法
 */
+(void)requestForCloseStallParam:(id)param callback:(ZFCallBack)callback;




/**
 查询符合坐标范围的小摊位置
 
 @param params 坐标范围字典
 @param callback 回调方法
 */
+(void)requestForQueryAllStallInfo:(NSDictionary *)params Callback:(ZFCallBack)callback;



/**
 更新小摊坐标位置
 
 @param params 坐标参数字典
 @param callback 回调方法
 */
+(void)requestForUpdateLocation:(NSDictionary *)params callback:(ZFCallBack)callback;


/**
 查询token是否到期
 
 @param token 自己的Token
 @param callback 回调方法
 */
+(void)requestForJudeDeadlineToken:(NSString *)token callback:(ZFCallBack)callback;



/**
 把购买凭据信息存储到服务器
 
 @param token 用户token
 @param receipt 用户凭据
 @param purchase_date 购买时间
 @param expires_date 到期时间
 @param transaction_id 订单ID
 @param callback 回调方法
 */
+(void)requestForStoreReceiptToServerToken:(NSString *)token receipt:(NSString *)receipt purchase_date:(NSString *)purchase_date expires_date:(NSString *)expires_date buy_frequency:(NSString *)buy_frequency transaction_id:(NSString *)transaction_id callback:(ZFCallBack)callback;


/**
 检查内购产品是否到期
 
 @param user_token 用户token
 @param callback 回调方法
 */
+(void)requestForCheckUpExpires_dateToken:(NSString *)user_token callback:(ZFCallBack)callback;

+(void)requestForVerify;


@end
