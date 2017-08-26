//
//  JudgeViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/9.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "JudgeViewController.h"
#import "UseUserDefault.h"
#import "MeViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface JudgeViewController ()

@end

static NSString *dismissFlag = @"";

@implementation JudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self setupTabbar];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"restartLocation" object:nil userInfo:nil];
    
}


-(void) resetAllWhenHaveNetWork
{
    NSMutableDictionary *dictM = [UseUserDefault getValueFromUserDefault:[@[
                                                                            @"user_phone",
                                                                            @"user_token",
                                                                            @"user_deadline",
                                                                            @"user_stallOnline"
                                                                            ]
                                                                          mutableCopy]];
    
    
    //用户身份
    //判断是否可以进行免登录
        if (dictM[@"user_token"])
        {
            NSString *user_token = dictM[@"user_token"];
            
            //发送请求，查看Token是否到期
            [PublicAPI requestForJudeDeadlineToken:user_token callback:^(id obj) {
                
                NSLog(@"obj = %@",obj);
                if ([obj[@"code"] isEqualToString:@"10008"])
                {
                    NSLog(@"免登陆成功!");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //可以免登陆
                        //更新小摊状态信息
                        [UseUserDefault setupUserDefault:@{
                                                           @"user_stallOnline":obj[@"user_stallOnline"]
                                                           }];
                        //1为未到期，0和-1为到期
                        if ([obj[@"status"] isEqualToString:@"1"])
                        {
                            //屏幕旋转180
                            [UIView animateWithDuration:1 animations:^{
                                CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                                basicAnimation.duration = 0.7;
                                basicAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
                                [self.view.layer addAnimation:basicAnimation forKey:nil];
                            } completion:^(BOOL finished) {
                                HomeViewController *homeVC = [[HomeViewController alloc] init];
                                homeVC.isFreeLogin = obj[@"status"];
                                MeViewController *meVC = [[MeViewController alloc] init];
                                UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
                                self.tabBarController.selectedIndex = 0;
                                self.viewControllers = @[homeVC,meNav];
                                
                            }];
                        }
                        //免登陆过期
                        else
                        {
                            [UseUserDefault deleteValueFromUserDefault:[@[
                                                                          @"user_phone",
                                                                          @"user_token",
                                                                          @"user_deadline",
                                                                          @"user_stallOnline"
                                                                          ]                                                                                                                                               mutableCopy]];
                            [self setupController:@"0" isCount:YES];
                        }
                    });
                    
                }
            }];
        }
        //游客身份
        else
        {
            [self setupController:@"0" isCount:NO];
        }
}


/**
 这是TabBarController的子控制器
 
 @param FreeLoginFlag HomeViewController提示免登陆是否过期
 @param isCount       是否是用户
 */
-(void)setupController:(NSString *)FreeLoginFlag isCount:(Boolean)isCount
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    if (isCount) {
        homeVC.isFreeLogin = FreeLoginFlag;
    }
    MeViewController *meVC = [[MeViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
    self.tabBarController.selectedIndex = 0;
    self.viewControllers = @[homeVC,meNav];
    
}


/**
 设置tabbar的状态
 */
-(void)setupTabbar
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    NSMutableDictionary *selectAttri = [NSMutableDictionary dictionary];
    selectAttri[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    selectAttri[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    //通过appearance对tabBarItem的文字属性进行统一设置，这样所有的控制的tabBarItem的文字属性久都是这种样式的了
    UITabBarItem *tabbar = [UITabBarItem appearance];
    [tabbar setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [tabbar setTitleTextAttributes:selectAttri forState:UIControlStateSelected];
}

@end
