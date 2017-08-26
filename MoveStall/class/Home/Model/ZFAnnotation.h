//
//  ZFAnnotation.h
//  MapKitPractice1
//
//  Created by HZhenF on 2017/6/28.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "StallInfoModel.h"

@interface ZFAnnotation : NSObject<MKAnnotation>
/**经纬度*/
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
/**标题*/
@property(nonatomic,copy) NSString *title;
/**副标题*/
@property(nonatomic,copy) NSString *subtitle;

/**对应商家的模型对象*/
@property(nonatomic,strong) StallInfoModel *stallInfoMd;

/**
 初始化经纬度

 @param coordinate 经纬度
 @return 当前对象
 */
-(ZFAnnotation *) initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
