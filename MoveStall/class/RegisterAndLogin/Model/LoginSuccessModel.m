//
//  LoginSuccessModel.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/8.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "LoginSuccessModel.h"

@implementation LoginSuccessModel

+(LoginSuccessModel *)LoginSuccessModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(LoginSuccessModel *)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.user_phone = dict[@"user_phone"];
        self.user_token = dict[@"user_token"];
        self.user_deadline = dict[@"user_deadline"];
        if (dict[@"user_stallOnline"]) {
             self.user_stallOnline = dict[@"user_stallOnline"];
        }
        else
        {
            self.user_stallOnline = @"0";
        }
    }
    return self;
}

@end
