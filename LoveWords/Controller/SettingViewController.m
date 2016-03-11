//
//  SettingViewController.m
//  LoveWords
//
//  Created by Ibokan on 16/1/5.
//  Copyright © 2016年 yulu. All rights reserved.
//

#import "SettingViewController.h"
#import "DataManager.h"
#import "ConstantDef.h"
#import "AppDelegate.h"
#import "ConstantDef.h"
#import "UIButton+WebCache.h"
#import "MainPageViewController.h"
@interface SettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *buttonOfHeadImage;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfNickName;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfSex;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfSign;
@property (strong, nonatomic) IBOutlet UITextField *textFieldOfNickName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControlOfSex;
@property (strong, nonatomic) IBOutlet UITextView *textViewOfSign;


@property (strong, nonatomic) IBOutlet UIButton *buttonOfCommit;

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) DataManager *manager;
@property (nonatomic,copy) NSString *imageStr;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,assign) int count;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//初始化
    self.count=0;
//初始化Manager
    self.manager=[DataManager shareManager];
   // [self getPersaonalInfo];
    self.buttonOfHeadImage.layer.cornerRadius=40;
    self.buttonOfHeadImage.clipsToBounds=YES;

    
//初始化imagePicker
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
//图片是否可以编辑
    self.picker.allowsEditing = YES;
//设置提交按钮圆角
    self.buttonOfCommit.layer.cornerRadius=8;
    self.buttonOfCommit.clipsToBounds=YES;

//获取个人信息
    [self getPersaonalInfo];



}
-(void)getPersaonalInfo
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];
 
   [self.manager requestGetPersonalInfoWithToken:token Complention:^(NSString *code, NSString *result, UserInfo *userInfo) {

//重新设置界面
       [self.buttonOfHeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.userHeadImageUrl] forState:UIControlStateNormal];
     
       _imageStr=userInfo.userHeadImageUrl;
       
       self.textFieldOfNickName.text=userInfo.userName;
       if ([userInfo.userSex isEqualToString:@"0"])
       {
           self.segmentedControlOfSex.selectedSegmentIndex=0;
           self.sex=@"0";
       }
       else
       {
           self.segmentedControlOfSex.selectedSegmentIndex=1;
           self.sex=@"1";
       }
       self.textViewOfSign.text=userInfo.userAutograph;
       
   }];
    

  
}

- (IBAction)tapSegmentedControlOfSex:(UISegmentedControl *)sender
{  //男
    if (sender.selectedSegmentIndex==0)
    {
        self.sex=@"0";
      
    }
    //女
    else if(sender.selectedSegmentIndex==1)
    {
        self.sex=@"1";
     
    }
}


- (IBAction)tapButtonOfHeadImage:(UIButton *)sender
{
    //设置资源为相册
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];

}

//选择照片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //取出编辑之后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将图片转换成字符串
    NSData *data=UIImageJPEGRepresentation(image, 1.0f);
    
    [_manager requestUploadWithFiles:data Complention:^(NSString *code, NSString *url){
    
        self.count+=1;
        
        _imageStr=[NSString stringWithString:url];
     
        NSLog(@"设置界面上传的头像=%@",self.imageStr);
       

    }];
  
    
    [self.buttonOfHeadImage setBackgroundImage:image forState:UIControlStateNormal];
    
//选择完成之后,关闭选择界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

//点击了取消,也需要关闭选择界面

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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



- (IBAction)tapButtonOfCommit:(UIButton *)sender
{
if ([self.textFieldOfNickName.text isEqualToString:@""] || [self.textViewOfSign.text isEqualToString:@""])
    {
        SHOW_TEXT(@"请完善信息...")
        return;
    }

else if (self.count == 0) {
        SHOW_TEXT(@"请等待图片上传后,再次点击提交...");
        return;
    }
else if (self.textFieldOfNickName.text&&self.textViewOfSign.text&&self.count==1)
    {
        
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *token=[user objectForKey:@"token"];
    //调用提交个人信息方法
            
    [_manager RequestSetPersonalInfoWithToken:token UserName:self.textFieldOfNickName.text UserHeadImageUrl:_imageStr UserSex:self.sex UserAutograph:self.textViewOfSign.text Complention:^(NSString *code, NSString *result, NSString *error){
            if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"])
            {
                     SHOW_TEXT(@"上传成功");
//成功后直接修改主界面的信息
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainPageViewController *mainVc = [tempAppDelegate.mainNavigationController.viewControllers firstObject];
                     
        mainVc.headImage = self.buttonOfHeadImage.currentBackgroundImage;
        mainVc.userName=self.textFieldOfNickName.text;
    [self.navigationController popViewControllerAnimated:YES];
                }
                 else
                 {
                     SHOW_TEXT(@"提交失败");
                 }
     }];
        
     }

}


//点击空白取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置左侧菜单

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
