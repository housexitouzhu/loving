//
//  ChatViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "ToolView.h"
#import "Tools.h"
#import "EaseMob.h"
#import "Message.h"
#import "ConstantDef.h"
#import "UITableViewCell+Config.h"
#import "IQKeyboardManager.h"
#import "DataManager.h"
#import "FaceImageView.h"
@interface ChatViewController ()<EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewOfChat;
@property (strong, nonatomic) IBOutlet ToolView *toolView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toolViewBottom;


@property (nonatomic,strong) NSMutableArray *marr;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,copy) NSString *loverId;
@property (nonatomic,copy) NSString *userHeadImageUrl;
@property (nonatomic,copy) NSString *loverHeadImageUrl;
@property (nonatomic,copy) NSString *imageUrl;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.marr=[NSMutableArray new];
    self.view.backgroundColor=[UIColor grayColor];
    self.navigationItem.title=@"聊天界面";
//添加手势
    UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    gestureRecognizer.cancelsTouchesInView=NO;
    [self.tableViewOfChat addGestureRecognizer:gestureRecognizer];
//tableView的代理
    self.tableViewOfChat.delegate=self;
    self.tableViewOfChat.dataSource=self;
    self.tableViewOfChat.rowHeight=UITableViewAutomaticDimension;
    self.tableViewOfChat.estimatedRowHeight=120;
    self.tableViewOfChat.separatorStyle=UITableViewCellSeparatorStyleNone;
//环信代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//设置imagePicker
    self.imagePicker=[[UIImagePickerController alloc]init];
    self.imagePicker.delegate=self;
    self.imagePicker.allowsEditing=YES;
//获取环信的userId
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    self.loverId=[user objectForKey:@"loverId"];
    self.userHeadImageUrl=[user objectForKey:@"userHeadImageUrl"];
    self.loverHeadImageUrl=[user objectForKey:@"loverHeadImageUrl"];
    
//注册Cell
    //语音
    [self.tableViewOfChat registerNib:[UINib nibWithNibName:@"MeVoiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MeVoice"];
    [self.tableViewOfChat registerNib:[UINib nibWithNibName:@"SheVoiceViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SheVoice"];
    //文字
    [self.tableViewOfChat registerNib:[UINib nibWithNibName:@"METextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MeText"];
    [self.tableViewOfChat registerNib:[UINib nibWithNibName:@"SHETextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SheText"];
    //图片
    [self.tableViewOfChat registerNib:[UINib nibWithNibName:@"MEImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MEImage"];
    [self.tableViewOfChat registerNib:[UINib nibWithNibName:@"SHEImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SHEImage" ];

//配置self.toolView的位置
    __weak typeof(self)weak_self  =self;
//    _toolView = [[ToolView alloc]init];
//    [self.view addSubview:_toolView];
//    NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
//    NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolView(48)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
//    [self.view addConstraints:h];
//    [self.view addConstraints:v];

//监听键盘的状态通知,该键盘通知由系统发出,不需要手动发出
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
#pragma mark  配置录音的block
 
[_toolView setRecordEndedHandler:^(NSString *voicePath, NSTimeInterval duration) {
//从本地获取数据/获取环信的userId
    
        EMChatVoice *voice=[[EMChatVoice alloc]initWithFile:voicePath displayName:@"audio"];
        voice.duration = duration;
        EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
        
        // 生成message
        EMMessage *message = [[EMMessage alloc] initWithReceiver:weak_self.loverId bodies:@[body]];
        message.messageType = eMessageTypeChat; // 设置为单聊消息
        
        
        [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
            if (error)
            {
                SHOW_TEXT(@"发送失败");
                //NSLog(@"errror=%@",error);
            }
            else
            {
                Message *msg=[[Message alloc]init];
                msg.cellKind=@"MeVoice";
                msg.voiceTimes=[NSString stringWithFormat:@"%f",duration];
                msg.voicePath=voicePath;
                msg.headImageOfMe=weak_self.userHeadImageUrl;
               // NSLog(@"打印一下voice-----%@",voicePath);
                [weak_self.marr addObject:msg];
                [weak_self.tableViewOfChat reloadData];
            }
            
            
            
        } onQueue:nil];
        
        
    }];
//点击原生键盘上的发送按钮,让attStr在两个textView上显示
    [_toolView setTapSendBlock:^(NSAttributedString *attStr) {
        
        [weak_self configTwoText:attStr];
    }];
    
#pragma -mark点击自定义表情键盘的3个按钮
//点击自定义表情键盘的3个按钮
    [_toolView setTapBottomButtonBlock:^(NSAttributedString *attStr, BottomButtonType buttonType) {
        switch (buttonType) {
            case BottomButtonTypeRecently:
                break;
                //最近
            case BottomButtonTypeDefaut:
            {
                [weak_self.toolView.mTextView deleteBackward];
            }
                break;
                //默认
            case BottomButtonTypeSend:{
                //表情发送
                [weak_self configTwoText:attStr];
                
            }
                break;
            default:
                break;
        }
    }];
    
    
//使用toolView需要给他制定block代码
    [_toolView setFuncButtonBlock:^(FuncButtonType buttonIndex) {
        switch (buttonIndex) {
            case FuncButtonTypeCamera:{
              //  NSLog(@"你点击了相机!");
                [weak_self tapCamera];
            }break;
            case FuncButtonTypePhoto:{
                
               // NSLog(@"你点击了图片!");
          
                [weak_self tapAddPhotos];
                
            }break;
            case FuncButtonTypeLocation:{
               // NSLog(@"你点击了定位!");
            }break;
            default:
                break;
        }
    }];
  
    
}
-(void)hideKeyBoard
{
    [self.toolView.mTextView resignFirstResponder];
}



#pragma mark -调整键盘高度
//通知中心回调：当键盘高度将要变化时，此方法被调用
-(void)receiveNoti:(NSNotification *)noti
{
//获取通知信息
    NSDictionary *dic=[noti userInfo];
    NSValue *vE=dic[UIKeyboardFrameEndUserInfoKey];
//键盘弹起结束后的frame
    CGRect keyBoardFrame = [vE CGRectValue];
  
    CGRect frame = self.view.frame;
//改变view的高度,从而让toolView上移
    frame.size.height = keyBoardFrame.origin.y;
   // frame.origin.y -= keyBoardFrame.origin.y;
//使用动画改变view的frame
 
    CGFloat hh = self.view.frame.size.height - keyBoardFrame.origin.y;
    self.toolViewBottom.constant = hh+63;
// NSLog(@"键盘%@",NSStringFromCGRect(keyBoardFrame));
    
   
    [self.view layoutIfNeeded];//重新布局
  
}
//
#pragma mark - 配置两个textView上,让其显示对应的文字
- (void)configTwoText:(NSAttributedString*)attStr
{
 
    
__weak typeof(self)weak_self = self;
    //普通的字符串,plainText是网络传输字符串
    NSString *plainText = [Tools attStringToString:attStr];//转换属性字符串为普通字符串
    
    EMChatText *txtChat=[[EMChatText alloc]initWithText:plainText];
    EMTextMessageBody *body=[[EMTextMessageBody alloc]initWithChatObject:txtChat];
    //生成message
#pragma -mark测试聊天
    EMMessage *message=[[EMMessage alloc]initWithReceiver:self.loverId bodies:@[body]];
    message.messageType=eMessageTypeChat;//设置为单聊信息
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (error)
        {
            SHOW_TEXT(@"发送失败");
            //NSLog(@"error=%@",error);
        }
        else
        {
            Message *msg=[[Message alloc]init];
            msg.cellKind=@"MeText";
            msg.content=plainText;
            msg.headImageOfMe=self.userHeadImageUrl;
            [weak_self.marr addObject:msg];
            //[self.tableViewOfChat reloadData];
            [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.5];
        }
        
        
        
    } onQueue:nil];
    
    
}
#pragma -mark 点击了相机
- (void)tapCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ] )
    {
        
        //设置picker的资源来源
        self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        //模态展示选择界面
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}



#pragma -mark点击了添加图片
//点击了添加图片
- (void)tapAddPhotos
{
    //设置资源为相册
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}
//选择照片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __weak typeof(self)weak_self  =self;

    
    //取出编辑之后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将图片转换成字符串
    NSData *data=UIImageJPEGRepresentation(image, 0.5f);


    EMChatImage *imageChat=[[EMChatImage alloc]initWithData:data displayName:@"图片"];
    EMImageMessageBody *body=[[EMImageMessageBody alloc]initWithChatObject:imageChat];
//获取环信
 
    EMMessage *message=[[EMMessage alloc]initWithReceiver:self.loverId bodies:@[body]];
    message.messageType=eMessageTypeChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (error)
        {
            SHOW_TEXT(@"发送失败");
           // NSLog(@"error=%@",error);
        }
        else
        {
            Message *msg=[[Message alloc]init];
            msg.cellKind=@"MEImage";
            msg.content=(NSString *)image;
            msg.headImageOfMe=self.userHeadImageUrl;
            [weak_self.marr addObject:msg];
            //[self.tableViewOfChat reloadData];
            [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.5];
        }
    } onQueue:nil];
    
    //选择完成之后,关闭选择界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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

//点击了取消,也需要关闭选择界面

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - 收到消息回调

// 收到消息的回调，带有附件类型的消息可以用SDK提供的下载附件方法下载（后面会讲到）
-(void)didReceiveMessage:(EMMessage *)message
{
//从本地获取数据

    
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            //NSLog(@"收到的文字是 txt -- %@",txt);
            Message *msg=[Message new];
            msg.cellKind=@"SheText";
            msg.content=txt;
            msg.headImageOfHer=self.loverHeadImageUrl;
            [self.marr addObject:msg];
            //[self.tableViewOfChat reloadData];
            [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.5];
        }
            break;
        case eMessageBodyType_Image:
        {
        // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            //NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            Message *msg=[Message new];
            msg.cellKind=@"SHEImage";
            msg.content=body.thumbnailRemotePath;
           // NSLog(@"*********%@",self.imageUrl);
            msg.headImageOfHer=self.loverHeadImageUrl;
            [self.marr addObject:msg];
            [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.5];
//            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
//            NSLog(@"大图的secret -- %@"    ,body.secretKey);
//            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
//            NSLog(@"大图的下载状态 -- %lu",(unsigned long)body.attachmentDownloadStatus);
//            
//            
//            // 缩略图sdk会自动下载
//            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
//            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
//            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
//            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
//            NSLog(@"小图的下载状态 -- %lu",(unsigned long)body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_Voice:
        {
// 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            // 收到的音频消息
            Message *msg=[Message new];
            msg.cellKind=@"SheVoice";
            msg.voiceTimes=[NSString stringWithFormat:@"%lu",(long)body.duration];
            msg.voicePath=body.remotePath;
            msg.headImageOfHer=self.loverHeadImageUrl;
            NSLog(@"打印一下voice-----%@",body.remotePath);
            [self.marr addObject:msg];
            [self.tableViewOfChat reloadData];
//            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
//            NSLog(@"音频的secret -- %@"        ,body.secretKey);
//            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
//            NSLog(@"音频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
//            NSLog(@"音频的时间长度 -- %lu"      ,(long)body.duration);
        }
            break;
            
        default:
            break;
    }
}
//发送消息
- (EMMessage *)sendMessage:(EMMessage *)message
                  progress:(id<IEMChatProgressDelegate>)progress
                     error:(EMError **)pError
{

    return message;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.marr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取出每条信息
    Message *msg=self.marr[indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:msg.cellKind forIndexPath:indexPath];
    
    //2.显示cell
    [cell configCell:msg];
    return cell;
}
//选中时,不改变cell的颜色
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//动画
-(void)reloadTableView{
    
    [self.tableViewOfChat reloadData];
    
    //
    if (self.marr.count > 2)
    {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.marr.count-1 inSection:0];
        
        [self.tableViewOfChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    }
    
    
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
    
    //配置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    //配置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
}

//点击空白取消键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击空白");
    FaceImageView *faceImageView=[[FaceImageView alloc]init];
    [faceImageView.scrollView removeFromSuperview];
    
    //[self.tableViewOfChat endEditing:YES];
    
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
