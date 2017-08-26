//
//  MeViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/19.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "MeViewController.h"
#import "CollectionViewController.h"
#import "UseUserDefault.h"
#import "AppDelegate.h"
#import "AboutUsViewController.h"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**显示用户账户名*/
@property(nonatomic,strong) UILabel  *user_nameLB;
/**头像按钮*/
@property(nonatomic,strong) UIButton *user_icon;

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置控件
    [self setupControls];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *user_phone = [UseUserDefault getUser_PhoneFromUserDefault];
    //已经登录情况下
    if (user_phone) {
        [self.user_icon setImage:[UIImage imageNamed:@"headPic.jpg"] forState:UIControlStateNormal];
        self.user_icon.userInteractionEnabled = NO;
        self.user_nameLB.text = [NSString stringWithFormat:@"用户:%@",user_phone];
    }
    //未登录
    else
    {
        [self.user_icon setImage:[UIImage imageNamed:@"placehoderPic"] forState:UIControlStateNormal];
        self.user_nameLB.text = @"请先登录!";
    }
    [self.tableView reloadData];
}

-(void)setupControls
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //navigationBar设置为透明的
    UIImage *backgroundImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //navigationBar下面的黑线隐藏掉
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //设置status文字状态为默认
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZFScreenW, 300 * ZFRatioH)];
    topView.backgroundColor = [UIColor orangeColor];
    
    UIImageView *backgroundImg = [[UIImageView alloc] initWithFrame:topView.frame];
    backgroundImg.image = [UIImage imageNamed:@"timg.jpeg"];
    [topView addSubview:backgroundImg];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.5 * (ZFScreenW - 100 * ZFRatioW), 0.5 * (CGRectGetHeight(topView.frame) - 100 * ZFRatioW), 100 * ZFRatioW, 100 * ZFRatioW)];
    self.user_icon = btn;
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(0.5 * (ZFScreenW - 200 * ZFRatioW), CGRectGetMaxY(btn.frame), 200 * ZFRatioW, 50 * ZFRatioH)];
    self.user_nameLB = nameLb;
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.font = [UIFont systemFontOfSize:14.0];
    nameLb.textColor = [UIColor blackColor];
    
    NSMutableDictionary *dict = [UseUserDefault getValueFromUserDefault:[@[@"user_phone"] copy]];
    //已经登录情况下
    if (dict[@"user_phone"]) {
        [btn setImage:[UIImage imageNamed:@"headPic.jpg"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        nameLb.text = [NSString stringWithFormat:@"用户:%@",dict[@"user_phone"]];
    }
    //未登录
    else
    {
        [btn setImage:[UIImage imageNamed:@"placehoderPic"] forState:UIControlStateNormal];
        nameLb.text = @"请先登录!";
    }
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = CGRectGetWidth(btn.frame) * 0.5;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.masksToBounds = YES;
    
    [topView addSubview:nameLb];
    [topView addSubview:btn];
    
    [self.view addSubview:topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ZFScreenW, ZFScreenH) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ZFCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

-(instancetype)init
{
    if (self = [super init]) {
        self.navigationItem.title = @"我的主页";
        self.tabBarItem.image = [UIImage imageNamed:@"nomalMe"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"selectMe"];
        self.tabBarItem.title = @"我的";
    }
    return self;
}

#warning 头像点击也可以登录，处理这里
-(void)btnAction
{
    NSLog(@"btnAction");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZFCell"];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"关于我们";
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell.textLabel.text = @"我的收藏";
    }
    else
    {
        NSString *user_phoneStr = [UseUserDefault getUser_PhoneFromUserDefault];
        if (user_phoneStr) {
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.text = @"退出登录";
        }
        else
        {
            cell.textLabel.textColor = [UIColor brownColor];
            cell.textLabel.text = @"登录";
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        NSString *user_phoneStr = [UseUserDefault getUser_PhoneFromUserDefault];
        if (user_phoneStr) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录吗?" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"退出登录！！！！！");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //清空UserDefault
                    [UseUserDefault deleteValueFromUserDefault:[@[
                                                                  @"user_phone",
                                                                  @"user_token",
                                                                  @"user_deadline",
                                                                  @"user_stallOnline"
                                                                  ] mutableCopy]];
                });
                [self signOutCode];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:okAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
            [self signOutCode];
        }
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        aboutUsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}


/**
 退出登录处理代码
 */
-(void)signOutCode
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeLocation" object:nil userInfo:nil];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RegisterViewController *registerVC = appdelegate.registerVC;
    
    [self presentViewController:registerVC animated:YES completion:nil];
}

@end
