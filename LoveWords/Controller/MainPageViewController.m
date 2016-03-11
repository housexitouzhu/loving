//
//  ViewController.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//


#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "ConstantDef.h"
#import "SettingViewController.h"
#import "EaseMob.h"
//#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonOfMyImage;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfHerImage;
@property (strong, nonatomic) IBOutlet UILabel *labelOfMatchDate;
@property (strong, nonatomic) IBOutlet UILabel *labelOfMyName;
@property (strong, nonatomic) IBOutlet UILabel *labelOfHerName;
@property (nonatomic,strong) DataManager *manager;
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor purpleColor];

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"celan-lucien"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
//初始化Manager
    self.manager=[DataManager shareManager];
    
    [self getInfomation];
//设置头像button
    self.buttonOfMyImage.layer.cornerRadius=30;
    self.buttonOfMyImage.clipsToBounds=YES;
    self.buttonOfHerImage.layer.cornerRadius=30;
    self.buttonOfHerImage.clipsToBounds=YES;
    
//
 
  
}


-(void)getInfomation
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];
    //NSLog(@"获取token=%@",token);
                    
//配置主页关于我的信息
    [self.manager requestGetPersonalInfoWithToken:token Complention:^(NSString *code,NSString *result, UserInfo *userInfo) {
       
//使用子线程下载图片
        [self downLoadMyImage:userInfo];

        self.labelOfMyName.text=userInfo.userName;
        self.labelOfMyName.textColor=HMColor(229, 138, 142);
//从后台获取数据后,存到本地,以后会用到.
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:userInfo.userHeadImageUrl forKey:@"userHeadImageUrl"];
        [user synchronize];
    }];
//配置主页关于爱人的信息
    [self.manager requestGetLoverInfoWithToken:token Complention:^(NSString *code,NSString *result, LoverInfo *loverInfo) {

     
     
       [self downLoadHerImage:loverInfo];
        self.labelOfHerName.text=loverInfo.loverName;
        self.labelOfHerName.textColor=HMColor(229, 138, 142);

        NSString *matchData=[NSString stringWithFormat:@"恋爱日期:%@",loverInfo.loverMatchDate];
        self.labelOfMatchDate.text=matchData;
        self.labelOfMatchDate.textColor=HMColor(229, 138, 142);
       
//从后台获取数据后,存到本地,以后会用到.
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:loverInfo.loverId forKey:@"loverId"];
        [user setObject:loverInfo.loverHeadImageUrl forKey:@"loverHeadImageUrl"];
        [user synchronize];
    }];
}

//开启子线程去更新我的头像
-(void)downLoadMyImage:(UserInfo *)userInfo
{
//初始化一个子线程
    NSOperationQueue *queueOne=[[NSOperationQueue alloc]init];
    
    [queueOne addOperationWithBlock:^{
    
    
//在主队列更新UI
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
       
        [self.buttonOfMyImage sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.userHeadImageUrl] forState:UIControlStateNormal];
       // NSLog(@"我的头像=%@",userInfo.userHeadImageUrl);
        
           }];
    }];
    
    
}
//开启子线程去更新她的头像
-(void)downLoadHerImage:(LoverInfo *)loverInfo
{
    NSOperationQueue *queueOne=[[NSOperationQueue alloc]init];
    [queueOne addOperationWithBlock:^{
      
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
             // 生成图片
    [self.buttonOfHerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:loverInfo.loverHeadImageUrl] forState:UIControlStateNormal];
         }];
    }];
}




- (void) openOrCloseLeftList
{
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
    
    
//获取token
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];

    [self.manager requestGetPersonalInfoWithToken:token Complention:^(NSString *code, NSString *result, UserInfo *userInfo) {
        NSString *matchStatus=userInfo.userMatchStatus;
        if ([matchStatus isEqualToString:@"1"])
        {
            SHOW_TEXT(@"您已被解除配对,2s后自动退出.");
            
            [self performSelector:@selector(logout) withObject:nil afterDelay:3];
        }
    }];
    

}


-(void)logout
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"FirstStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *LoginVC=[sb instantiateViewControllerWithIdentifier:@"Nav"];
    [self presentViewController:LoginVC animated:YES completion:nil];
    //退出环信聊天
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        SHOW_TEXT(@"退出成功");
    } onQueue:nil];
}

//改变set方法
- (void)setHeadImage:(UIImage *)headImage
{
    UIImage *image = self.buttonOfMyImage.currentBackgroundImage;
    if ([headImage isEqual:image])
    {
        return;
    }
    [self.buttonOfMyImage setBackgroundImage:headImage forState:0];
}

-(void)setUserName:(NSString *)userName
{
    NSString *mainUserName=self.labelOfMyName.text;
    if ([userName isEqual:mainUserName]) {
        return;
    }
    self.labelOfMyName.text=userName;
}
@end
