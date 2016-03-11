//
//  AddSayViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "AddSayViewController.h"
#import "AppDelegate.h"
#import "DynamicScrollView.h"
#import "DataManager.h"
#import "ConstantDef.h"
#import "MBProgressHUD.h"
@interface AddSayViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonOfSend;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfAddImage;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) DataManager *manager;
@property (nonatomic,strong) NSMutableString *strOfImageUrl;
@property (nonatomic,strong) NSMutableArray *marrImageUrl;
@property (nonatomic,assign) int count;
@end

@implementation AddSayViewController

{
    float width;
    float height;
    NSArray *images;
    DynamicScrollView *dynamicScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//初始化
    self.count=0;
//初始化可变字符串
    self.strOfImageUrl=[[NSMutableString alloc]initWithString:@""];
    self.marrImageUrl=[NSMutableArray array];
   // self.marrImageUrl =[]
//设置代理
    self.manager=[DataManager shareManager];
    self.imagePicker=[[UIImagePickerController alloc]init];
    self.imagePicker.delegate=self;
//图片是否可以编辑
    self.imagePicker.allowsEditing=YES;
    
    self.automaticallyAdjustsScrollViewInsets = false;
//获取屏幕的宽高
    UIScreen *screen = [UIScreen mainScreen];
    width = screen.bounds.size.width;
    height = screen.bounds.size.height;


    
    
    _scrollView.hidden = YES;
    //滑动视图的位置
    dynamicScrollView = [[DynamicScrollView alloc] initWithFrame:CGRectMake(0,145, width, 85) withImages:[images mutableCopy]];
    [self.view addSubview:dynamicScrollView];
}



#pragma mark-发表状态
- (IBAction)tapBarButtonOfSend:(UIBarButtonItem *)sender
{
  
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];
    
if ([self.textView.text isEqualToString:@""])
    {
        SHOW_TEXT(@"发表内容不能为空!");
        return;
    }
 
else if (self.count!=self.marrImageUrl.count)
    {
        SHOW_TEXT(@"图片上传中...")
        return;
    }
else if (self.marrImageUrl.count>9)
    {
        SHOW_TEXT(@"您最多能发9张图");
        return;
    }
else if (self.marrImageUrl.count>0&&self.marrImageUrl.count<9&&self.textView.text) {
    for (NSString *imageUrls in self.marrImageUrl)
    {
        
        [self.strOfImageUrl appendFormat:@"%@|",imageUrls];
        
    }
    
    NSLog(@"3333333333333%@",self.strOfImageUrl);
        [self.manager requestPublishStatusWithToken:token Type:@"image" Text:self.textView.text ImageUrls:self.strOfImageUrl Complention:^(NSString *code, NSString *result, NSString *error) {
            
            if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"])
            {

                SHOW_TEXT(@"图片发送成功");
                [self.navigationController popViewControllerAnimated:YES];

            }
        }];
    }
else if ([self.strOfImageUrl isEqualToString:@""]&&self.textView.text)
    {
        [self.manager requestPublishStatusWithToken:token Type:@"text" Text:self.textView.text ImageUrls:@"" Complention:^(NSString *code, NSString *result, NSString *error) {
        if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"])
            {
                SHOW_TEXT(@"文字发送成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    }
}



- (IBAction)tapButtonOfAddImage:(UIButton *)sender
{

    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ] ) {
            
            //设置picker的资源来源
            self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            //模态展示选择界面
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *action2  = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //设置资源为相册
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
//    UIAlertAction *action3  = [UIAlertAction actionWithTitle:@"胶卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        //设置资源为胶卷
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        [self presentViewController:self.imagePicker animated:YES completion:nil];
//    }];
    
    //取消按钮,在最下面,样式是cancle
    
    UIAlertAction *cancle =[UIAlertAction actionWithTitle:@"取消选择" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消相关的操作
        //默认会关闭该弹框
    } ];
    
    //创建弹框controller
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择照片来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加按钮到弹框controller上
    
    [controller addAction:action1];
    [controller addAction:action2];
//    [controller addAction:action3];
    [controller addAction:cancle];
    
    
    
    //弹出弹框
    
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma -mark 选择照片完成
//选择照片完成
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=info[UIImagePickerControllerEditedImage];
   

//上传图片
    __weak typeof(self)weak_self = self;
    [self.manager requestUploadWithFiles:UIImageJPEGRepresentation(image, 0.5f) Complention:^(NSString *code, NSString *url) {
        
        self.count+=1;
        [weak_self.marrImageUrl addObjectsFromArray:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@",url]]];
        
        
//调用删除的block
      [dynamicScrollView setTapButtonOfDeleteBlock:^(NSString *deleteCount)
        {
          [weak_self.marrImageUrl removeObjectAtIndex:deleteCount.integerValue];
            weak_self.count-=1;
           
      }];
        
        
    }];
//接收传值

    [dynamicScrollView addImageView:[self imageToString:image]];
    //选择完成后,关闭界面
    [self dismissViewControllerAnimated:YES completion:nil
     ];
    
//这里是设置左菜单
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
//把图片转换成字符串
- (NSString *)imageToString:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);

    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}
//点击了取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //这里是设置左菜单
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.leftSlideVC.closed)
    {
        [tempAppDelegate.leftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
