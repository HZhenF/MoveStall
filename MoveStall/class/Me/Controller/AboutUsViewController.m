//
//  AboutUsViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/22.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property(nonatomic,strong) UILabel *topLb;
@property(nonatomic,strong) UILabel *lbOne;
@property(nonatomic,strong) UILabel *lbTwo;
@property(nonatomic,strong) UILabel *lbThree;
@property(nonatomic,strong) UILabel *lbFour;
@property(nonatomic,strong) UILabel *lbFive;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImgView.image = [UIImage imageNamed:@"AboutUsbackground"];
    [self.view addSubview:backgroundImgView];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barItem;
    
    
    UILabel * topLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 200, 50)];
    topLb.text = @"关于我们";
    topLb.font = [UIFont systemFontOfSize:19.0];
    topLb.textColor = ZFColor(66, 66, 70);
    topLb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = topLb;
    
    self.lbOne = [[UILabel alloc] initWithFrame:CGRectMake(0, ZFScreenH, ZFScreenW, 50)];
    self.lbTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, ZFScreenH, ZFScreenW, 50)];
    self.lbThree = [[UILabel alloc] initWithFrame:CGRectMake(0, ZFScreenH, ZFScreenW, 50)];
    self.lbFour = [[UILabel alloc] initWithFrame:CGRectMake(0, ZFScreenH, ZFScreenW, 50)];
    self.lbFive = [[UILabel alloc] initWithFrame:CGRectMake(0, ZFScreenH, ZFScreenW, 50)];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.lbOne.frame = CGRectMake(0, ZFScreenH * 0.4, ZFScreenW, 30);
        self.lbOne.textColor = [UIColor grayColor];
        self.lbOne.text = @"移动小摊";
        self.lbOne.textAlignment = NSTextAlignmentCenter;
        self.lbOne.font = [UIFont systemFontOfSize:17.0];
        [self.view addSubview:self.lbOne];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2.0 animations:^{
            self.lbTwo.frame = CGRectMake(0, CGRectGetMaxY(self.lbOne.frame), ZFScreenW, 30);
            self.lbTwo.textColor = [UIColor grayColor];
            self.lbTwo.font = [UIFont systemFontOfSize:13.0];
            self.lbTwo.text = @"本应用";
            self.lbTwo.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.lbTwo];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:^{
                self.lbThree.frame = CGRectMake(0, CGRectGetMaxY(self.lbTwo.frame), ZFScreenW, 30);
                self.lbThree.textColor = [UIColor grayColor];
                self.lbThree.text = @"黄振锋在Dr.Chen指导下完成";
                self.lbThree.font = [UIFont systemFontOfSize:13.0];
                self.lbThree.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:self.lbThree];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0 animations:^{
                    self.lbFour.frame = CGRectMake(0, CGRectGetMaxY(self.lbThree.frame), ZFScreenW, 30);
                    self.lbFour.textColor = [UIColor grayColor];
                    self.lbFour.text = @"该软件功能最终解释权";
                    self.lbFour.font = [UIFont systemFontOfSize:13.0];
                    self.lbFour.textAlignment = NSTextAlignmentCenter;
                    [self.view addSubview:self.lbFour];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:2.0 animations:^{
                        self.lbFive.frame = CGRectMake(0, CGRectGetMaxY(self.lbFour.frame), ZFScreenW, 30);
                        self.lbFive.textColor = [UIColor grayColor];
                        self.lbFive.font = [UIFont systemFontOfSize:13.0];
                        self.lbFive.text = @"请来邮箱 21635308@qq.com";
                        self.lbFive.textAlignment = NSTextAlignmentCenter;
                        [self.view addSubview:self.lbFive];
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }];
        }];
    }];
    
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
