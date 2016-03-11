//
//  OtherViewController.m
//  LoveWords
//
//  Created by Ibokan on 16/1/11.
//  Copyright © 2016年 yulu. All rights reserved.
//

#import "OtherViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "ConstantDef.h"
#import "LoginViewController.h"
#import "EaseMob.h"
@interface OtherViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelOfLove;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfRemoveMatch;
@property (nonatomic,strong) DataManager *manager;
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化Manager
    self.manager=[DataManager shareManager];
}
- (IBAction)tapButtonOfRemoveMatch:(id)sender
{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"是否解除关系?" message:@"附注:相爱不易,请三思." preferredStyle:UIAlertControllerStyleAlert];
//取消alert
    UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (tempAppDelegate.leftSlideVC.closed)
        {
            [tempAppDelegate.leftSlideVC openLeftView];
        }
        else
        {
            [tempAppDelegate.leftSlideVC closeLeftView];
        }
    }];
//确认alert
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *token=[user objectForKey:@"token"];
        [self.manager requestRemoveMatchRelationWithToken:token Complention:^(NSString *code,NSString *result, NSString *error) {
            
            if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"]) {
                
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                NSString *matchStatus=[user objectForKey:@"matchStatus"];
                //NSLog(@"matcheStatus=%@",matchStatus);
                matchStatus=@"1";
                
                [user setObject:matchStatus forKey:@"matchStatus"];
                [user synchronize];
                SHOW_TEXT(@"解除成功");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FirstStoryboard" bundle:nil];
    UIViewController *vc= [sb instantiateViewControllerWithIdentifier:@"Nav"];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
          
    window.rootViewController = vc;
 
                //解除后退出到登陆界面并退出环信聊天
    [self.navigationController popToRootViewControllerAnimated:YES];
                //退出环信聊天
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                   // SHOW_TEXT(@"退出成功");
                } onQueue:nil];
                
                
            }
            
            
        }];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //这里是滑出左菜单
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.leftSlideVC.closed)
    {
        [tempAppDelegate.leftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
}

@end
