//
//  NSString+ZFExtension.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/14.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZFExtension)

/**
 改变输入框的placeholder提示内容的格式
 
 @param str 提示的内容
 @return 修改好的样式
 */
+(NSMutableAttributedString *)changePlaceholderAttributes:(NSString *)str;


/**
 判断手机号是否有效
 
 @param mobile 输入的手机号码
 @return 提示的信息
 */
+ (NSString *)validMobile:(NSString *)mobile;

@end
