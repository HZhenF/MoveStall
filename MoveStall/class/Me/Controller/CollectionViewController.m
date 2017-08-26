//
//  CollectionViewController.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/3.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "CollectionViewController.h"
#import "AppDelegate.h"
#import "StallInfoModel.h"
#import "StallShopModel.h"
#import "Entity.h"
#import "HandleCoreData.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) AppDelegate *appDelegate;
/**本地数据库所有数据*/
@property(nonatomic,strong) NSMutableArray *collectionArr;

@end

static NSString *cellID = @"ZFCollectionCell";

@implementation CollectionViewController

-(NSMutableArray *)collectionArr
{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray array];
    }
    return _collectionArr;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //查询本地数据库所有数据
    NSArray *arr = [HandleCoreData queryAllDataFromDatabase:self.appDelegate];
    self.collectionArr = [arr mutableCopy];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}  


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    //取出数据库数据
    Entity *entity = self.collectionArr[indexPath.row];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:entity.stallShopInfo];
    StallInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:entity.stallInfo];
    StallShopModel *shopModel = arr[0];
    cell.textLabel.text = shopModel.stall_name ;
    cell.detailTextLabel.text = model.user_phone;
    return cell;
}

//定义编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entity *entity = self.collectionArr[indexPath.row];
        StallInfoModel *stallmd = [NSKeyedUnarchiver unarchiveObjectWithData:entity.stallInfo];
        [HandleCoreData deleteDataFromDatabase:self.appDelegate stallInfoModel:stallmd];
        
        [self.collectionArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
