//
//  LoginSuccessModel.h
//  MoveStall
//
//  Created by HZhenF on 2017/8/8.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginSuccessModel : NSObject
/**用户手机*/
@property(nonatomic,strong) NSString *user_phone;
/**用户免登陆到期时间*/
@property(nonatomic,strong) NSString *user_deadline;
/**用户摆摊状态*/
@property(nonatomic,strong) NSString *user_stallOnline;
/**用户的token*/
@property(nonatomic,strong) NSString *user_token;


/**
 数据转模型
 
 @param dict 数据字典
 @return 当前对象
 */
+(LoginSuccessModel *)LoginSuccessModelWithDict:(NSDictionary *)dict;

@end
