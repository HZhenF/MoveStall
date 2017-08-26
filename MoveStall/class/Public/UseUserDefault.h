//
//  UseUserDefault.h
//  MoveStall
//
//  Created by HZhenF on 2017/8/7.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseUserDefault : NSObject


/**
 设置UserDefault
 
 @param dict 要在UserDefault设置的内容
 */
+(void)setupUserDefault:(NSDictionary *)dict;



/**
 从UserDefault获取内容
 
 @param key UserDefault的键
 @return UserDefault的键值对
 */
+(NSMutableDictionary *)getValueFromUserDefault:(NSMutableArray *)key;


/**
 从UserDefault中删除对应的内容
 
 @param key UserDefault的键
 */
+(void)deleteValueFromUserDefault:(NSMutableArray *)key;


/**
 从UserDefault里面获取用户手机
 
 @return 用户手机
 */
+(NSString *)getUser_PhoneFromUserDefault;


/**
 从UserDefault里面获取用户的token
 
 @return 用户Token
 */
+(NSString *)getUder_TokenFromUserDefault;

@end
