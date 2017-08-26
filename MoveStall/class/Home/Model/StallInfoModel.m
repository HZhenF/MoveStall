//
//  StallInfoModel.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/28.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "StallInfoModel.h"
#import "StallShopModel.h"

@implementation StallInfoModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.user_phone = dict[@"user_phone"];
        self.user_coorLatitude = dict[@"user_coorLatitude"];
        self.user_coorLongtitude = dict[@"user_coorLongtitude"];
        self.stallInfo = [StallShopModel StallShopModelWithArray:dict[@"stallInfo"]];
    }
    return self;
}

+(instancetype)StallInfoModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user_phone forKey:@"user_phone"];
    [aCoder encodeObject:self.user_coorLatitude forKey:@"user_coorLongtitude"];
    [aCoder encodeObject:self.user_coorLongtitude forKey:@"user_coorLatitude"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.user_phone = [aDecoder decodeObjectForKey:@"user_phone"];
        self.user_coorLatitude = [aDecoder decodeObjectForKey:@"user_coorLatitude"];
        self.user_coorLongtitude = [aDecoder decodeObjectForKey:@"user_coorLongtitude"];
    }
    return self;
}

@end
