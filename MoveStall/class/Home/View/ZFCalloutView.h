//
//  ZFCalloutView.h
//  MapKitPractice1
//
//  Created by HZhenF on 2017/7/1.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StallInfoModel.h"

@interface ZFCalloutView : UIView<UITableViewDelegate,UITableViewDataSource>
/**背景框*/
@property(nonatomic,strong) UIImageView *imageView;
/**tableView*/
@property(nonatomic,strong) UITableView *tableView;
/**顶部的View*/
@property(nonatomic,strong) UIView *topView;
/**收藏按钮*/
@property(nonatomic,strong) UIButton *collectionBtn;
/**商店名称*/
@property(nonatomic,strong) UILabel *stallNameLB;
/**当前小摊模型*/
@property(nonatomic,strong) StallInfoModel *stallInfoModel;


@end
