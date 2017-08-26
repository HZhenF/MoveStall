//
//  Entity.h
//  MoveStall
//
//  Created by HZhenF on 2017/8/2.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Entity : NSManagedObject
/**小摊模型(NSData类型)*/
@property (nonatomic, retain) NSData *stallInfo;
/**小摊信息模型(NSData类型)*/
@property (nonatomic, retain) NSData *stallShopInfo;

@end
