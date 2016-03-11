//
//  MySayTextCell.m
//  LoveWords
//
//  Created by Ibokan on 16/1/4.
//  Copyright © 2016年 yulu. All rights reserved.
//

#import "MySayTextCell.h"
#import "UITableViewCell+Config.h"
#import "UIButton+WebCache.h"

@interface MySayTextCell ()
@property (strong, nonatomic) IBOutlet UIButton *buttonOfHeadImage;
@property (strong, nonatomic) IBOutlet UILabel *labelOfNickName;
@property (strong, nonatomic) IBOutlet UILabel *labelOfContent;
@property (strong, nonatomic) IBOutlet UILabel *labelOfTimes;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfGrade;
@property (nonatomic,strong) TapButtonOfGradeBlock bBlock;
@property (nonatomic,assign) int count;
@end
@implementation MySayTextCell
-(void)configCellForSay:(Status *)status
{
//设置头像
    self.buttonOfHeadImage.layer.cornerRadius=20;
    self.buttonOfHeadImage.clipsToBounds=YES;
    [self.buttonOfHeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:status.headImageUrl] forState:UIControlStateNormal];
   
//设置昵称
   self.labelOfNickName.text=status.nickName;
//设置内容
    
   self.labelOfContent.text=status.text;
    self.labelOfContent.numberOfLines=0;
    [self.contentView layoutIfNeeded];
//设置发布时间
    self.labelOfTimes.text=status.publishDate;
//设置赞的button
    [self.buttonOfGrade setBackgroundImage:[UIImage imageNamed:@"zan-0-lucien"] forState:UIControlStateNormal];
}

- (void)setTapButtonOfTextGrade:(TapButtonOfGradeBlock)aBlock
{
    self.bBlock=aBlock;
}

- (IBAction)tapButtonOfGrade:(UIButton *)sender
{
    self.count++;
    if (self.bBlock) {
        self.bBlock(sender,self.count);
    }
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
