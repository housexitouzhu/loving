//
//  AppDelegate.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "LoginViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) LeftSlideViewController *leftSlideVC;
@property (nonatomic,strong) UINavigationController *mainNavigationController;

@property (nonatomic,strong) LoginViewController *loginVC;
@end

