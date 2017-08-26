//
//  HandleCoreData.h
//  MoveStall
//
//  Created by HZhenF on 2017/8/3.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class AppDelegate,StallInfoModel;

@interface HandleCoreData : NSObject

/**
 查询本地数据库所有数据
 
 @param appdelegate AppDelegate实例
 */
+(NSArray *)queryAllDataFromDatabase:(AppDelegate *)appdelegate;



/**
 插入数据到本地数据库
 
 @param appdelegate AppDelegate实例
 @param stallInfoModel StallInfoModel实例
 */
+(void)insertDataToDatabase:(AppDelegate *)appdelegate stallInfoModel:(StallInfoModel *)stallInfoModel;


/**
 从本地数据库删除对应的数据
 
 @param appdelegate AppDelegate实例
 @param stallInfoModel StallInfoModel实例
 */
+(void)deleteDataFromDatabase:(AppDelegate *)appdelegate stallInfoModel:(StallInfoModel *)stallInfoModel;

@end
