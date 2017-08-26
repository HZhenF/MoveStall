//
//  ZFScrollView.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/18.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFScrollView.h"
#import "UseUserDefault.h"
#import "RegisterSuccessModel.h"
#import "LoginSuccessModel.h"
#import "MD5.h"


@interface ZFScrollView()<UITextFieldDelegate>

/**注册:图标*/
@property(nonatomic,strong) UIImageView *registerSignPicImgView;
/**登录:图标*/
@property(nonatomic,strong) UIImageView *loginSignPicImgView;


@end

@implementation ZFScrollView

#pragma mark - 系统方法

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.contentSize = CGSizeMake(ZFScreenW * 2, 0);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        //初始化所有控件
        [self setupAllControls];
        
    }
    return  self;
}

#pragma mark - 按钮点击事件

/**
 登录按钮点击事件
 */
-(void)loginBtnAction
{
    self.userInteractionEnabled = NO;
    
    NSString *phone = self.loginPhoneTextField.text;
    NSString *password = self.loginPasswordTextField.text;
    
    //判断手机号码是否正确
    NSString *tipInfo = [NSString validMobile:phone];
    CGRect myFrame = CGRectMake((ZFScreenW - 200 * ZFRatioW) * 0.5 + ZFScreenW, (self.frame.size.height - 100 * ZFRatioH) *0.5, 200 * ZFRatioW, 100 * ZFRatioH);
    
    if (!tipInfo) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [self addSubview:HUD];
        HUD.label.text = @"加载中...";
        HUD.mode = MBProgressHUDModeIndeterminate;
        
        [PublicAPI requestForLoginUser_phone:phone userpassword:[MD5 md5:password] callback:^(id obj) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //登录成功
                if ([obj[@"code"] isEqualToString:@"10002"])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [HUD hideAnimated:YES];
                        
                        //写入到UserDefault里面
                        NSDictionary *userInfo = obj[@"data"][0];
                        LoginSuccessModel *loginSuccModel = [LoginSuccessModel LoginSuccessModelWithDict:userInfo];
                        
                        [UseUserDefault setupUserDefault:@{
                                                           @"user_phone":loginSuccModel.user_phone,
                                                           @"user_token":loginSuccModel.user_token,
                                                           @"user_deadline":loginSuccModel.user_deadline,
                                                           @"user_stallOnline":loginSuccModel.user_stallOnline
                                                           }];
                        
                        [UILabel showTipsLabel:obj[@"msg"] fatherView:self myFrame:myFrame];
                        
                        //发送登录成功通知,跳转界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpHomeVC" object:nil userInfo:nil];
                    });
                    
                    
                }
                //登录失败
                else if ([obj[@"code"] isEqualToString:@"10003"])
                {
                      [HUD hideAnimated:YES];
                      [UILabel showTipsLabel:obj[@"msg"] fatherView:self myFrame:myFrame];
                      self.userInteractionEnabled = YES;
                }
            });
        }];
    }
    else
    {
        [UILabel showTipsLabel:tipInfo fatherView:self myFrame:myFrame];
        self.userInteractionEnabled = YES;
    }
}

/**
 注册按钮点击事件
 */
-(void)registerBtnAction
{
    self.userInteractionEnabled = NO;
    
    NSString *phone = self.registerPhoneTextField.text;
    NSString *password = self.registerPasswordTextField.text;
    
    //判断手机号码是否正确
    NSString *tipInfo = [NSString validMobile:phone];
    CGRect myFrame = CGRectMake((ZFScreenW - 200 * ZFRatioW) * 0.5, (self.frame.size.height - 100 * ZFRatioH) *0.5, 200 * ZFRatioW, 100 * ZFRatioH);
    
    if (!tipInfo) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [self addSubview:HUD];
        HUD.label.text = @"加载中...";
        HUD.mode = MBProgressHUDModeIndeterminate;
        
        
        [PublicAPI requestForRegister:phone user_password:[MD5 md5:password] callback:^(id obj) {
            //注册成功
            dispatch_sync(dispatch_get_main_queue(), ^{
    
                if ([obj[@"code"] isEqualToString:@"10001"]) {
                     [HUD hideAnimated:YES];
                    
                    [UILabel showTipsLabel:obj[@"msg"] fatherView:self myFrame:myFrame];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //写入到UserDefault里面
                        NSDictionary *userInfo = obj[@"data"];
                        
                        RegisterSuccessModel *registerSuccModel = [RegisterSuccessModel RegisterSuccessModelWithDict:userInfo];
                        
                        [UseUserDefault setupUserDefault:@{
                                                           @"user_phone":registerSuccModel.user_phone,
                                                           @"user_token":registerSuccModel.user_token,
                                                           @"user_deadline":registerSuccModel.user_deadline,
                                                           @"user_stallOnline":@"0"
                                                           }];
                        
                        //发送通知跳转到主页
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpHomeVC" object:nil userInfo:nil];
                    });
                    
                    
                    
                }
                //注册失败
                else if ([obj[@"code"] isEqualToString:@"10000"])
                {
                    [HUD hideAnimated:YES];
                    [UILabel showTipsLabel:obj[@"msg"] fatherView:self myFrame:myFrame];
                    self.userInteractionEnabled = YES;
                }
            });
        }];
    }
    else
    {
        [UILabel showTipsLabel:tipInfo fatherView:self myFrame:myFrame];
        self.userInteractionEnabled = YES;
    }
}


/**
 立即注册按钮
 */
-(void)registerImmBtn
{
    [UIView animateWithDuration:0.8f animations:^{
        self.contentOffset = CGPointMake(0, 0);
    }];
}

/**
 立即登录按钮
 */
-(void)loginImmBtnAction
{
    [UIView animateWithDuration:0.8f animations:^{
        self.contentOffset = CGPointMake(ZFScreenW, 0);
    }];
}

#pragma mark - 初始化控件和信息

/**
 初始化所有控件
 */
-(void)setupAllControls
{
    //注册界面图标
    self.registerSignPicImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5*(ZFScreenW - 100 *ZFRatioW), 0, 100 * ZFRatioW, 100 * ZFRatioH)];
//    self.registerSignPicImgView.backgroundColor = [UIColor cyanColor];
    self.registerSignPicImgView.image = [UIImage imageNamed:@"MoveStall_registerSignPicImgView"];
    [self addSubview:self.registerSignPicImgView];
    
    //注册:手机输入框
    self.registerPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.5*(ZFScreenW - 300 * ZFRatioW), CGRectGetMaxY(self.registerSignPicImgView.frame) + 10, 300 * ZFRatioW, 44 *ZFRatioH)];
    self.registerPhoneTextField.background = [UIImage imageNamed:@"textFieldBackground"];
    self.registerPhoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.registerPhoneTextField.font = [UIFont systemFontOfSize:13.0];
    self.registerPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.registerPhoneTextField.attributedPlaceholder = [NSString changePlaceholderAttributes:@"请输入手机号码"];
    [self addSubview:self.registerPhoneTextField];
    UIImageView *registerLeftPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.registerPhoneTextField.frame.size.height - 20)*0.5, 40, 20)];
    registerLeftPhoneImgView.image = [UIImage imageNamed:@"phone"];
    registerLeftPhoneImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.registerPhoneTextField.leftView = registerLeftPhoneImgView;
    self.registerPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.registerPhoneTextField.delegate = self;
    
    //注册:密码输入框
    self.registerPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.5*(ZFScreenW - 300 * ZFRatioW), CGRectGetMaxY(self.registerPhoneTextField.frame) + 10, 300 * ZFRatioW, 44 *ZFRatioH)];
    self.registerPasswordTextField.background = [UIImage imageNamed:@"textFieldBackground"];
    self.registerPasswordTextField.secureTextEntry = YES;
    self.registerPasswordTextField.font = [UIFont systemFontOfSize:13.0];
    self.registerPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.registerPasswordTextField.attributedPlaceholder = [NSString changePlaceholderAttributes:@"请输入密码"];
    self.registerPasswordTextField.delegate = self;
    [self addSubview:self.registerPasswordTextField];
    UIImageView *registerLeftKeyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.registerPhoneTextField.frame.size.height - 20)*0.5, 40, 20)];
    registerLeftKeyImgView.image = [UIImage imageNamed:@"key"];
    registerLeftKeyImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.registerPasswordTextField.leftView = registerLeftKeyImgView;
    self.registerPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //注册:注册按钮
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.registerPasswordTextField.frame), CGRectGetMaxY(self.registerPasswordTextField.frame) + 20, 300 * ZFRatioW, 44 * ZFRatioH)];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.registerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.enabled = NO;
    [self.registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.registerBtn];
    
    //注册:立即登录按钮
    UIButton *loginImmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginImmBtn.frame = CGRectMake(0.5 *(ZFScreenW - 80 * ZFRatioW), CGRectGetMaxY(self.registerBtn.frame) + 20, 80 * ZFRatioW, 30 * ZFRatioW);
    [loginImmBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    loginImmBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [loginImmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginImmBtn addTarget:self action:@selector(loginImmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginImmBtn];
    
    //登录界面图标
    self.loginSignPicImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ZFScreenW + 0.5*(ZFScreenW - 100 *ZFRatioW), 0, 100 * ZFRatioW, 100 * ZFRatioH)];
//    self.loginSignPicImgView.backgroundColor = [UIColor cyanColor];
    self.loginSignPicImgView.image = [UIImage imageNamed:@"MoveStall_registerSignPicImgView"];
    self.loginSignPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.loginSignPicImgView];
    
    //登录:手机输入框
    self.loginPhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(ZFScreenW + 0.5*(ZFScreenW - 300 * ZFRatioW), CGRectGetMaxY(self.loginSignPicImgView.frame) + 10, 300 * ZFRatioW, 44 *ZFRatioH)];
    self.loginPhoneTextField.background = [UIImage imageNamed:@"textFieldBackground"];
    self.loginPhoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.loginPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.loginPhoneTextField.font = [UIFont systemFontOfSize:13.0];
    self.loginPhoneTextField.attributedPlaceholder = [NSString changePlaceholderAttributes:@"请输入手机号码"];
    [self addSubview:self.loginPhoneTextField];
    UIImageView *loginLeftPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.loginPhoneTextField.frame.size.height - 20)*0.5, 40, 20)];
    loginLeftPhoneImgView.image = [UIImage imageNamed:@"phone"];
    loginLeftPhoneImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.loginPhoneTextField.leftView = loginLeftPhoneImgView;
    self.loginPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.loginPhoneTextField.delegate = self;
    
    //登录:密码输入框
    self.loginPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(ZFScreenW +  0.5*(ZFScreenW - 300 * ZFRatioW), CGRectGetMaxY(self.loginPhoneTextField.frame) + 10, 300 * ZFRatioW, 44 *ZFRatioH)];
    self.loginPasswordTextField.background = [UIImage imageNamed:@"textFieldBackground"];
    self.loginPasswordTextField.secureTextEntry = YES;
    self.loginPasswordTextField.font = [UIFont systemFontOfSize:13.0];
    self.loginPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.loginPasswordTextField.attributedPlaceholder = [NSString changePlaceholderAttributes:@"请输入密码"];
    self.loginPasswordTextField.delegate = self;
    [self addSubview:self.loginPasswordTextField];
    UIImageView *loginLeftKeyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.registerPhoneTextField.frame.size.height - 20)*0.5, 40, 20)];
    loginLeftKeyImgView.image = [UIImage imageNamed:@"key"];
    loginLeftKeyImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.loginPasswordTextField.leftView = loginLeftKeyImgView;
    self.loginPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //登录:登录按钮
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loginPasswordTextField.frame), CGRectGetMaxY(self.loginPasswordTextField.frame) + 20, 300 * ZFRatioW, 44 * ZFRatioH)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.enabled = NO;
    [self.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginBtn];
    
    //登录:立即注册按钮
    UIButton *registerImmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerImmBtn.frame = CGRectMake(ZFScreenW + 0.5 *(ZFScreenW - 80 * ZFRatioW), CGRectGetMaxY(self.loginBtn.frame) + 20, 80 * ZFRatioW, 30 * ZFRatioW);
    [registerImmBtn addTarget:self action:@selector(registerImmBtn) forControlEvents:UIControlEventTouchUpInside];
    [registerImmBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerImmBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [registerImmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:registerImmBtn];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
