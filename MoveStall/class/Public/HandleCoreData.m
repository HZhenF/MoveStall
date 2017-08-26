//
//  HandleCoreData.m
//  MoveStall
//
//  Created by HZhenF on 2017/8/3.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "HandleCoreData.h"
#import "AppDelegate.h"
#import "Entity.h"
#import "StallInfoModel.h"

@implementation HandleCoreData

+(NSArray *)queryAllDataFromDatabase:(AppDelegate *)appdelegate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:DBTableName];
    NSArray *arr = [appdelegate.context executeFetchRequest:request error:nil];
    return arr;
}

+(void)insertDataToDatabase:(AppDelegate *)appdelegate stallInfoModel:(StallInfoModel *)stallInfoModel
{
    Entity *md = [NSEntityDescription insertNewObjectForEntityForName:DBTableName inManagedObjectContext:appdelegate.context];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stallInfoModel];
    NSData *shopData = [NSKeyedArchiver archivedDataWithRootObject:stallInfoModel.stallInfo];
    md.stallInfo = data;
    md.stallShopInfo = shopData;
    [appdelegate saveContext];
}

+(void)deleteDataFromDatabase:(AppDelegate *)appdelegate stallInfoModel:(StallInfoModel *)stallInfoModel
{
    NSArray *arr = [HandleCoreData queryAllDataFromDatabase:appdelegate];
    for (Entity *entity in arr) {
        StallInfoModel *stallmd = [NSKeyedUnarchiver unarchiveObjectWithData:entity.stallInfo];
        if ([stallmd.user_phone isEqualToString:stallInfoModel.user_phone]) {
            [appdelegate.context deleteObject:entity];
            [appdelegate saveContext];
            return;
        }
    }
}

@end
