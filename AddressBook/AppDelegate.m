//
//  AppDelegate.m
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.dbPath = [self dataFilePath];
    [self createTable];
    
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *rootNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = rootNC;
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *) dataFilePath//应用程序的沙盒路径
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    return [document stringByAppendingPathComponent:@"AddressBook.sqlite"];
}

- (void)createTable
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    if (![fileManager fileExistsAtPath:myDelegate.dbPath]) {
        NSLog(@"还未创建数据库，现在正在创建数据库");
        if ([db open]) {
            
            [db executeUpdate:@"create table if not exists Class (CIndex INTEGER PRIMARY          KEY, classID char not null, boyNum integer, girlNum integer, introduction varchar ,imageUrl varchar)"];
            [db executeUpdate:@"create table if not exists Person (PIndex INTEGER PRIMARY          KEY, studentID char NOT NULL, name char NOT NULL, sex char, address varchar, birthday date, phoneNum char, shortPhoneNum char, QQ char, email char, type char, classID char, imageUrl varchar)"];
            
            [db close];
        }else{
            NSLog(@"database open error");
        }
    }
    NSLog(@"FMDatabase:---------%@-------%@",db,myDelegate.dbPath);
}

@end
