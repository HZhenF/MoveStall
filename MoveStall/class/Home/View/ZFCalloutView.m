//
//  ZFCalloutView.m
//  MapKitPractice1
//
//  Created by HZhenF on 2017/7/1.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "ZFCalloutView.h"
#import "StallShopModel.h"
#import "ZFTableViewCell.h"

static NSString *cellID = @"ZFCell";

@implementation ZFCalloutView

-(UIButton *)collectionBtn
{
    if (!_collectionBtn) {
        _collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, CGRectGetHeight(self.topView.frame))];
        [_collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_collectionBtn setBackgroundColor:ZFColor(71, 31, 31)];
//        [_collectionBtn setTitle:@"收藏小店" forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionSelect"] forState:UIControlStateSelected];
        [_collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        _topView.backgroundColor = [UIColor cyanColor];
    }
    return _topView;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.frame];
        _imageView.image = [UIImage imageNamed:@"archives_callout_bg"];
    }
    return _imageView;
}

-(UILabel *)stallNameLB
{
    if (!_stallNameLB) {
        _stallNameLB = [[UILabel alloc] initWithFrame:self.topView.frame];
        _stallNameLB.backgroundColor = ZFColor(71, 31, 31);
        _stallNameLB.textAlignment = NSTextAlignmentCenter;
        _stallNameLB.textColor = [UIColor whiteColor];
    }
    return _stallNameLB;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.topView.frame) + 5, self.bounds.size.width - 10, 90) style:UITableViewStylePlain];
        [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:cellID];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imageView];
        
        [self addSubview:self.topView];
        
        [self.topView addSubview:self.stallNameLB];
        [self.topView addSubview:self.collectionBtn];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(void)collectionBtnAction:(UIButton *)sender
{
    NSLog(@"collectionBtnAction");
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        NSString *collectSuccessfulStr = @"收藏成功!";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCollectionLabel" object:nil userInfo:@{@"key":collectSuccessfulStr,@"obj":self.stallInfoModel}];
        
    }
    else
    {
        NSString *collectCancelStr = @"取消收藏!";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCollectionLabel" object:nil userInfo:@{@"key":collectCancelStr,@"obj":self.stallInfoModel}];
    }
}


-(void)setStallInfoModel:(StallInfoModel *)stallInfoModel
{
    _stallInfoModel = stallInfoModel;
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stallInfoModel.stallInfo.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    StallShopModel *shopModel = self.stallInfoModel.stallInfo[indexPath.row];
    cell.goods_nameLB.text = shopModel.goods_name;
    cell.goods_descriptionLB.text = shopModel.goods_description;
    self.stallNameLB.text = shopModel.stall_name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

@end
