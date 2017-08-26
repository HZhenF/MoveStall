//
//  UseUserDefault.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/7.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "UseUserDefault.h"

@implementation UseUserDefault

+(void)setupUserDefault:(NSDictionary *)dict
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *dictKey = [dict allKeys];
    for (NSString *key in dictKey) {
        if (!dict[key]) {
            continue;
        }
        [ud setObject:dict[key] forKey:key];
    }
    [ud synchronize];
}

+(NSMutableDictionary *)getValueFromUserDefault:(NSMutableArray *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSString *str in key) {
        NSString *udStr = [ud objectForKey:str];
        if (!udStr) {
            continue;
        }
        [dictM setObject:udStr forKey:str];
    }
    return dictM;
}

+(void)deleteValueFromUserDefault:(NSMutableArray *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    for (NSString *str in key) {
        [ud removeObjectForKey:str];
        NSLog(@"删除");
    }
    [ud synchronize];
}

+(NSString *)getUser_PhoneFromUserDefault
{
    NSMutableDictionary *dict = [UseUserDefault getValueFromUserDefault:[@[@"user_phone"] copy]];
    NSString *str = nil;
    if (dict[@"user_phone"]) {
       str = dict[@"user_phone"];
    }
    return str;
}

+(NSString *)getUder_TokenFromUserDefault
{
    NSMutableDictionary *dict = [UseUserDefault getValueFromUserDefault:[@[@"user_token"] copy]];
    NSString *str = nil;
    if (dict[@"user_token"]) {
        str = dict[@"user_token"];
    }
    return str;
}

@end
