//
//  ZFTableViewCell.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/31.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFTableViewCell.h"

@implementation ZFTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.goods_nameLB = [[UILabel alloc] init];
//        self.goods_nameLB.backgroundColor = [UIColor yellowColor];
        self.goods_nameLB.textAlignment = NSTextAlignmentCenter;
        self.goods_nameLB.font = [UIFont systemFontOfSize:17.0];
        self.goods_nameLB.textColor = [UIColor blackColor];
        [self addSubview:self.goods_nameLB];
        
        self.goods_descriptionLB = [[UILabel alloc] init];
//        self.goods_descriptionLB.backgroundColor = [UIColor cyanColor];
        self.goods_descriptionLB.font = [UIFont systemFontOfSize:13.0];
        self.goods_descriptionLB.textColor = [UIColor grayColor];
        self.goods_descriptionLB.numberOfLines = 0;
        [self addSubview:self.goods_descriptionLB];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect myFrame = self.frame;
    self.goods_nameLB.frame = CGRectMake(0, myFrame.size.height*0.25, myFrame.size.width*0.4, myFrame.size.height*0.5);
    self.goods_descriptionLB.frame = CGRectMake(CGRectGetMaxX(self.goods_nameLB.frame), 0, myFrame.size.width * 0.6, myFrame.size.height);
}

@end
