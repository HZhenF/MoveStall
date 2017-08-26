//
//  StallShopModel.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/30.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "StallShopModel.h"

@implementation StallShopModel

+(NSArray *)StallShopModelWithArray:(NSArray *)arr
{
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        [tempArrM addObject:[[self alloc] initWithDict:dict]];
    }
    return [tempArrM copy];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.goods_name = dict[@"goods_name"];
        self.stall_name = dict[@"stall_name"];
        self.goods_description = dict[@"goods_description"];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.goods_name = [aDecoder decodeObjectForKey:@"goods_name"];
        self.stall_name = [aDecoder decodeObjectForKey:@"stall_name"];
        self.goods_description = [aDecoder decodeObjectForKey:@"goods_description"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.goods_name forKey:@"goods_name"];
    [aCoder encodeObject:self.stall_name forKey:@"stall_name"];
    [aCoder encodeObject:self.goods_description forKey:@"goods_description"];
}

@end
