//
//  CheckViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "CheckViewController.h"
#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ConstantDef.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "LeftSortsViewController.h"
#import "MainPageViewController.h"
@interface CheckViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *macthButton;
@property (weak, nonatomic) IBOutlet UIButton *sweepButton;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(strong,nonatomic)DataManager *manager;
@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"校验码";
    self.navigationItem.titleView.backgroundColor=[UIColor redColor];
    self.navigationController.hidesBottomBarWhenPushed=YES;
    self.macthButton.layer.cornerRadius=13;
    self.sweepButton.layer.cornerRadius=13;
    self.messageTextField.placeholder=@"短信验证码";
    
    //设置返回按钮
    UIBarButtonItem *backButton=[UIBarButtonItem new];
    backButton.title=@" ";
    self.navigationItem.backBarButtonItem=backButton;
    
    _manager=[DataManager shareManager];
}



- (IBAction)matchButton:(id)sender
{
//    //正则表达式验证6位验证码
//  if([self checkMessageNumber:_messageTextField.text])
//  {
      //调用配对方法
      NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
      NSString *token=[user objectForKey:@"token"];
    NSLog(@"+++++++++%@,___---------------%@",token,_messageTextField.text);

          [_manager requestMatchWithToken:token MatchToken:_messageTextField.text Complention:^(NSString *code, NSString *result, NSString *error) {
              if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"]) {
                  
                  SHOW_TEXT(@"匹配成功");
//本地存储匹配状态
      
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *matchStatus=[user objectForKey:@"matchStatus"];
    matchStatus =@"0";
    [user setObject:matchStatus forKey:@"matchStatus"];
    [user synchronize];
//跳转主界面
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
                  UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
        MainPageViewController *mainVC=[sb instantiateViewControllerWithIdentifier:@"MainPage"];
        delegate.mainNavigationController=[[UINavigationController alloc]initWithRootViewController:mainVC];
        LeftSortsViewController *leftVC=[[LeftSortsViewController alloc]init];
        delegate.leftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:delegate.mainNavigationController];
        delegate.window.rootViewController=delegate.leftSlideVC;
        [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
              }
              else{
                  SHOW_TEXT(@"请确认匹配码正确!");

              }
          }];

//  }
//  else{
//    SHOW_TEXT(@"请输入正确的6位验证码...");
//    }
  
}
//- (BOOL)checkMessageNumber:(NSString *)phone
//{
//    //正则表达式
//    NSString *pattern = @"\\d{6}$";
//    //创建一个谓词,一个匹配条件
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    //评估是否匹配正则表达式
//    BOOL isMatch = [pred evaluateWithObject:phone];
//    return isMatch;
//}
//点击空白取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)sweepButton:(id)sender
{
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
//    
//    ScanCodeViewController *vc=[sb instantiateViewControllerWithIdentifier:@"ScanCode"];
//    [self.navigationController pushViewController:vc animated:YES];

    // 1. 实例化拍摄设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3. 设置元数据输出
    // 3.1 实例化拍摄元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.3 设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 添加拍摄会话
    // 4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 4.2 添加会话输入
    [session addInput:input];
    // 4.3 添加会话输出
    [session addOutput:output];
    // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.bounds;
    // 5.2 将图层插入当前视图
    [self.view.layer insertSublayer:preview atIndex:100];
    
    self.previewLayer = preview;
    
    // 6. 启动会话
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        _messageTextField.text = obj.stringValue;
        //解码成一个人类可读的字符串
        NSLog(@"%@", obj.stringValue);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
