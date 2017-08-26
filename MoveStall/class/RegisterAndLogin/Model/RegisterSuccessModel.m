//
//  RegisterSuccessModel.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/8.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "RegisterSuccessModel.h"

@implementation RegisterSuccessModel

+(RegisterSuccessModel *)RegisterSuccessModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(RegisterSuccessModel *)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.user_phone = dict[@"user_phone"];
        self.user_deadline = dict[@"user_deadline"];
        self.user_token = dict[@"user_token"];
    }
    return self;
}

@end
