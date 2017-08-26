//
//  ZFAnnotationView.h
//  MapKitPractice1
//
//  Created by HZhenF on 2017/6/30.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ZFCalloutView.h"
#import "ZFAnnotation.h"


@interface ZFAnnotationView : MKAnnotationView
/**头像*/
//@property (nonatomic, strong) UIImage     *portrait;
/**用户头像*/
@property (nonatomic, strong) UIImageView    *portraitImageView;
/**气泡*/
@property (nonatomic, strong) ZFCalloutView  *calloutView;

@property(nonatomic,strong) ZFAnnotation *annotation;

@end
