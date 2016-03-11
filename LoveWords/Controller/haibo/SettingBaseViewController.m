//
//  SettingBaseViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "SettingBaseViewController.h"
#import "MatchViewController.h"
#import "ConstantDef.h"
#import "DataManager.h"
#import "AFNetworking.h"
@interface SettingBaseViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *signature;
@property (weak, nonatomic) IBOutlet UIButton *sexOfButton;
@property (weak, nonatomic) IBOutlet UIButton *name;


@property(strong,nonatomic)UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIButton *setImageButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOfSex;


@property (strong, nonatomic) IBOutlet UITextView *textViewOfSign;

@property (weak, nonatomic) IBOutlet UIButton *referButton;

@property(strong,nonatomic)DataManager *manager;
@property(strong,nonatomic)NSString *imageStr;
@property (nonatomic,copy) NSString *sex;
@end

@implementation SettingBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设置";
   
    
//去掉导航条底部空白
    self.navigationController.hidesBottomBarWhenPushed=YES;
   
//设置返回按钮
    UIBarButtonItem *backButton=[UIBarButtonItem new];
    backButton.title=@" ";
    self.navigationItem.backBarButtonItem=backButton;
    
    //_imageStr=[NSString new];
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
//图片是否可以编辑
    self.picker.allowsEditing = YES;
    
    _manager=[DataManager shareManager];
   
//设圆角
    self.setImageButton.layer.cornerRadius=42;
//剪切多余的内容(了解),场景:当设置了圆角之后没有效果,则修改此属性为YES
    self.setImageButton.clipsToBounds = YES;
   
    self.referButton.layer.cornerRadius=5;
//segment
    self.segmentOfSex.selectedSegmentIndex=0;
    self.sex=@"0";
}

- (IBAction)tapSegmentOfSex:(UISegmentedControl *)sender
{ //0:男 1:女
    if (self.segmentOfSex.selectedSegmentIndex==0)
    {
        self.sex=@"0";
    }
    else
    {
        self.sex=@"1";
    }
}



//添加头像按钮
//推出imagePicker 选择图片作为头像
- (IBAction)imageButton:(UIButton *)sender
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
    NSData *data=UIImageJPEGRepresentation(image, 0.5f);
    [_manager requestUploadWithFiles:data Complention:^(NSString *code, NSString *url) {
        _imageStr=[NSString stringWithString:url];
        NSLog(@"BBBBBBBBBBBBBBBBBBBBBB%@",_imageStr);
//        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//        [user setObject:_imageStr forKey:@"imageStr"];
//        [user synchronize];
    }];
//    _imageStr=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self.setImageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //选择完成之后,关闭选择界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击了取消,也需要关闭选择界面

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交按钮
//上传个人信息
- (IBAction)referButton:(UIButton *)sender
{
    if ([_nameTextField.text isEqualToString:@""] || [_textViewOfSign.text isEqualToString:@""]||[self.imageStr isEqualToString:@""])
    {
        SHOW_TEXT(@"请完善信息...")
    }
    else
    {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];
        
        NSLog(@"%@",token);

//调用提交个人信息方法
        
    [_manager RequestSetPersonalInfoWithToken:token UserName:_nameTextField.text UserHeadImageUrl:_imageStr UserSex:self.sex UserAutograph:_textViewOfSign.text Complention:^(NSString *code, NSString *result, NSString *error)
    {
//八个人信息存到本地
        
       // [user synchronize];
        if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"])
        {
            //上传成功
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
            
            MatchViewController *vc=[sb instantiateViewControllerWithIdentifier:@"MatchVC"];
            [self.navigationController pushViewController:vc animated:YES];

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


@end
