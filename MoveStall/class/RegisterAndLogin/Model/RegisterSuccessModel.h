//
//  RegisterSuccessModel.h
//  MoveStall
//
//  Created by HZhenF on 2017/8/8.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterSuccessModel : NSObject
/**用户手机*/
@property(nonatomic,strong) NSString *user_phone;
/**用户到期时间*/
@property(nonatomic,strong) NSString *user_deadline;
/**用户的token*/
@property(nonatomic,strong) NSString *user_token;


/**
 数据转模型
 
 @param dict 数据字典
 @return 当前对象
 */
+(RegisterSuccessModel *)RegisterSuccessModelWithDict:(NSDictionary *)dict;

@end
