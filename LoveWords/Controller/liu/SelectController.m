//
//  SelectController.m
//  LoveWords
//
//  Created by xitouzhu on 16/1/4.
//  Copyright © 2016年 yulu. All rights reserved.
//

#import "SelectController.h"
#import "NewFeatureViewController.h"
#import "SettingBaseViewController.h"
#import "MatchViewController.h"
#import "MainPageViewController.h"
#import "LoginViewController.h"

@implementation SelectController
+ (void)chooseRootViewController
{
    // 如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [user objectForKey:versionKey];
    
    
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) {
        
        // 当前版本号 == 上次使用的版本：
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        window.rootViewController = [[NewFeatureViewController alloc] init];
//        if ([info isEqualToString:@"1"])
//        {
//            window.rootViewController =[[SettingBaseViewController alloc]init];
//            
//        }
//        else if ([info isEqualToString:@"0"] &&[match isEqualToString:@"1"])
//        {
//            window.rootViewController=[[MatchViewController alloc] init];
//        }
//        else if([info isEqualToString:@"0"] &&[match isEqualToString:@"0"])
//        {
//
        
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"FirstStoryboard" bundle:[NSBundle mainBundle]];
        UIViewController  *nav =[sb instantiateViewControllerWithIdentifier:@"Nav"];
        window.rootViewController=nav;
        
}

else

{
        window.rootViewController = [[NewFeatureViewController alloc] init];
        
        // 存储这次使用的软件版本
        [user setObject:currentVersion forKey:versionKey];
        [user synchronize];
    }
}




@end
