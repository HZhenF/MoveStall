//
//  AppDelegate.h
//  MoveStall
//
//  Created by HZhenF on 2017/7/10.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JudgeViewController.h"
#import "RegisterViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) NSManagedObjectContext *context;

@property(nonatomic,strong) NSManagedObjectModel *model;

@property(nonatomic,strong) NSPersistentStoreCoordinator *store;

//@property(nonatomic,strong) JudgeViewController *tabbarVC;

@property(nonatomic,strong) RegisterViewController *registerVC;

-(void)saveContext;

@end

