//
//  PitchViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/21.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "PitchViewController.h"
#import "UseUserDefault.h"

@interface PitchViewController ()<UITextViewDelegate>
/**小摊名称输入框*/
@property(nonatomic,strong) UITextField *stallName;
/**商品一输入框*/
@property(nonatomic,strong) UITextField *shopOneName;
/**商品一描述*/
@property(nonatomic,strong) UITextView *shopOneDes;
/**商品二名称*/
@property(nonatomic,strong) UITextField *shopTwoName;
/**商品二描述*/
@property(nonatomic,strong) UITextView *shopTwoDes;
/**UITextView是否编辑过的标志*/
@property(nonatomic,assign) BOOL isEdit;

@end

@implementation PitchViewController

#pragma mark - 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    //基础控件设置
    [self setupBasicControls];
    //商品信息控件设置
    [self setupShopInfoControls];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - 返回按钮事件、输入框监听事件

-(void)submitBtnAction
{
    NSString *stallName = self.stallName.text;
    NSString *shopOneName = self.shopOneName.text;
    NSString *shopOneDes = self.shopOneDes.text;
    NSString *shopTwoName = self.shopTwoName.text;
    NSString *shopTwoDes = self.shopTwoDes.text;
    
    NSString *longtitude = [NSString stringWithFormat:@"%f",self.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",self.coordinate.latitude];
    
    //如果UITextView没有输入内容，就让其为空
    if(!self.isEdit)
    {
        shopOneDes = @"";
        shopTwoDes = @"";
    }
    
    NSMutableDictionary *dictM = [UseUserDefault getValueFromUserDefault:[@[
                                                                            @"user_token",
                                                                            @"user_phone"
                                                                            ] mutableCopy]];
    NSString *user_token = dictM[@"user_token"];
    NSString *user_phone = dictM[@"user_phone"];
    
    NSDictionary *jsonDict = @{@"stallInfo":@[
                                       @{@"stallName":stallName,@"shopName":shopOneName,@"shopDes":shopOneDes},
                                       @{@"stallName":stallName,@"shopName":shopTwoName,@"shopDes":shopTwoDes}
                                           ],
                               @"user_token":user_token,
                               @"longtitude":longtitude,
                               @"latitude":latitude,
                               @"user_phone":user_phone,
                               @"user_stallOnline":@(1)
                               };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:HUD];
    HUD.label.text = @"请稍后...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    
        [PublicAPI requestForPitchParam:jsonString callback:^(id obj) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                CGRect myFrame = CGRectMake((ZFScreenW - 200 * ZFRatioW) * 0.5, (self.view.frame.size.height - 100 * ZFRatioH) *0.5, 200 * ZFRatioW, 100 * ZFRatioH);
                if ([obj[@"code"] isEqualToString:@"10004"]) {
                    
                    [HUD hideAnimated:YES];
                    
                    //设置为摆摊状态
                    [UseUserDefault setupUserDefault:@{
                                                       @"user_stallOnline":@"1"
                                                       }];

                    
                    [UILabel showTipsLabel:obj[@"msg"] fatherView:self.view myFrame:myFrame];
                    //延迟一秒销毁当前控制器
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:^{
                            //发送通知，请求小摊数据
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationForRequestStallInfo" object:nil userInfo:@{
                                                                                                                                                @"latitude":[NSString stringWithFormat:@"%f",self.coordinate.latitude],
                                                                                                                                                @"longtitude":[NSString stringWithFormat:@"%f",self.coordinate.longitude]
                                                                                                                                                        }];
                        }];
                    });
                }
                else
                {
                    [HUD hideAnimated:YES];
                    [UILabel showTipsLabel:@"摆摊失败,请重新尝试!" fatherView:self.view myFrame:myFrame];
                }
            });
        }];
}

-(void)limitString:(UITextField *)textField
{
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
}

-(void)backBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextViewDelegate代理
/**
 将要开始编辑
 @param textView textView
 @return BOOL
 */
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

/**
 开始编辑
 @param textView textView
 */
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"不超过20字"]) {
        textView.text = @"";
        self.isEdit = YES;
        textView.textColor = [UIColor blackColor];
    }
}

/**
 结束编辑
 
 @param textView textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""] || [textView.text isEqualToString:@" "]) {
        textView.text = @"不超过20字";
        self.isEdit = NO;
        textView.textColor = ZFColor(161, 161, 161);
    }
}

/**
内容将要发生改变编辑 限制输入文本长度 监听TextView 点击了ReturnKey 按钮

@param textView textView
@param range    范围
@param text     text

@return BOOL
*/
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < 20)
    {
        self.isEdit = YES;
        return  YES;
        
    } else  if ([textView.text isEqualToString:@"\n"]) {
        
        //这里写按了ReturnKey 按钮后的代码
        return NO;
    }
    
    if (textView.text.length >= 20) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 自定义控件

/**
 商品信息控件设置
 */
-(void)setupShopInfoControls
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 25*ZFRatioW, 25*ZFRatioW)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //小摊名称
    self.stallName = [[UITextField alloc] initWithFrame:CGRectMake((ZFScreenW - 220*ZFRatioW)*0.5, CGRectGetMaxY(backBtn.frame) + 10, 220*ZFRatioW, 30*ZFRatioH)];
    self.stallName.background = [UIImage imageNamed:@"textFieldBackground"];
    self.stallName.clearButtonMode = UITextFieldViewModeAlways;
    self.stallName.attributedPlaceholder = [NSString changePlaceholderAttributes:@"不超过10字"];
    UIView *stallNameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    self.stallName.leftView = stallNameLeftView;
    self.stallName.leftViewMode = UITextFieldViewModeAlways;
    self.stallName.font = [UIFont systemFontOfSize:13.0];
    [self.stallName addTarget:self action:@selector(limitString:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.stallName];
    
    UILabel *stallNameLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.stallName.frame) - 80*ZFRatioW, CGRectGetMinY(self.stallName.frame), 80*ZFRatioW, CGRectGetHeight(self.stallName.frame))];
    stallNameLb.text = @"小摊名称:";
    stallNameLb.textColor = [UIColor whiteColor];
    stallNameLb.font = [UIFont systemFontOfSize:14];
    stallNameLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:stallNameLb];
    
    //商品一
    self.shopOneName = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.stallName.frame), CGRectGetMaxY(stallNameLb.frame) + 30, CGRectGetWidth(self.stallName.frame), 30*ZFRatioW)];
    self.shopOneName.font = [UIFont systemFontOfSize:13.0];
    self.shopOneName.background = [UIImage imageNamed:@"textFieldBackground"];
    self.shopOneName.clearButtonMode = UITextFieldViewModeAlways;
    self.shopOneName.attributedPlaceholder = [NSString changePlaceholderAttributes:@"不超过10字"];
    [self.shopOneName addTarget:self action:@selector(limitString:) forControlEvents:UIControlEventEditingChanged];
    UIView *shopOneNameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    self.shopOneName.leftView = shopOneNameLeftView;
    self.shopOneName.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.shopOneName];
    
    UILabel *shopOneNameLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(stallNameLb.frame), CGRectGetMinY(self.shopOneName.frame), CGRectGetWidth(stallNameLb.frame), 30*ZFRatioH)];
    shopOneNameLb.textAlignment = NSTextAlignmentCenter;
    shopOneNameLb.text = @"商品:";
    shopOneNameLb.textColor = [UIColor whiteColor];
    shopOneNameLb.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:shopOneNameLb];
    
    self.shopOneDes = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.shopOneName.frame), CGRectGetMaxY(self.shopOneName.frame) + 10, CGRectGetWidth(self.shopOneName.frame), 80)];
    self.shopOneDes.delegate = self;
    self.shopOneDes.text = @"不超过20字";
    self.shopOneDes.textColor = ZFColor(161, 161, 161);
    [self.view addSubview:self.shopOneDes];
    
    UILabel *shopOneDesLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(shopOneNameLb.frame), CGRectGetMinY(self.shopOneDes.frame), CGRectGetWidth(shopOneNameLb.frame), CGRectGetHeight(shopOneNameLb.frame))];
    shopOneDesLb.text = @"描述:";
    shopOneDesLb.textAlignment = NSTextAlignmentCenter;
    shopOneDesLb.textColor = [UIColor whiteColor];
    shopOneDesLb.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:shopOneDesLb];
    
    
    //商品二
    self.shopTwoName = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.shopOneName.frame), CGRectGetMaxY(self.shopOneDes.frame) + 30, CGRectGetWidth(self.shopOneName.frame), CGRectGetHeight(self.shopOneName.frame))];
    [self.shopTwoName addTarget:self action:@selector(limitString:) forControlEvents:UIControlEventEditingChanged];
    self.shopTwoName.background = [UIImage imageNamed:@"textFieldBackground"];
    self.shopTwoName.clearButtonMode = UITextFieldViewModeAlways;
    self.shopTwoName.attributedPlaceholder = [NSString changePlaceholderAttributes:@"不超过10字"];
    self.shopTwoName.font = [UIFont systemFontOfSize:13.0];
    UIView *shopTwoNameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    self.shopTwoName.leftView = shopTwoNameLeftView;
    self.shopTwoName.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.shopTwoName];
    
    
    UILabel *shopTwoNameLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(shopOneNameLb.frame),CGRectGetMinY(self.shopTwoName.frame),CGRectGetWidth(shopOneNameLb.frame),CGRectGetHeight(shopOneNameLb.frame))];
    shopTwoNameLb.text = @"商品:";
    shopTwoNameLb.textColor = [UIColor whiteColor];
    shopTwoNameLb.font = [UIFont systemFontOfSize:14];
    shopTwoNameLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:shopTwoNameLb];
    
    self.shopTwoDes = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.shopOneName.frame), CGRectGetMaxY(self.shopTwoName.frame) + 10, CGRectGetWidth(self.shopTwoName.frame), CGRectGetHeight(self.shopOneDes.frame))];
    self.shopTwoDes.delegate = self;
    self.shopTwoDes.text = @"不超过20字";
    self.shopTwoDes.textColor = ZFColor(161, 161, 161);
    [self.view addSubview:self.shopTwoDes];
    
    UILabel *shopTwoDesLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(shopTwoNameLb.frame), CGRectGetMinY(self.shopTwoDes.frame), CGRectGetWidth(shopTwoNameLb.frame), CGRectGetHeight(shopTwoNameLb.frame))];
    shopTwoDesLb.text = @"描述:";
    shopTwoDesLb.textAlignment = NSTextAlignmentCenter;
    shopTwoDesLb.textColor = [UIColor whiteColor];
    shopTwoDesLb.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:shopTwoDesLb];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake((ZFScreenW - 100*ZFRatioW)*0.5, CGRectGetMaxY(self.shopTwoDes.frame) + 20, 100, 50)];
    submitBtn.backgroundColor = ZFColor(255,153,18);
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [submitBtn setTitle:@"立即摆摊" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 10;
    submitBtn.layer.borderWidth = 1;
    submitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}


/**
 基础控件设置
 */
-(void)setupBasicControls
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"StallInsertBackground"];
    [self.view addSubview:bgView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [bgView addSubview:effectView];
    
}

@end
