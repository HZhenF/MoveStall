//
//  UILabel+ZFExtension.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/20.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "UILabel+ZFExtension.h"

@implementation UILabel (ZFExtension)

+(void)showTipsLabel:(NSString *)tipsContent fatherView:(UIView *)fatherView myFrame:(CGRect)myFrame
{
    UILabel *ZFTipsLabel;
    ZFTipsLabel = [[UILabel alloc] initWithFrame:myFrame];
    ZFTipsLabel.backgroundColor = ZFColor(149, 149, 149);
    ZFTipsLabel.textAlignment = NSTextAlignmentCenter;
    ZFTipsLabel.textColor = [UIColor whiteColor];
    ZFTipsLabel.text = tipsContent;
    ZFTipsLabel.layer.borderWidth = 1.0f;
    ZFTipsLabel.layer.cornerRadius = 8;
    ZFTipsLabel.numberOfLines = 0;
    ZFTipsLabel.layer.borderColor = [UIColor clearColor].CGColor;
    ZFTipsLabel.layer.masksToBounds = YES;
    [fatherView addSubview:ZFTipsLabel];
    
    [UIView animateWithDuration:3.0f animations:^{
        ZFTipsLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [ZFTipsLabel removeFromSuperview];
    }];
}

@end
