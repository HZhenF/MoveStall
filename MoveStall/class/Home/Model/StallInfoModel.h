//
//  StallInfoModel.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/28.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StallInfoModel : NSObject<NSCoding>

/**用户手机*/
@property(nonatomic,strong) NSString *user_phone;
/**用户所在的纬度*/
@property(nonatomic,strong) NSString *user_coorLongtitude;
/**用户所在的经度*/
@property(nonatomic,strong) NSString *user_coorLatitude;
/**商品内容*/
@property(nonatomic,strong) NSArray *stallInfo;





/**
 转化为模型数据
 
 @param dict json字典
 @return 模型对象
 */
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)StallInfoModelWithDict:(NSDictionary *)dict;

@end
