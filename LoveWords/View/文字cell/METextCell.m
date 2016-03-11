//
//  METextCell.m
//  QQ
//
//  Created by MRBean on 15/12/3.
//  Copyright © 2015年 杨斌. All rights reserved.
//

#import "METextCell.h"
#import "Tools.h"
#import "Message.h"
#import "UITableViewCell+Config.h"
#import "UIButton+WebCache.h"
@interface METextCell ()
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;

@end
@implementation METextCell
- (IBAction)tapHead:(id)sender {
    //点击了头像
}

- (void)awakeFromNib {
    
    //文字的背景图片拉伸
    UIImage *backImage = [UIImage imageNamed:@"chat_sender_bg"];
    backImage = [backImage stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    self.backImageView.image = backImage;
    
    self.headImageButton.layer.cornerRadius=20;
    self.headImageButton.clipsToBounds=YES;
}
- (void)configCell:(Message *)msg{
    self.content.attributedText = [Tools stringToAttributeString:msg.content];

    [self.headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.headImageOfMe] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
