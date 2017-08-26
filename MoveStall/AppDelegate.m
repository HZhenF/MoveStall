//
//  AppDelegate.m
//  MoveStall
//
//  Created by HZhenF on 2017/7/10.
//  Copyright © 2017年 HuangZhenFeng. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "NoneNetworkViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize model = _model;
@synthesize context = _context;
@synthesize store = _store;

-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.context;
    if(context){
        //必须要有数据发生改变才去做数据库操作 避免多余的耗能
        if([context hasChanges]&&![context  save:&error]){
            NSLog(@"没有对数据库进行改变或者操作错误 %@",[error userInfo]);
            abort();
        }
    }
}

-(NSManagedObjectContext *)context
{
    if (!_context) {
        NSPersistentStoreCoordinator *store = self.store;
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = store;
    }
    return _context;
}

-(NSPersistentStoreCoordinator *)store
{
    NSError *error = nil;
    NSURL *storeURL = [[self applicatioDoucunmetnpats] URLByAppendingPathComponent:@"CollectionDB.sqlite"];
    if (!_store) {
        _store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    }
    if (![_store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"读取数据信息错误 %@",[error  userInfo]);
        abort();
    }
    return _store;
}

-(NSManagedObjectModel *)model
{
    if (!_model) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CollectionDB" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _model;
}

-(NSURL*)applicatioDoucunmetnpats{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(RegisterViewController *)registerVC
{
    if (!_registerVC) {
        _registerVC = [[RegisterViewController alloc] init];
    }
    return _registerVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //主线程休眠1秒，让LaunchImage多显示一会
//    [NSThread sleepForTimeInterval:1];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //占位控制器
    UIViewController *tempVC = [[UIViewController alloc] init];
    tempVC.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tempVC;
    [self.window makeKeyAndVisible];
    
    JudgeViewController *tabBarVC = [[JudgeViewController alloc] init];
    
    NoneNetworkViewController *noneNetVC = [[NoneNetworkViewController alloc] init];
    
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
            
            self.window.rootViewController = tabBarVC;
            [self.window makeKeyAndVisible];
            
            [tabBarVC resetAllWhenHaveNetWork];
            return ;
        }else
        {
            NSLog(@"没有网");
            
            self.window.rootViewController = noneNetVC;
            [self.window makeKeyAndVisible];
        }
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
