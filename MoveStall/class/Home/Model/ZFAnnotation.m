//
//  ZFAnnotation.m
//  MapKitPractice1
//
//  Created by HZhenF on 2017/6/28.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFAnnotation.h"

@implementation ZFAnnotation

-(ZFAnnotation *)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        self.coordinate = coordinate;
    }
    return self;
}

@end
