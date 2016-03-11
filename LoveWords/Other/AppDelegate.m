//
//  AppDelegate.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSlideViewController.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
#import "NewFeatureViewController.h"
#import "EaseMob.h"
#import "SelectController.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//配置环信聊天信息
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"beijingbkws#yangbinhuanxin" apnsCertName:@""];
    [[EaseMob sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
//配置那vagition的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"zhutou100"] forBarMetrics:UIBarMetricsDefault];
//初始化窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController=self.loginVC;
    [self.window makeKeyAndVisible];
    
    [SelectController chooseRootViewController];
//配置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    
    /**
     *  测试,直接登录
     */
    
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
//    MainPageViewController *mpVC=[sb instantiateViewControllerWithIdentifier:@"MainPage"];
//
//    self.mainNavigationController=[[UINavigationController alloc]initWithRootViewController:mpVC];
//    LeftSortsViewController *leftVC=[[LeftSortsViewController alloc]init];
//    self.leftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:self.mainNavigationController];
//    self.window.rootViewController=self.leftSlideVC;
//
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"15" password:@"1234" completion:^(NSDictionary *loginInfo, EMError *error) {
//        NSLog(@"环信...l登陆成功错误=%@",error);
//    } onQueue:nil];
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

@end
