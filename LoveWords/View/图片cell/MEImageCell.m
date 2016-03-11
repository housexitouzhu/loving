//
//  MEImageCell.m
//  QQ
//
//  Created by MRBean on 15/12/3.
//  Copyright © 2015年 杨斌. All rights reserved.
//

#import "MEImageCell.h"
#import "UITableViewCell+Config.h"
#import "UIButton+WebCache.h"

@interface MEImageCell ()
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;

@end
@implementation MEImageCell

- (void)configCell:(Message *)msg
{
    //发送的图片
    [self.imageButton setBackgroundImage:(UIImage *)msg.content forState:UIControlStateNormal];
    //头像
    [self.headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.headImageOfMe] forState:UIControlStateNormal];
    self.headImageButton.layer.cornerRadius=20;
    self.headImageButton.clipsToBounds=YES;
   
}

- (void)awakeFromNib {
    //文字的背景图片拉伸
    UIImage *backImage = [UIImage imageNamed:@"chat_sender_bg"];//发送消息的背景图片
    backImage = [backImage stretchableImageWithLeftCapWidth:5 topCapHeight:35];//拉伸图片产生新的图片
    self.backImageView.image = backImage;//设置背景图片
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
