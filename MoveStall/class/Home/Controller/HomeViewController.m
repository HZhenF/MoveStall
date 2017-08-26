//
//  HomeViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/19.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "HomeViewController.h"
#import "ZFAnnotationView.h"
#import "ZFAnnotation.h"
#import "ZFButton.h"
#import "PitchViewController.h"
#import "Entity.h"
#import "HandleCoreData.h"
#import "UseUserDefault.h"

#import <CoreLocation/CoreLocation.h>
#import <StoreKit/StoreKit.h>

#define bottomBar 44

@interface HomeViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
/**地图View*/
@property(nonatomic,strong) MKMapView *ZFMapView;
/**位置管理者*/
@property(nonatomic,strong) CLLocationManager *ZFLocationManager;
/**摆摊按钮*/
@property(nonatomic,strong) ZFButton *pitchBtn;
/**取消摆摊按钮*/
@property(nonatomic,strong) ZFButton *closeStallBtn;
/**所有小摊信息*/
@property(nonatomic,strong) NSMutableArray *allStallInfoArrM;
/**保存当前所有自定义大头针*/
@property(nonatomic,strong) NSMutableArray *stallAnnotationArrM;
/**计算移动300米的坐标点的数组*/
@property(nonatomic,strong) NSMutableArray *calculateMeterArrM;

@property(nonatomic,strong) AppDelegate *appDelegate;
/**判断是否启动程序*/
@property(nonatomic,assign) BOOL isLuanch;

@property(nonatomic,strong) MBProgressHUD *HomeHUD;

@property(nonatomic,assign) CGRect myFrame;

@end

@implementation HomeViewController

#pragma mark - 懒加载


-(MBProgressHUD *)HomeHUD
{
    if (!_HomeHUD) {
        _HomeHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _HomeHUD.label.text = @"加载中...";
        _HomeHUD.mode = MBProgressHUDModeIndeterminate;
        self.tabBarController.view.userInteractionEnabled = NO;
    }
    return _HomeHUD;
}

-(NSMutableArray *)calculateMeterArrM
{
    if (!_calculateMeterArrM) {
        _calculateMeterArrM = [NSMutableArray array];
    }
    return _calculateMeterArrM;
}

-(NSMutableArray *)stallAnnotationArrM
{
    if (!_stallAnnotationArrM) {
        _stallAnnotationArrM = [NSMutableArray array];
    }
    return _stallAnnotationArrM;
}

-(NSMutableArray *)allStallInfoArrM
{
    if (!_allStallInfoArrM) {
        _allStallInfoArrM = [NSMutableArray array];
    }
    return _allStallInfoArrM;
}

#pragma mark - 系统方法

-(void)dealloc
{
    NSLog(@"dealloc");
    //解除监听
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //重新设置按钮状态
    NSMutableDictionary *userDefault_dictM = [UseUserDefault getValueFromUserDefault:[@[
                                                                                        @"user_stallOnline"
                                                                                        ] mutableCopy]];
    NSString *stallOnline = userDefault_dictM[@"user_stallOnline"];
    int onlineFlat = [stallOnline intValue];
    self.pitchBtn.enabled = !onlineFlat;
    self.closeStallBtn.enabled = onlineFlat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置地图
    [self setupMap];
    
    //设置其他控件
    [self setupControls];
    
    //其余的一些设置
    [self setupOthers];
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    if ([self.isFreeLogin isEqualToString:@"0"]) {
        HUD.label.text = @"账号过期,请重新登录!";
        HUD.mode = MBProgressHUDModeText;
        [HUD hideAnimated:YES afterDelay:2];
    }
    else
    {
        [HUD hideAnimated:YES];
        return;
    }
    
}

-(instancetype)init
{
    if (self = [super init]) {
        self.tabBarItem.title = @"小摊";
        self.tabBarItem.image = [UIImage imageNamed:@"normalStall"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"selectStall"];
    }
    return self;
}

#pragma mark - 封装方法


/**
 让MBProgressHUD消失,并且恢复用户和手机的交互
 */
-(void)HUDDismiss
{
    self.tabBarController.view.userInteractionEnabled = YES;
    [_HomeHUD hideAnimated:YES];
    _HomeHUD = nil;
}

/**
 截取固定格式的字符串，从开头截取到固定的字符串位置
 
 @param str 要截取的字符串
 @param lastStr 截取的位置
 @return 截取完成的字符串
 */
-(NSString *)subStringWithFixFormatter:(NSString *)str lastStr:(NSString *)lastStr
{
    NSRange range = [str rangeOfString:lastStr options:NSBackwardsSearch];
    NSUInteger location = range.location;
    NSString *newStr = [str substringToIndex:location];
    return newStr;
}

/**
 更新当前位置
 
 @param currentCoor 当前坐标
 */
-(void)updateLocation:(CLLocationCoordinate2D)currentCoor
{
    NSString *user_coorLatitude = [NSString stringWithFormat:@"%f",currentCoor.latitude];
    NSString *user_coorLongtitude = [NSString stringWithFormat:@"%f",currentCoor.longitude];
    
    NSMutableDictionary *dictM = [UseUserDefault getValueFromUserDefault:[@[
                                                                            @"user_phone"
                                                                            ] mutableCopy]];
    NSString *user_phone = dictM[@"user_phone"];
    
    NSDictionary *coordinateDict = @{
                                     @"user_coorLatitude":user_coorLatitude,
                                     @"user_coorLongtitude":user_coorLongtitude,
                                     @"user_phone":user_phone
                                     };
    //更新自己当前的位置
    [PublicAPI requestForUpdateLocation:coordinateDict callback:^(id obj) {
        NSString *codeTips = obj[@"code"];
        if ([codeTips isEqualToString:@"10007"]) {
            NSLog(@"%@",obj[@"msg"]);
        }
    }];
}

/**
 计算距离
 
 @param start 其实位置
 @param end 结束位置
 @return 两者的距离
 */
- (double)calculateDistanceWithStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end {
    
    double meter = 0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude * M_PI / 180.0;
    double radLatitude2 = endLatitude * M_PI / 180.0;
    double a = fabs(radLatitude1 - radLatitude2);
    double b = fabs(startLongitude * M_PI / 180.0 - endLongitude * M_PI / 180.0);
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLatitude1) * cos(radLatitude2) * pow(sin(b/2),2)));
    s = s * 6378137;
    
    meter = round(s * 10000) / 10000;
    return meter;
}


/**
 数据转模型
 
 @param paramArr json数据数组
 @param callBack 回调方法
 */
-(void)dataToModel:(NSArray *)paramArr callBack:(void(^)(id obj))callBack
{
    // 转化为模型对象
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (NSDictionary *dict in paramArr)
    {
        StallInfoModel *model = [StallInfoModel StallInfoModelWithDict:dict];
        [tempArrM addObject:model];
    }
    callBack(tempArrM);
}


/**
 得到当前屏幕经纬度范围
 
 @param dict 当前坐标
 @return 屏幕经纬度范围
 */
-(NSDictionary *)getScreenRangePoint:(NSDictionary *)dict
{
    CGFloat latitude = [dict[@"latitude"] floatValue];
    CGFloat longtitude = [dict[@"longtitude"] floatValue];
    CLLocationCoordinate2D letfUpCoor = CLLocationCoordinate2DMake(latitude - 0.02, longtitude - 0.01);
    CLLocationCoordinate2D rightUpCoor = CLLocationCoordinate2DMake(latitude - 0.02, longtitude + 0.01);
    CLLocationCoordinate2D leftDownCoor = CLLocationCoordinate2DMake(latitude + 0.02, longtitude - 0.01);
    CLLocationCoordinate2D rightDownCoor = CLLocationCoordinate2DMake(latitude + 0.02, longtitude + 0.01);
    
//    NSLog(@"letfUpCoor = (%f,%f)",letfUpCoor.longitude,letfUpCoor.latitude);
//    NSLog(@"rightUpCoor = (%f,%f)",rightUpCoor.longitude,rightUpCoor.latitude);
//    NSLog(@"leftDownCoor = (%f,%f)",leftDownCoor.longitude,leftDownCoor.latitude);
//    NSLog(@"rightDownCoor = (%f,%f)",rightDownCoor.longitude,rightDownCoor.latitude);
    
    NSDictionary *coorDict = @{
                               @"letfUpCoorlatitude":[NSString stringWithFormat:@"%f",letfUpCoor.latitude],
                               @"letfUpCoorlongitude":[NSString stringWithFormat:@"%f",letfUpCoor.longitude],
                               @"rightUpCoorlatitude":[NSString stringWithFormat:@"%f",rightUpCoor.latitude],
                               @"rightUpCoorlongitude":[NSString stringWithFormat:@"%f",rightUpCoor.longitude],
                               @"leftDownCoorlatitude":[NSString stringWithFormat:@"%f",leftDownCoor.latitude],
                               @"leftDownCoorlongitude":[NSString stringWithFormat:@"%f",leftDownCoor.longitude],
                               @"rightDownCoorlatitude":[NSString stringWithFormat:@"%f",rightDownCoor.latitude],
                               @"rightDownCoorlongitude":[NSString stringWithFormat:@"%f",rightDownCoor.longitude]
                               
                               };
    
#warning 暂时不显示小摊范围
//
//    //开始绘制轨迹
//    CLLocationCoordinate2D pointsToUse[5];
//    pointsToUse[0] = letfUpCoor;
//    pointsToUse[1] = rightUpCoor;
//    pointsToUse[2] = rightDownCoor;
//    pointsToUse[3] = leftDownCoor;
//    pointsToUse[4] = letfUpCoor;
//    //调用 addOverlay 方法后,会进入 rendererForOverlay 方法,完成轨迹的绘制
//    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:5];
//    [self.ZFMapView addOverlay:lineOne];
    
    return coorDict;
}

/**
 向服务器请求满足条件的小摊信息
 
 @param params 当前屏幕内区域坐标范围
 */
-(void)getAllStallInfo:(NSDictionary *)params
{
    [PublicAPI requestForQueryAllStallInfo:params Callback:^(id obj)  {
        //查询全部小摊信息成功
        if ([obj[@"code"] isEqualToString:@"10006"])
        {
            //没有整理的数组数据
            NSArray *allStallInfoArr = obj[@"data"];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //清空之前所有数据
                [self.allStallInfoArrM removeAllObjects];
                [self.ZFMapView removeAnnotations:self.ZFMapView.annotations];
                [self.stallAnnotationArrM removeAllObjects];
            });
            
            //数据模型化
            [self dataToModel:allStallInfoArr callBack:^(id obj) {
                //保存模型数据
                self.allStallInfoArrM = obj;
                
                //把信息显示在地图上
                for (StallInfoModel *model in self.allStallInfoArrM)
                {
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSString *latitude = model.user_coorLatitude;
                        NSString *longtitude = model.user_coorLongtitude;
                        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([latitude floatValue], [longtitude floatValue]);
                        ZFAnnotation *stallAnotation = [[ZFAnnotation alloc] initWithCoordinate:coor];
                        
                        //回到主线程里面,添加自定义大头针
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            //把每个用户模型传进自定义大头针里面
                            stallAnotation.stallInfoMd = model;
                            [self.ZFMapView addAnnotation:stallAnotation];
                            //保存自定义大头针
                            [self.stallAnnotationArrM addObject:stallAnotation];
                        });
                    });
                    
                }
            }];
        }
    }];
}

#pragma mark - 通知事件

/**
 重新开启定位
 */
-(void)restartLocation
{
    [self.ZFLocationManager startUpdatingLocation];
}

/**
 关闭定位功能
 */
-(void)closeLocation
{
    [self.ZFLocationManager stopUpdatingLocation];
}

/**
 通知请求小摊数据
 
 @param notification 通知内容
 */
-(void)requestForQueryStallIno:(NSNotification *)notification
{
    NSDictionary *rangeCoordict = notification.userInfo;
    //当前屏幕经纬度范围
    NSDictionary *dict = [self getScreenRangePoint:rangeCoordict];
    //加载一次数据
    [self getAllStallInfo:dict];
}

/**
 通知显示提示信息
 
 @param notification 通知内容
 */
-(void)showCollectionTips:(NSNotification *)notification
{
    NSString *str = notification.userInfo[@"key"];
    StallInfoModel *model = notification.userInfo[@"obj"];
    //显示提示
    [UILabel showTipsLabel:str fatherView:self.view myFrame:self.myFrame];
    
    //加入对象到本地数据库
    if ([str isEqualToString:@"收藏成功!"]) {
        //先查询本地数据库是否有该信息
        NSArray *arr = [HandleCoreData queryAllDataFromDatabase:self.appDelegate];
        for (Entity *entity in arr) {
            StallInfoModel *stallmodel = [NSKeyedUnarchiver unarchiveObjectWithData:entity.stallInfo];
            if ([stallmodel.user_phone isEqualToString:model.user_phone]) {
                //如果存在该数据，就直接返回，不存储
                return;
            }
        }
        [HandleCoreData insertDataToDatabase:self.appDelegate stallInfoModel:model];
    }
    //从本地数据库删除数据
    else
    {
        [HandleCoreData deleteDataFromDatabase:self.appDelegate stallInfoModel:model];
    }
    
}

#pragma mark - 初始化设置


/**
 其余一些设置
 */
-(void)setupOthers
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.isLuanch = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCollectionTips:) name:@"showCollectionLabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForQueryStallIno:) name:@"notificationForRequestStallInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLocation) name:@"closeLocation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartLocation) name:@"restartLocation" object:nil];
}


/**
 设置控件
 */
-(void)setupControls
{
    ZFButton *pitchBtn = [[ZFButton alloc] initWithFrame:CGRectMake(ZFScreenW - 50*ZFRatioW - 10, ZFScreenH * 0.5, 60*ZFRatioW, 60*ZFRatioH)];
    [pitchBtn setTitleColor:ZFColor(214, 33, 25) forState:UIControlStateNormal];
    [pitchBtn setTitleColor:ZFColor(191, 191, 191) forState:UIControlStateDisabled];
    [pitchBtn setImage:[UIImage imageNamed:@"Stall"] forState:UIControlStateNormal];
    [pitchBtn setImage:[UIImage imageNamed:@"StallDisable"] forState:UIControlStateDisabled];
    [pitchBtn addTarget:self action:@selector(pitchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [pitchBtn setTitle:@"我要摆摊" forState:UIControlStateNormal];
    self.pitchBtn = pitchBtn;
    [self.view addSubview:pitchBtn];
    
    ZFButton *closeStallBtn = [[ZFButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(pitchBtn.frame), CGRectGetMaxY(pitchBtn.frame) + 10, CGRectGetWidth(pitchBtn.frame), CGRectGetHeight(pitchBtn.frame))];
    [closeStallBtn setTitle:@"取消摆摊" forState:UIControlStateNormal];
    [closeStallBtn setTitleColor:ZFColor(238, 178, 68) forState:UIControlStateNormal];
    [closeStallBtn setTitleColor:ZFColor(191, 191, 191) forState:UIControlStateDisabled];
    [closeStallBtn setImage:[UIImage imageNamed:@"closeStall"] forState:UIControlStateNormal];
    [closeStallBtn setImage:[UIImage imageNamed:@"closeStallDisable"] forState:UIControlStateDisabled];
    [closeStallBtn addTarget:self action:@selector(closeStallBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeStallBtn = closeStallBtn;
    [self.view addSubview:closeStallBtn];
    
    
    self.myFrame = CGRectMake((ZFScreenW - 200 * ZFRatioW) * 0.5, (self.view.frame.size.height - 100 * ZFRatioH) *0.5, 200 * ZFRatioW, 100 * ZFRatioH);
}

/**
 设置地图
 */
-(void)setupMap
{
    self.ZFMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ZFScreenW, ZFScreenH - bottomBar)];
    //设置用户的跟踪模式(跟踪位置和移动方向)
    self.ZFMapView.userTrackingMode = MKUserTrackingModeFollow;
    //地图类型
    self.ZFMapView.mapType = MKMapTypeStandard;
    //显示用户位置
    self.ZFMapView.showsUserLocation = YES;
    //设置代理
    self.ZFMapView.delegate = self;
    //显示交通路况
    self.ZFMapView.showsTraffic = YES;
    [self.view addSubview:self.ZFMapView];
    
    
    self.ZFLocationManager = [[CLLocationManager alloc] init];
    self.ZFLocationManager.delegate = self;
    //设置精确度
    self.ZFLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
#warning 恢复这个设置
    //超出一定范围时，调用相应代理方法
    self.ZFLocationManager.distanceFilter = 300.0f;
    self.ZFLocationManager.distanceFilter = 10;
    
    if ([self.ZFLocationManager   respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.ZFLocationManager requestWhenInUseAuthorization];
    }
    //开始更新位置
    [self.ZFLocationManager startUpdatingLocation];
    
}

#pragma mark - 按钮点击事件
/**
 关闭小摊事件
 */
-(void)closeStallBtnAction
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要取消摆摊吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //发送网络请求，取消摆摊
       NSMutableDictionary *dict = [UseUserDefault getValueFromUserDefault:[@[
                                                                              @"user_token"
                                                                              ] mutableCopy]];
        NSString *user_token = dict[@"user_token"];
        
        NSDictionary *jsonDict = @{
                                   @"user_token":user_token,
                                   @"user_stallOnline":@"0"
                                   };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [PublicAPI requestForCloseStallParam:jsonString callback:^(id obj) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if ([obj[@"code"] isEqualToString:@"10005"]) {
                    [UILabel showTipsLabel:@"取消成功!" fatherView:self.view myFrame:self.myFrame];
                    
                    //UserDefault设置取消摆摊状态
                    [UseUserDefault setupUserDefault:@{
                                                       @"user_stallOnline":@"0"
                                                       }];
                    
                    //重新设置按钮状态
                    NSMutableDictionary *dictM = [UseUserDefault getValueFromUserDefault:[@[
                                                                                            @"user_stallOnline"
                                                                                            ] mutableCopy]];
                    NSString *stallOnline = dictM[@"user_stallOnline"];
                    
                    int onlineFlat = [stallOnline intValue];
                    self.pitchBtn.enabled = !onlineFlat;
                    self.closeStallBtn.enabled = onlineFlat;
                    
                    NSDictionary *coorDict =@{
                                          @"latitude":[NSString stringWithFormat:@"%f",self.ZFMapView.userLocation.coordinate.latitude],
                                          @"longtitude":[NSString stringWithFormat:@"%f",self.ZFMapView.userLocation.coordinate.longitude]
                                          };
                    //得到当前屏幕经纬度范围
                    NSDictionary *dict = [self getScreenRangePoint:coorDict];
                    [self getAllStallInfo:dict];
                }
                else
                {
                    [UILabel showTipsLabel:@"操作失败!" fatherView:self.view myFrame:self.myFrame];
                }
            });
        }];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //不做处理
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


/**
 摆摊事件
 */
-(void)pitchBtnAction
{
   NSString *user_token = [UseUserDefault getUder_TokenFromUserDefault];
    //已经登录
    if (user_token) {
        
        [self HomeHUD];
        
        //去服务器判断内购是否到期
        [PublicAPI requestForCheckUpExpires_dateToken:user_token callback:^(id obj) {
            if ([obj[@"code"] isEqualToString:@"10010"]) {
                //1：未过期    -1过期
                if ([obj[@"dateFlag"] isEqualToString:@"1"]) {
                        PitchViewController *pitchVC = [[PitchViewController alloc] init];
                        pitchVC.coordinate = self.ZFMapView.userLocation.coordinate;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self HUDDismiss];
                        [self presentViewController:pitchVC animated:YES completion:nil];
                    });
                }
                //内购时间过期了,重新购买
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self HUDDismiss];
                    });
                    
                    //添加一个交易队列观察者
                    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                    //判断是否可进行支付
                    if ([SKPaymentQueue canMakePayments]) {
                        [self requestProductData:StallID];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UILabel showTipsLabel:@"不允许程序内付费!" fatherView:self.view myFrame:self.myFrame];
                        });
                    }
                }
            }
        }];
    }
    else
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.label.text = @"请先登录！";
        HUD.mode = MBProgressHUDModeText;
        [HUD hideAnimated:YES afterDelay:2.0];
    }
}

#pragma mark - MKMapViewDelegate代理

/**
 显示用户的位置，系统会自动调用，app在后台是不调用此方法
 
 @param mapView 地图View
 @param userLocation 用户位置
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLocation.title = @"我的位置";
}


/**
 创建大头针时调用,初始化大头针上方的视图。如果返回nil，就是系统默认的棒棒糖大头针
 
 @param mapView 地图
 @param annotation 当前创建好的大头针
 @return 设置好的大头针
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果返回空,代表大头针样式交由系统去管理(系统第一次运行是MKUserLocation类)
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    else if ([annotation isKindOfClass:[ZFAnnotation class]])
    {
        static NSString *ID = @"SellerAnnotation";
        ZFAnnotationView *annotationView = (ZFAnnotationView *)[self.ZFMapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (!annotationView) {
            annotationView = [[ZFAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
            annotationView.annotation = annotation;
            //不显示详情
            annotationView.canShowCallout = NO;
            
        }
        annotationView.annotation = annotation;
        annotationView.portraitImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icecream-%d",arc4random()%4]];
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    ZFAnnotationView *annotationView = (ZFAnnotationView *)view;
    annotationView.annotation = view.annotation;
    //显示一定区域范围
    MKCoordinateSpan span = self.ZFMapView.region.span;
    CLLocationCoordinate2D coor = annotationView.annotation.coordinate;
    [self.ZFMapView setRegion:MKCoordinateRegionMake(coor, span) animated:YES];
}

#pragma mark - CLLocationManagerDelegate代理


/**
 绘图
 
 @param mapView 地图
 @param overlay 即将要显示的对象
 @return 画好的形状
 */
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKPolyline class]]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polyLineView.lineWidth = 10; //折线宽度
        polyLineView.strokeColor = [UIColor redColor]; //折线颜色
        return (MKOverlayRenderer *)polyLineView;
#pragma clang diagnostic pop
    }
    return nil;
}

/**
 获取到新的位置信息时调用,在后台也会调用
 
 @param manager 位置管理者
 @param locations 最新的位置信息，位置信息越新，在数组的位置排得越后
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"locationManagerdidUpdateLocations");
    
    CLLocation *location = [locations lastObject];
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D currentCoor = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        NSDictionary *dict = @{
                               @"latitude":[NSString stringWithFormat:@"%f",currentCoor.latitude],
                               @"longtitude":[NSString stringWithFormat:@"%f",currentCoor.longitude]
                               };
        NSString *user_phoneStr = [UseUserDefault getUser_PhoneFromUserDefault];
        
        //刚启动就加载一次，如果经度小于70,就不属于中国的国界了
        if (self.isLuanch && currentCoor.longitude > 70) {
            NSLog(@"启动一次，更新位置，请求数据");
            
            //如果是用户身份
            if (user_phoneStr) {
                //更新当前位置
                [self updateLocation:currentCoor];
            }
            //回到当前定位,并且请求小摊数据
            [self locateMyPositionInMapAndRequestStallInfo:dict myCoor:currentCoor];
            
            self.isLuanch = NO;
        }
        
        NSValue *coorValue = [NSValue valueWithMKCoordinate:currentCoor];
        //超过300米就请求数据
        if (self.calculateMeterArrM.count == 0) {
            [self.calculateMeterArrM addObject:coorValue];
        }
        else
        {
            CLLocationCoordinate2D firstCoor = [self.calculateMeterArrM.firstObject MKCoordinateValue];
            //移动当前移动了多少米
            double meters = [self calculateDistanceWithStart:firstCoor end:currentCoor];
            NSLog(@"移动了%f米",meters);
            if (meters > 300) {
                [self.calculateMeterArrM removeAllObjects];
                [self.calculateMeterArrM addObject:coorValue];
                    NSLog(@"我要请求数据啦~~");
                //如果是用户身份
                if (user_phoneStr) {
                    //更新当前位置
                    [self updateLocation:currentCoor];
                }
                
                //回到当前定位,并且请求小摊数据
                [self locateMyPositionInMapAndRequestStallInfo:dict myCoor:currentCoor];
            }
        }
    }
    
#warning  内购测试，暂时停止位置更新
//    [self.ZFLocationManager stopUpdatingLocation];
}



/**
 回到当前定位,并且请求小摊数据
 
 @param dict 当前坐标
 */
-(void)locateMyPositionInMapAndRequestStallInfo:(NSDictionary *)dict myCoor:(CLLocationCoordinate2D)myCoor
{
    //让屏幕回到当前位置
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
    CLLocationCoordinate2D coor = myCoor;
    [self.ZFMapView setRegion:MKCoordinateRegionMake(coor, span) animated:YES
     ];
    
    //发送通知，请求小摊数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationForRequestStallInfo" object:nil userInfo:dict];
}

/**
 不能获取位置时候调用
 
 @param manager 位置管理者
 @param error 错误信息
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error = %@",[error description]);
    [UILabel showTipsLabel:@"您的网络出错,请重新打开app!" fatherView:self.view myFrame:self.myFrame];
}

/**
 定位服务状态改变时调用
 
 @param manager 位置管理者
 @param status 授权状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

#pragma mark - 内购代理方法

// 收到产品返回信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *productArr = response.products;
    
    if ([productArr count] == 0) {
        //        [SVProgressHUD dismiss];
        NSLog(@"没有该商品");
        return;
    }
    
    
    NSLog(@"productId = %@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量 = %zd",productArr.count);
    
    SKProduct *p = nil;
    
    for (SKProduct *pro in productArr) {
        NSLog(@"description:%@",pro.description);
        NSLog(@"localizedTitle:%@",pro.localizedTitle);
        NSLog(@"localizedDescription:%@",[pro localizedDescription]);
        NSLog(@"price:%@",[pro price]);
        NSLog(@"productIdentifier:%@",[pro productIdentifier]);
        NSLog(@"priceLocale:%@",pro.priceLocale);
        
        if ([pro.productIdentifier isEqualToString:StallID]) {
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    //发送内购请求
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



// 监听购买结果
- (void) paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"-----paymentQueue--------");
    
    for (SKPaymentTransaction *tran in transactions) {
        if (transactions.count > 1) {
            return;
        }
        switch (tran.transactionState) {
                //交易完成
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                self.HomeHUD.label.text = @"购买成功!";
                NSLog(@"从队列中删除商品");
                // 将交易从交易队列中删除
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                // 发送到苹果服务器验证凭证
                [self verifyPurchaseWithPaymentTrasaction];
                
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored: //购买过
                // 将交易从交易队列中删除
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSLog(@"购买过");
                // 发送到苹果服务器验证凭证
//                [self verifyPurchaseWithPaymentTrasaction];
                break;
            case SKPaymentTransactionStateFailed: //交易失败
                NSLog(@"交易失败");
                // 将交易从交易队列中删除
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [UILabel showTipsLabel:@"购买失败!" fatherView:self.view myFrame:self.myFrame];
                [self HUDDismiss];
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 内购封装方法

#warning 记得上架时候换回正式环境
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
// 验证购买
- (void)verifyPurchaseWithPaymentTrasaction
{
    NSLog(@"verifyPurchaseWithPaymentTrasaction");
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    // 发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //把“+”号全部用"ZFjiahao"代替
    NSString *newEncodeStr = [encodeStr stringByReplacingOccurrencesOfString:@"+" withString:@"ZFjiahao"];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\",\"password\" : \"%@\"}", encodeStr,shareSecret];
    NSString *payloadForMyServer = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\",\"password\" : \"%@\"}", newEncodeStr,shareSecret];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    urlRequest.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@",[error localizedDescription]);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self HUDDismiss];
            });
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *status = [NSString stringWithFormat:@"%@",dict[@"status"]];
            //验证成功
            if ([status isEqualToString:@"0"])
            {
                NSLog(@"status = %@",status);
                
                NSLog(@"购买次数:%lu",[dict[@"latest_receipt_info"] count]);
                
                //购买次数
                NSString *buy_frequency = [NSString stringWithFormat:@"%lu",[dict[@"latest_receipt_info"] count]];
                
                //取出最新的购买记录
                NSDictionary *currentReceiptDict = [dict[@"latest_receipt_info"] lastObject];
                //订单ID
                NSString *transaction_id = [NSString stringWithFormat:@"%@",currentReceiptDict[@"transaction_id"]];
                //购买时间
                NSString *purchase_date = currentReceiptDict[@"purchase_date"];
                purchase_date = [self subStringWithFixFormatter:purchase_date lastStr:@" "];
                
                //到期时间
                NSString *expires_date = currentReceiptDict[@"expires_date"];
                expires_date = [self subStringWithFixFormatter:expires_date lastStr:@" "];
                
                //字符串时间转NSDate
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *purchase_dateDate = [formatter dateFromString:purchase_date];
                NSDate *expires_dateDate = [formatter dateFromString:expires_date];
                //追加8个小时
                purchase_dateDate = [purchase_dateDate dateByAddingTimeInterval:60*60*8];
                expires_dateDate = [expires_dateDate dateByAddingTimeInterval:60*60*8];
                
                NSString *purchase_dateString = [formatter stringFromDate:purchase_dateDate];
                NSString *expires_dateString = [formatter stringFromDate:expires_dateDate];
                
                    NSString *user_token = [UseUserDefault getUder_TokenFromUserDefault];
                    [PublicAPI requestForStoreReceiptToServerToken:user_token receipt:payloadForMyServer purchase_date:purchase_dateString expires_date:expires_dateString buy_frequency:buy_frequency transaction_id:transaction_id callback:^(id obj) {
                        //凭据插入数据库成功
                        if ([obj[@"code"] isEqualToString:@"10009"]) {
                            NSLog(@"%@",obj[@"msg"]);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UILabel showTipsLabel:@"验证成功!" fatherView:self.view myFrame:self.myFrame];
                                [self HUDDismiss];
                            });
                        }
                    }];
            }
            else
            {
                [UILabel showTipsLabel:@"验证失败!" fatherView:self.view myFrame:self.myFrame];
            }
            
        }
    }] resume];
}


// 去苹果服务器请求产品信息
- (void)requestProductData:(NSString *)productId {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self HomeHUD];
    });

    NSLog(@"-------------请求对应的产品信息----------------");
    //根据商品ID查找商品信息
    NSArray *productArr = [[NSArray alloc] initWithObjects:productId, nil];
    //创建SKProductsRequest对象，用想要出售的商品的标识来初始化， 然后附加上对应的委托对象。
    //该请求的响应包含了可用商品的本地化信息。
    NSSet *productSet = [NSSet setWithArray:productArr];
    
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:productSet];
    
    request.delegate = self;
    [request start];
}

@end
