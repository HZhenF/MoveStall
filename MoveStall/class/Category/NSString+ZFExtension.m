//
//  NSString+ZFExtension.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/14.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "NSString+ZFExtension.h"

@implementation NSString (ZFExtension)

+(NSMutableAttributedString *)changePlaceholderAttributes:(NSString *)str
{
    NSMutableAttributedString *placeholderAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //字体大小
   [placeholderAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0 weight:UIFontWeightThin] range:NSMakeRange(0, str.length)];
    //字体颜色
    [placeholderAtt addAttribute:NSForegroundColorAttributeName value:ZFColor(161, 161, 161) range:NSMakeRange(0, str.length)];
    //字体阴影
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [placeholderAtt addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, str.length)];
    return placeholderAtt;
}

+ (NSString *)validMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的电话号码";
        }
    }
    return nil;
}

@end
