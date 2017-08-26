//
//  MD5.h
//  MoveStall
//
//  Created by HZhenF on 2017/8/19.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface MD5 : NSObject


/**
 MD5加密
 
 @param input 要加密的字符串
 @return 加密后的字符串
 */
+ (NSString *) md5:(NSString *) input;

@end
