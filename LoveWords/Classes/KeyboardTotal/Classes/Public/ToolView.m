//
//  ToolView.m
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import "ToolView.h"
#import "MBProgressHUD.h"
#import "LCVoice.h"
#import <AVFoundation/AVFoundation.h>
#import "ConstantDef.h"
#define kHUD_SHOW_TEXT(text) MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];hud.mode = MBProgressHUDModeText;hud.labelText = text;hud.removeFromSuperViewOnHide = YES;[hud hide:YES afterDelay:1.5];
@interface ToolView ()<UITextViewDelegate>
@property(strong,nonatomic)UIButton *voiceButton;//第一个按钮
@property(strong,nonatomic)UIButton *recordButon;//录音按钮
@property(strong,nonatomic)LCVoice *voice;//录音器
@property(copy,nonatomic)NSString *path;//录音的存放路径
@property(strong,nonatomic)UIButton *faceButton;//表情按钮
@property(strong,nonatomic)UIButton *moreButton;//功能按钮

@property(strong,nonatomic)NSDictionary *bundingDic;
@property(strong,nonatomic)BottomBlock bBlock;
@property(strong,nonatomic)FuncButtonBlock funcBlock;
@property(strong,nonatomic)SendBlock sendBlock;
@property(strong,nonatomic)RecordEndedHandler handler;
@property(strong,nonatomic) AVAudioPlayer *player;
@end
@implementation ToolView
- (void)setRecordEndedHandler:(RecordEndedHandler)hander
{
    self.handler = hander;
}
- (void)setTapSendBlock:(SendBlock)sendBlock
{
    self.sendBlock = sendBlock;
}

-(void)setTapBottomButtonBlock:(BottomBlock)bBlock
{
    self.bBlock = bBlock;
}
-(void)setFuncButtonBlock:(FuncButtonBlock)funcBlock
{
    self.funcBlock = funcBlock;
}
- (instancetype)init
{
    self = [super init];
    if (self) {

        [self loadMyViews];
    }
    return self;
}


- (void)awakeFromNib
{
    [self loadMyViews];
}

- (void)loadMyViews
{
    
    //toolvew背景色
    self.backgroundColor =HMColor(238, 130, 238);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _voice = [[LCVoice alloc]init];
    __weak typeof(self)weak_self = self;
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceButton setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    _voiceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_voiceButton addTarget:self action:@selector(tapVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    _voiceButton.tag = ButtonTypeVoiceUnSelected;
    [self addSubview:_voiceButton];
    
    _mTextView = [[MTextView alloc]init];
    _mTextView.layer.borderWidth = 1;
    _mTextView.layer.cornerRadius = 4;
    _mTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _mTextView.delegate = self;
    //设置原生键盘上的发送/搜索/完成
    _mTextView.returnKeyType = UIReturnKeySend;
    _mTextView.translatesAutoresizingMaskIntoConstraints =NO;

    [_mTextView setTapBottomButtonBlock:^(BottomButtonType buttonIndex) {
       
        if (weak_self.bBlock) {
            weak_self.bBlock(weak_self.mTextView.attributedText,buttonIndex);
            if (buttonIndex==BottomButtonTypeSend) {
                weak_self.mTextView.text = @"";
            }
            //清空mTextView原来的字符串
            
        }
    }];
    
    //toolView使用了textView的接口,所以需要给他一个block
    [_mTextView setFuncButtonBlock:^(FuncButtonType buttonIndex) {
        if (weak_self.funcBlock) {
            weak_self.funcBlock(buttonIndex);
        }
    }];
    [self addSubview:_mTextView];

    _recordButon = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButon.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
    _recordButon.layer.cornerRadius = 4;
    _recordButon.hidden = YES;
    _recordButon.translatesAutoresizingMaskIntoConstraints = NO;
    [_recordButon addTarget:self action:@selector(tapRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButon setTitle:@"按住说话" forState:UIControlStateNormal];
    [self addSubview:_recordButon];
    //给录音按钮添加长按手势
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressRecordButton:)];
    longGes.minimumPressDuration = 1;
    [_recordButon addGestureRecognizer:longGes];
    
    
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_faceButton setImage:[UIImage imageNamed:@"41.png"] forState:UIControlStateNormal];
    _faceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_faceButton addTarget:self action:@selector(tapFaceButton:) forControlEvents:UIControlEventTouchUpInside];
    _faceButton.tag = ButtonTypeFaceUnSelected;
    [self addSubview:_faceButton];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    _moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_moreButton addTarget:self action:@selector(tapMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.tag = ButtonTypeMoreUnSelected;
    [self addSubview:_moreButton];
  
    
    _bundingDic = NSDictionaryOfVariableBindings(_voiceButton,_recordButon,_faceButton,_moreButton,_mTextView);
    NSArray *h1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_voiceButton(44)][_mTextView][_faceButton(_voiceButton)][_moreButton(_voiceButton)]|" options:0 metrics:0 views:_bundingDic];
    NSArray *h2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_voiceButton][_recordButon][_faceButton]" options:0 metrics:0 views:_bundingDic];
    NSArray *v1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_voiceButton(44)]" options:0 metrics:0 views:_bundingDic];
    NSArray *v2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_recordButon]-7-|" options:0 metrics:0 views:_bundingDic];
    NSArray *v20= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_mTextView]-7-|" options:0 metrics:0 views:_bundingDic];
    NSArray *v3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_faceButton(44)]" options:0 metrics:0 views:_bundingDic];
    NSArray *v4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_moreButton(44)]" options:0 metrics:0 views:_bundingDic];
    [self addConstraints:h1];
    [self addConstraints:h2];
    [self addConstraints:v1];
    [self addConstraints:v20];
    [self addConstraints:v2];
    [self addConstraints:v3];
    [self addConstraints:v4];
    
    
    
    
}

- (void)tapVoiceButton:(UIButton*)sender
{
    [_mTextView setKeyboardStatus:(ButtonType)sender.tag];
    switch (sender.tag) {
        case ButtonTypeVoiceSelected:
            _recordButon.hidden = YES;
            sender.tag = ButtonTypeVoiceUnSelected;
            [sender setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
            break;
        case ButtonTypeVoiceUnSelected:
            _recordButon.hidden = NO;
            sender.tag = ButtonTypeVoiceSelected;
            [sender setImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_faceButton setImage:[UIImage imageNamed:@"41.png"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    _faceButton.tag = ButtonTypeFaceUnSelected;
    _moreButton.tag = ButtonTypeMoreUnSelected;
}

#pragma mark - 长按按钮时的回调事件
- (void)longPressRecordButton:(UILongPressGestureRecognizer*)sender
{
    
    __weak typeof(self) weak_self = self;
    UILongPressGestureRecognizer *longPress = sender;
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        NSString * name = [NSString stringWithFormat:@"%ldvoice.caf",(long)[NSDate timeIntervalSinceReferenceDate]];
        
        _path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];//改为时间戳!
        
        //NSLog(@"长按开始!");
        
        
        [self.voice startRecordWithPath:_path];
        
    }
    else if(longPress.state == UIGestureRecognizerStateRecognized)
    {
        [self.voice stopRecordWithCompletionBlock:^{
            if (self.voice.recordTime > 0.0f) {

                //NSLog(@"长按录音结束!");
                //结束之后的代码
                NSLog(@"录音结束,录音存放路径是:%@",_path);
                //录音结束的回调
                NSError *error;
                weak_self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:weak_self.path] error:&error];
                if (error) {
                    NSLog(@"录音错误!!!");
                    return ;
                }
                
                if (weak_self.handler) {
                    weak_self.handler(_path,weak_self.player.duration);
                    
                    
                }
                [weak_self.voice stopRecorder];
            }
        }];
    }

}
- (void)tapRecordButton:(UIButton*)sender
{
    kHUD_SHOW_TEXT(@"按住时间太短");
}

- (void)tapFaceButton:(UIButton*)sender
{
    [_mTextView setKeyboardStatus:(ButtonType)sender.tag];
    switch (sender.tag) {
        case ButtonTypeFaceSelected:
            sender.tag = ButtonTypeFaceUnSelected;
            [sender setImage:[UIImage imageNamed:@"41.png"] forState:UIControlStateNormal];
            break;
        case ButtonTypeFaceUnSelected:
            sender.tag = ButtonTypeFaceSelected;
            [sender setImage:[UIImage imageNamed:@"11.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_voiceButton setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    _voiceButton.tag = ButtonTypeVoiceUnSelected;
    _moreButton.tag = ButtonTypeMoreUnSelected;
    _recordButon.hidden = YES;
}

- (void)tapMoreButton:(UIButton*)sender
{
    [_mTextView setKeyboardStatus:(ButtonType)sender.tag];
    switch (sender.tag) {
        case ButtonTypeMoreSelected:
            sender.tag = ButtonTypeMoreUnSelected;
            [sender setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
            break;
        case ButtonTypeMoreUnSelected:
            sender.tag = ButtonTypeMoreSelected;
            [sender setImage:[UIImage imageNamed:@"42.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_faceButton setImage:[UIImage imageNamed:@"41.png"] forState:UIControlStateNormal];
    [_voiceButton setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    _faceButton.tag = ButtonTypeFaceUnSelected;
    _voiceButton.tag = ButtonTypeVoiceUnSelected;
}
//检测每一个输入的字符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //NSLog(@"text======%@",text);
    if([text isEqualToString:@"\n"])//点击了发送
    {
        if (_sendBlock) {
            _sendBlock(_mTextView.attributedText);
            //清空原来的字符串
            _mTextView.text = @"";
        }
        return NO;//不记录该回车字符
    }

    return YES;
}
@end
