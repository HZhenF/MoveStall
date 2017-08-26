//
//  UILabel+ZFExtension.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/20.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZFExtension)

/**
 界面的提示
 
 @param tipsContent 提示内容
 @param fatherView 父视图
 @param myFrame 自己的frame
 */
+(void)showTipsLabel:(NSString *)tipsContent fatherView:(UIView *)fatherView myFrame:(CGRect)myFrame;

@end
