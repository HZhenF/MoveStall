//
//  RegisterViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/14.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZFScrollView.h"
#import "HomeViewController.h"
#import "MeViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController()<UIScrollViewDelegate>

@property(nonatomic,strong) ZFScrollView *ZFScrollView;

/**背景图片*/
@property(nonatomic,strong) UIImageView *backgroundImgView;

@end


@implementation RegisterViewController


#pragma mark - 系统方法



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化所有控件
    [self setupAllControls];
    
    //根据输入框是否有内容,设置注册按钮是否可以点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    //登录成功通知,跳转到主页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToHomeVC:) name:@"jumpHomeVC" object:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 通知事件

/**
 根据输入框的内容显示按钮的状态
 */
-(void)textChange{
    self.ZFScrollView.registerBtn.enabled = (self.ZFScrollView.registerPhoneTextField.text.length && self.ZFScrollView.registerPasswordTextField.text.length);
    if (self.ZFScrollView.registerBtn.enabled) {
        self.ZFScrollView.registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else
    {
        self.ZFScrollView.registerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    self.ZFScrollView.loginBtn.enabled = (self.ZFScrollView.loginPhoneTextField.text.length && self.ZFScrollView.loginPasswordTextField.text.length);
    if (self.ZFScrollView.loginBtn.enabled) {
        self.ZFScrollView.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else
    {
        self.ZFScrollView.loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}


/**
 登录成功跳转
 
 @param notification 通知
 */
-(void)jumpToHomeVC:(NSNotification *)notification
{
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:self completion:^{
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdelegate.registerVC = nil;
    }];
}



#pragma mark - 初始化控件

-(void)setupAllControls
{
    self.backgroundImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.backgroundImgView.image = [UIImage imageNamed:@"background.JPG"];
    [self.view addSubview:self.backgroundImgView];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.backgroundImgView.frame.size.width, self.backgroundImgView.frame.size.height);
    [self.backgroundImgView addSubview:effectView];
    
    self.ZFScrollView = [[ZFScrollView alloc] initWithFrame:CGRectMake(0, ZFScreenH * 0.2, ZFScreenW, ZFScreenH * 0.5)];
    self.ZFScrollView.delegate = self;
    self.ZFScrollView.contentOffset = CGPointMake(ZFScreenW, 0);
    [self.view addSubview:self.ZFScrollView];
}

@end
