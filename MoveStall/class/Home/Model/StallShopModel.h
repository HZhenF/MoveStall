//
//  StallShopModel.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/30.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StallShopModel : NSObject<NSCoding>

/**小摊名称*/
@property(nonatomic,strong) NSString *goods_name;
/**商品名称*/
@property(nonatomic,strong) NSString *stall_name;
/**商品描述*/
@property(nonatomic,strong) NSString *goods_description;

+(NSArray *)StallShopModelWithArray:(NSArray *)arr;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
