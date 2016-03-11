//
//  LoginViewController.m
//  LoveWords
//
//  Created by xitouzhu on 15/12/25.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingBaseViewController.h"
#import "MainPageViewController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "ConstantDef.h"
#import "telTool.h"
#import "MatchViewController.h"
#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "EaseMob.h"

#define kWith [[UIScreen mainScreen] bounds].size.width
typedef NS_ENUM(NSUInteger,ButtonType)
{
    ButtonTypeLogin,
    ButtonTypeRegister,
    ButtonTypeForget,
    
    
};

@interface LoginViewController ()
@property (strong, nonatomic) UIButton *ImageButton; //图片
@property (strong, nonatomic) UITextField *userName; //用户名
@property (strong, nonatomic) UITextField *passWord; //密码输入框
@property (strong, nonatomic) UIButton *loginButton; //登录按钮
@property (strong, nonatomic) UIButton *forgetButton; //忘记密码
@property (strong, nonatomic) UIButton *registerButton; //注册按钮
@property (strong,nonatomic)DataManager *manager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"登录";
    //设置背景图
    self.view.layer.contents = (__bridge id )([UIImage imageNamed:@"zhutou1"].CGImage);
    self.manager =[DataManager shareManager];
   [self createImageButton];
    [self createTextField];
    [self createTapButton];
    
}

#pragma mark -图片按钮的实现
- (void)createImageButton

{
    
    
     self.ImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ImageButton setImage:[UIImage imageNamed:@"imagebutton"] forState:UIControlStateNormal];
    self.ImageButton.frame = CGRectMake((kWith-80)/2, 155, 80,80 );
    self.ImageButton.enabled=NO;
    [self.view addSubview:self.ImageButton];
}

#pragma mark-点击按钮的实现
- (void)createTapButton
{
    //创建login按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(50, 341, kWith-100, 30);
    self.loginButton.backgroundColor = HMColor(30, 144, 255);
    self.loginButton.alpha = 0.6;
    self.loginButton.layer.cornerRadius=5;
    self.loginButton.tag = ButtonTypeLogin;
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(tapLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    //创建忘记密码按钮
    self.forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetButton.frame = CGRectMake(50, 386, 100, 20);
    [self.forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //self.forgetButton.alpha = 0.4;
    self.forgetButton.tag = ButtonTypeForget;
    [self.forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetButton addTarget:self action:@selector(tapLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetButton];
    
    //创建注册按钮
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.frame = CGRectMake(kWith-150, 386, 100, 20);
    [self.registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //self.forgetButton.alpha = 0.4;
    self.registerButton.tag = ButtonTypeRegister;
    [self.registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(tapLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
}
#pragma mark-点击按钮,进入界面
- (void)tapLoginButton:(UIButton *)sender
{
    switch (sender.tag) {
        case ButtonTypeLogin:
            [self Login];
                    break;
        case ButtonTypeForget:
            [self pushInStoryBoardWithString:@"ForgetViewController"];
            
            break;
        case ButtonTypeRegister:
            [self pushInStoryBoardWithString:@"RegisterViewController"];
            
            break;
        default:
            break;
    }
    
    
}
- (void)Login
{
  //获取注册时的账号密码
    
    
    
    if ([self.userName.text isEqualToString:@""])
    {
        SHOW_TEXT(@"没输入手机号码!");
    }
    
    else if (![telTool checkPhoneNumber:self.userName.text])
    {
        SHOW_TEXT(@"手机号码格式不对");
    }
    else if (![telTool checkPassword:self.passWord.text])
    {
        
        SHOW_TEXT(@"密码少于6位，请重新输入");
    }
    else 
        
    {
        [self.manager requestLoginWithTel:self.userName.text Password:self.passWord.text Complention:^(NSString *code,NSString *result,NSString *error,Account *account) {
//code=1请求成功,result=0,有数据
            
            NSLog(@"////%@,/////%@",[code class],[result class]);
            NSLog(@"code======%@,result=====%@",code,result);
            if ([code isEqualToString:@"400"])
            {
                SHOW_TEXT(@"请求失败");
            }
            else if ([result isEqualToString:@"1"])
            {
                
                SHOW_TEXT(error);
            }
            else if ([result isEqualToString:@"0"])
            {
            
//将信息存到本地            SHOW_TEXT(@"登录成功");
#pragma mark-将信息存到本地
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            NSString *tel=account.tel;
            [user setObject:tel forKey:@"tel"];
            NSString *infoStatus=account.infoStatus;
            [user setObject:infoStatus forKey:@"infoStatus"];
            NSString *matchStatus=account.matchStatus;
            [user setObject:matchStatus forKey:@"matchStatus"];
            NSString *token=account.token;
            [user setObject:token forKey:@"token"];
            NSString *userId=account.userId;
            [user setObject:userId  forKey:@"userId"];
            NSString *matchToken=account.matchToken;
            [user setObject:matchToken forKey:@"matchToken"];
            [user synchronize];
            
            NSLog(@"打印下matchStatus=%@",matchStatus);

            
            if ([infoStatus isEqualToString:@"1"])
            {
                
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
                SettingBaseViewController *sbVC=[sb instantiateViewControllerWithIdentifier:@"SettingBase"];
               
                [self.navigationController pushViewController:sbVC animated:YES];
                                
                
            }
            else if ([infoStatus isEqualToString:@"0"]&&[matchStatus isEqualToString:@"1"])
            {
                UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
                MatchViewController *sbVC=[sb instantiateViewControllerWithIdentifier:@"MatchVC"];
                [self.navigationController pushViewController:sbVC animated:YES];
            }
            else
            {
                
//推到主页面
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    MainPageViewController *mpVC=[sb instantiateViewControllerWithIdentifier:@"MainPage"];
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    delegate.mainNavigationController=[[UINavigationController alloc]initWithRootViewController:mpVC];
    LeftSortsViewController *leftVC=[[LeftSortsViewController alloc]init];
    delegate.leftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:delegate.mainNavigationController];
    delegate.window.rootViewController=delegate.leftSlideVC;
  
            }
    
//同时登陆聊天
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userId password:@"1234" completion:^(NSDictionary *loginInfo, EMError *error) {
                NSLog(@"环信...登陆成功,错误=%@",error);
    } onQueue:nil];
            
     }
        }];
   
        }
       
}



//推出页面
- (void)pushInStoryBoardWithString:(NSString *)string
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FirstStoryboard" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:string];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -textField的实现
- (void)createTextField
{
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(50, 260, kWith-100, 35)];
    self.userName.backgroundColor = [UIColor redColor];
    self.userName.layer.cornerRadius = 5;
    self.userName.alpha = 0.6;
    self.userName.placeholder=@"账号";
    self.userName.leftView = [self createLeftViewWithFrame:CGRectMake(0, 0, 40, 35) andImage:[UIImage imageNamed:@"zhanghao-zhu"]];
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.userName];
    
    //设置中间的线
    UIImageView *centerLine = [[UIImageView alloc]initWithFrame:CGRectMake(50, 295, kWith-100, 1)];
    centerLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerLine];
    
    self.passWord = [[UITextField alloc]initWithFrame:CGRectMake(50, 296, kWith-100, 35)];
    self.passWord.backgroundColor = [UIColor redColor];
    self.passWord.layer.cornerRadius = 5;
    self.passWord.alpha = 0.6;
    self.passWord.placeholder=@"密码";
    self.passWord.secureTextEntry=YES;
    
    self.passWord.leftView = [self createLeftViewWithFrame:CGRectMake(0, 0, 40, 35) andImage:[UIImage imageNamed:@"btn_mima"]];
    self.passWord.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.passWord];
}
#pragma mark -textfield中的leftView的实现
- (UIView *)createLeftViewWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    
    UIView *leftView = [[UIView alloc]initWithFrame:frame];
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 30, 29)];
    userImage.image = image;
    [leftView addSubview:userImage];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(37, 5, 1, 25)];
    line.backgroundColor = [UIColor whiteColor];
    [leftView addSubview:line];
    //leftView.backgroundColor = [UIColor redColor];
    return leftView;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;
    
}
//点击空白取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
