//
//  RegisterViewController.m
//  LoveWords
//
//  Created by xitouzhu on 15/12/25.
//  Copyright © 2015年 yulu. All rights reserved.
//


#import "RegisterViewController.h"
#import "DataManager.h"
#import "MBProgressHUD.h"
#import "telTool.h"
#import "ConstantDef.h"
#define kWith [[UIScreen mainScreen] bounds].size.width

@interface RegisterViewController ()

@property (strong, nonatomic) UITextField *userName; //用户名
@property (strong, nonatomic) UITextField *passWord; //密码输入框
@property (strong, nonatomic) UIButton *submitButton; //登录按钮
@property (strong,nonatomic)UITextField *code; //验证码
@property (strong,nonatomic)UIButton *sendCode;//验证码按钮
@property (strong,nonatomic)NSTimer *timer;
@property (assign,nonatomic)NSInteger count;
@property (strong,nonatomic) DataManager *manager;




@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //设置背景图
    self.view.layer.contents = (__bridge id )([UIImage imageNamed:@"zhutou2"].CGImage);
    self.manager=[DataManager shareManager];//单例初始化
    [self createSendCodeButton];
    [self createTextField];
    [self createTapButton];
    
}

#pragma mark -图片按钮的实现
- (void)createSendCodeButton


{
    
    
    self.sendCode = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.sendCode.frame = CGRectMake(kWith-110, 240+50, 60, 35);
    self.sendCode.backgroundColor = HMColor(146, 234, 217);
    self.sendCode.alpha = 0.8;
    self.sendCode.layer.cornerRadius=5;
    
    [self.sendCode setTitle:@"验证码" forState:UIControlStateNormal];
    [self.sendCode addTarget:self action:@selector(tapSendCodeButton) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.sendCode];
}
#pragma mark -点击获取验证码
-(void)tapSendCodeButton
{
    
    if ([self.userName.text isEqualToString:@""])
    {
        SHOW_TEXT(@"电话输入框不能为空!");
    }
    else if (![telTool checkPhoneNumber:self.userName.text])
    {
        SHOW_TEXT(@"手机号码格式不对");
        
    }
    else
    {
        
        self.count = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(functionTimer:) userInfo:nil repeats:YES];
       
            

        [self.manager requestSendCodeWithTel:self.userName.text Type: 0 Complention:^(NSString *code, NSString *result) {
            SHOW_TEXT(@"验证码发送成功");
            
        }];


}
}

#pragma mark-点击按钮的实现
- (void)createTapButton
{
    //创建提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(50, 300+50, kWith-100, 35);
    self.submitButton.backgroundColor =HMColor(146, 234, 217) ;
    self.submitButton.alpha = 0.8;
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(tapSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
   }
#pragma mark-点击按钮,进入界面
- (void)tapSubmitButton:(UIButton *)sender

{
    if ([self.userName.text isEqualToString:@""]) {
        SHOW_TEXT(@"没输入手机号码!");
    }
//    else if (![NSRegular checkPhoneNumber:self.phoneNumber.text])
    else if (![telTool checkPhoneNumber:self.userName.text])
    {
        SHOW_TEXT(@"手机号码格式不对");
    }
    else if (![telTool checkPassword:self.passWord.text])
    {
    
            SHOW_TEXT(@"密码少于6位，请重新输入");
            
     
        
    }
    else if(self.code.text.length!=6)
    {
        SHOW_TEXT(@"验证码格式不对");
    }
    else{
        

        
//          [self.navigationController popToRootViewControllerAnimated:YES];

        [self.manager requestRegisterWithTel:self.userName.text Code:self.code.text Password:self.passWord.text Completion:^(NSString *code, NSString *result, NSString *error) {
            SHOW_TEXT(@"注册成功");
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
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
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(50, 150+50, kWith-100, 35)];
    self.userName.backgroundColor = HMColor(146, 234, 217);
    self.userName.layer.cornerRadius = 10;
    self.userName.alpha = 0.8;
    self.userName.placeholder=@"请输入账号";
    self.userName.leftView = [self createLeftViewWithFrame:CGRectMake(0, 0, 40, 35) andImage:[UIImage imageNamed:@"btn_name"]];
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.userName];
    
   
    
    self.passWord = [[UITextField alloc]initWithFrame:CGRectMake(50, 195+50, kWith-100, 35)];
    self.passWord.backgroundColor = HMColor(146, 234, 217);
    self.passWord.layer.cornerRadius = 10;
    self.passWord.alpha = 0.8;
    self.passWord.placeholder=@"请输入密码";
    self.passWord.secureTextEntry=YES;
    self.passWord.leftView = [self createLeftViewWithFrame:CGRectMake(0, 0, 40, 35) andImage:[UIImage imageNamed:@"btn_mima"]];
    self.passWord.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.passWord];
    
    self.code = [[UITextField alloc]initWithFrame:CGRectMake(50, 240+50, kWith-170, 35)];
    self.code.backgroundColor = HMColor(146, 234, 217);
    self.code.layer.cornerRadius = 10;
    self.code.alpha = 0.8;
    self.code.placeholder=@"请输入验证码";
    self.code.leftView = [self createLeftViewWithFrame:CGRectMake(0, 0, 40, 35) andImage:[UIImage imageNamed:@"btn_mima"]];
    self.code.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.code];
    
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


#pragma mark -定时器的方法
- (void)functionTimer:(NSTimer *)timer
{
    self.count -= 1;
    [self.sendCode setTitle:[NSString stringWithFormat:@"(%ld秒)",(long)self.count] forState:UIControlStateNormal];
    [self.sendCode setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (self.count == 0) {
        [self.timer invalidate];
        [self.sendCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}





@end
