//
//  NoneNetworkViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/23.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "NoneNetworkViewController.h"

@interface NoneNetworkViewController ()

@end

@implementation NoneNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, ZFScreenH * 0.4, ZFScreenW, 50)];
    lb.text = @"没有网络,请检查您的网络!";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor lightGrayColor];
    [self.view addSubview:lb];
    
}


@end
