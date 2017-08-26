//
//  ZFAnnotationView.m
//  MapKitPractice1
//
//  Created by HZhenF on 2017/6/30.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFAnnotationView.h"
#import "ZFCalloutView.h"
#import "HandleCoreData.h"
#import "AppDelegate.h"
#import "Entity.h"

// 设置标签的宽和高
#define kWidth          50.f
#define kHeight         50.f

#define kHoriMargin     3.0f
#define kVertMargin     3.0f

#define kPortraitWidth  44.f
#define kPortraitHeight 44.f

// 设置弹出气泡的宽和高Callout
#define kCalloutWidth   200.0
#define kCalloutHeight  140.0


@interface ZFAnnotationView()

@property(nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation ZFAnnotationView

@dynamic annotation;


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.bounds            = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.backgroundColor   = [UIColor clearColor];
        // 添加用户头像
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        // 设置头像为圆
        [self.portraitImageView.layer setCornerRadius:CGRectGetHeight([self.portraitImageView bounds]) / 2];
        self.portraitImageView.layer.masksToBounds = YES;
        self.portraitImageView.layer.borderWidth = 1;
        self.portraitImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        //开始动画
        [self animation];
        [self addSubview:self.portraitImageView];
        
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [self.calloutView.collectionBtn convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.calloutView.collectionBtn.bounds, tempoint))
        {
            NSLog(@"触碰到Button");
            view = self.calloutView.collectionBtn;
        }
    }
    return view;
}



 -(void)setAnnotation:(ZFAnnotation *)annotation
{
    [super setAnnotation:annotation];
}

/**
 点击大头针调用的方法，处理弹框
 
 @param selected 是否选中大头针
 @param animated 动画
 */
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:YES];
    if (selected) {
        if (!self.calloutView) {
            //创建气泡
            self.calloutView = [[ZFCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.stallInfoModel = self.annotation.stallInfoMd;
            self.calloutView.alpha = 0.9;
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            //判断是否收藏过该小摊
            self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            StallInfoModel *model = self.annotation.stallInfoMd;
            NSArray *arr = [HandleCoreData queryAllDataFromDatabase:self.appDelegate];
            for (Entity *entity in arr) {
                StallInfoModel *stallmodel = [NSKeyedUnarchiver unarchiveObjectWithData:entity.stallInfo];
                if ([stallmodel.user_phone isEqualToString:model.user_phone]) {
                    //如果已经收藏过，按钮就设置为选中状态
                    [self.calloutView.collectionBtn setSelected:YES];
                }
            }
        }
        
        //将callloutView添加到地图上
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
        self.calloutView = nil;
    }
    
}


/**
 设置动画效果方法
 */
- (void)animation
{
    // 设置动画效果
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    // 透明度
    basicAnimation.keyPath   = @"opacity";
    // 从哪个值变化到哪个值
    basicAnimation.fromValue = @0.0;
    basicAnimation.toValue   = @1.0;
    basicAnimation.duration  = arc4random() % 2;
    // 添加动画效果
    [self.layer addAnimation:basicAnimation forKey:@"key"];
}

@end
