//
//  ZFScrollView.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/18.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFScrollView : UIScrollView

/**注册按钮*/
@property(nonatomic,strong) UIButton *registerBtn;
/**注册:手机输入框*/
@property(nonatomic,strong) UITextField *registerPhoneTextField;
/**注册:密码输入框*/
@property(nonatomic,strong) UITextField *registerPasswordTextField;

/**登录按钮*/
@property(nonatomic,strong) UIButton *loginBtn;
/**登录:手机输入框*/
@property(nonatomic,strong) UITextField *loginPhoneTextField;
/**登录:密码输入框*/
@property(nonatomic,strong) UITextField *loginPasswordTextField;

@end
