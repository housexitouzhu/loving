//
//  GetSecretViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "GetSecretViewController.h"
#import <MessageUI/MessageUI.h>
#import "ConstantDef.h"
#import "2DBarcodeViewController.h"
#import "DataManager.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
#import "AppDelegate.h"
@interface GetSecretViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *saoMaButton;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property(strong,nonatomic) DataManager *manager;

@end

@implementation GetSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"获取码";
    self.navigationItem.titleView.backgroundColor=[UIColor redColor];
    self.navigationController.hidesBottomBarWhenPushed=YES;
   
    self.sendMessageButton.layer.cornerRadius=13;
    self.saoMaButton.layer.cornerRadius=13;

    
    //设置返回按钮
    UIBarButtonItem *backButton=[UIBarButtonItem new];
    backButton.title=@" ";
    self.navigationItem.backBarButtonItem=backButton;
    
 
    _manager=[DataManager shareManager];
    
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];

    NSString *matchToken=[user objectForKey:@"matchToken"];
    
    [_sendMessageButton setTitle:matchToken forState:UIControlStateNormal];
    
    
}


- (IBAction)tapButtonOfRefresh:(UIButton *)sender
{
    
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];
    
    [_manager requestRefreshMatchStatusWithToken:token Complention:^(NSString *code, NSString *result, NSString *error) {
        if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"]) {
        
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            NSString *matchStatus=[user objectForKey:@"matchStatus"];
            matchStatus =@"0";
            [user setObject:matchStatus forKey:@"matchStatus"];
            [user synchronize];
            
            //推到主页面
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
            MainPageViewController *mpVC=[sb instantiateViewControllerWithIdentifier:@"MainPage"];
            AppDelegate *delegate=[UIApplication sharedApplication].delegate;
            delegate.mainNavigationController=[[UINavigationController alloc]initWithRootViewController:mpVC];
            LeftSortsViewController *leftVC=[[LeftSortsViewController alloc]init];
            delegate.leftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:delegate.mainNavigationController];
            delegate.window.rootViewController=delegate.leftSlideVC;
        }
        else{
           
            SHOW_TEXT(@"请确认已配对,再次刷新!");
            
        }
    }];
    

}


//发送短信验证码
//调用系统短信
- (IBAction)sendMessageButton:(UIButton *)sender
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *tel=[user objectForKey:@"tel"];
    NSString *matchToken=[user objectForKey:@"matchToken"];

    _sendMessageButton.enabled=NO;
    
    
   [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(enable) userInfo:nil repeats:NO];

    
    NSString *MatchCode=[NSString stringWithFormat:@"您的配对验证码是%@",matchToken];
       [self showMessageView:[NSArray arrayWithObjects:tel,nil, nil] title:@"title" body:MatchCode];
}


-(void)enable
{
    _sendMessageButton.enabled=YES;
}
//实现代理方法MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
        {
            //信息传送成功
        
            SHOW_TEXT(@"发送成功!");
            break;
        }
        case MessageComposeResultFailed:
        {
            //信息传送失败
            SHOW_TEXT(@"发送失败!");
            break;
        }
        case MessageComposeResultCancelled:
        { //信息被用户取消传送
            SHOW_TEXT(@"发送被取消!");
            break;
        }
        default:
            break;
            
    }
}

//发短信
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"该设备不支持短信功能"delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)saoMaButton:(id)sender
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
    
    _DBarcodeViewController *vc=[sb instantiateViewControllerWithIdentifier:@"_DBarcode"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
