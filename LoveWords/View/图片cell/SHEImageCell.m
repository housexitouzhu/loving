//
//  SHEImageCell.m
//  QQ
//
//  Created by MRBean on 15/12/3.
//  Copyright © 2015年 杨斌. All rights reserved.
//

#import "SHEImageCell.h"
#import "UIButton+WebCache.h"
//#import "SJAvatarBrowser.h"
@interface SHEImageCell ()
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;

@end
@implementation SHEImageCell


- (void)awakeFromNib {
    // Initialization code
    //文字背景图片拉伸
    //消息接收者的背景图片
    UIImage *backImage = [UIImage imageNamed:@"chat_receiver_bg"];
    backImage = [backImage stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    self.backImageView.image = backImage;
}
- (void)configCell:(Message *)msg
{

    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.content] forState:UIControlStateNormal ];
    [self.headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.headImageOfHer] forState:UIControlStateNormal];
    self.headImageButton.layer.cornerRadius=20;
    self.headImageButton.clipsToBounds=YES;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
