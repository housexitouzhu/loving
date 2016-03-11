//
//  SHETextCell.m
//  QQ
//
//  Created by MRBean on 15/12/3.
//  Copyright © 2015年 杨斌. All rights reserved.
//

#import "SHETextCell.h"
#import "Tools.h"
#import "UITableViewCell+Config.h"
#import "Message.h"
#import "UIButton+WebCache.h"
@interface SHETextCell ()

@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@end
@implementation SHETextCell

- (IBAction)tapHead:(id)sender {
}

- (void)awakeFromNib {
    //文字背景图片拉伸
    UIImage *backImage = [UIImage imageNamed:@"chat_receiver_bg"];
    backImage = [backImage stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    self.backImageView.image = backImage;
    
    self.headImageButton.layer.cornerRadius=20;
    self.headImageButton.clipsToBounds=YES;
}
- (void)configCell:(Message *)msg{
    self.content.attributedText = [Tools stringToAttributeString:msg.content];

    [self.headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:msg.headImageOfHer] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
