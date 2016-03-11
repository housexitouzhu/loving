//
//  MeVoiceCell.m
//  1130-IM
//
//  Created by Ibokan on 15/12/9.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "MeVoiceCell.h"
#import "UITableViewCell+Config.h"
#import "UIButton+WebCache.h"
#import <AVFoundation/AVFoundation.h>
@interface MeVoiceCell ()
@property (strong, nonatomic) IBOutlet UIButton *buttonOfHeadImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfVoice;
@property (strong, nonatomic) IBOutlet UILabel *labelOfTimes;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfMessage;
@property (nonatomic,assign) NSUInteger VoiceTimes;
@property (nonatomic,strong) NSString *voicePath;
@property (nonatomic,strong) AVAudioPlayer *avPlayer;
@end

@implementation MeVoiceCell
-(void)configCell:(Message *)msg
{
    NSString *str=[NSString stringWithFormat:@"%d'",msg.voiceTimes.intValue];
    self.labelOfTimes.text=str;
    self.VoiceTimes=msg.voiceTimes.integerValue;
    self.voicePath=msg.voicePath;
    [self.buttonOfHeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.headImageOfMe] forState:UIControlStateNormal];
    
}


- (void)awakeFromNib
{
    //配置voice
    self.imageViewOfMessage.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewOfMessage)];
    [self.imageViewOfMessage addGestureRecognizer:singleTap];
    //设置气泡图
    UIImage *image=[UIImage imageNamed:@"chat_sender_bg"];
    image=[image stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    self.imageViewOfMessage.image=image;
    
    self.buttonOfHeadImage.layer.cornerRadius=20;
    self.buttonOfHeadImage.clipsToBounds=YES;
}
-(void)tapImageViewOfMessage
{
    
    

    NSMutableArray *marr= [NSMutableArray array];
    for (int i=0; i<4; i++)
    {
        NSString *imageName=[NSString stringWithFormat:@"chat_sender_audio_playing_00%d@2x.png",i];
        UIImage *image=[UIImage imageNamed:imageName];
       
        //把产生的image加入到数组中
        [marr addObject:image];
    }
        //动画图片
       // self.imageViewOfVoice.image=nil;
        self.imageViewOfVoice.animationImages=marr;
    
    //动画持续时间
    self.imageViewOfVoice.animationDuration=(NSTimeInterval)self.VoiceTimes;

     self.imageViewOfVoice.animationRepeatCount=1;
     [self.imageViewOfVoice startAnimating];
    
    
    NSURL *url=[NSURL fileURLWithPath:self.voicePath];
   // NSLog(@"==========%@",self.voicePath);
    self.avPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    [self.avPlayer play];
    
    //[self.imageViewOfVoice stopAnimating];
}
@end
