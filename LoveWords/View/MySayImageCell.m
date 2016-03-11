//
//  MySayImageCell.m
//  LoveWords
//
//  Created by Ibokan on 16/1/6.
//  Copyright © 2016年 yulu. All rights reserved.
//

#import "MySayImageCell.h"
#import "UITableViewCell+Config.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface MySayImageCell ()
@property (strong, nonatomic) IBOutlet UIButton *buttonOfHeadImage;
@property (strong, nonatomic) IBOutlet UILabel *labelOfNickName;
@property (strong, nonatomic) IBOutlet UILabel *labelOfContent;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfOne;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfTwo;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfThree;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfFour;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfFive;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfSix;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfSeven;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfEight;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfNine;



@property (strong, nonatomic) IBOutlet UILabel *labelOfTimes;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfGrade;
@property (nonatomic,strong) TapButtonOfGradeBlock bBlock;
@property (nonatomic,assign) int count;
@end
@implementation MySayImageCell

- (void)clear
{
    self.imageViewOfOne.image=nil;
    self.imageViewOfTwo.image=nil;
    self.imageViewOfThree.image=nil;
    self.imageViewOfFive.image=nil;
    self.imageViewOfFour.image=nil;
    self.imageViewOfSix.image=nil;
    self.imageViewOfSeven.image=nil;
    self.imageViewOfEight.image=nil;
    self.imageViewOfNine.image=nil;


}

-(void)configCellForSay:(Status *)status
{
    [self clear];
    self.count=0;
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
//设置图片
    NSArray *arrImageURL=[status.imageUrls componentsSeparatedByString:@"|"];
    
    if (arrImageURL.count==2) {
        NSString *imageURLOne=arrImageURL[0];
//1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];

        

    }
    else if (arrImageURL.count==3)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        
      
//1
    [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
//2
    [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
    }

    else if (arrImageURL.count==4)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        

    }
    else if (arrImageURL.count==5)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        NSString *imageURLFour=arrImageURL[3];
       
        
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //4
        [self.imageViewOfFour sd_setImageWithURL:[NSURL URLWithString:imageURLFour] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];

        
    }
    else if (arrImageURL.count==6)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        NSString *imageURLFour=arrImageURL[3];
        NSString *imageURLFive=arrImageURL[4];
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //4
        [self.imageViewOfFour sd_setImageWithURL:[NSURL URLWithString:imageURLFour] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];

        //5
        [self.imageViewOfFive sd_setImageWithURL:[NSURL URLWithString:imageURLFive] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];

    }
    else if (arrImageURL.count==7)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        NSString *imageURLFour=arrImageURL[3];
        NSString *imageURLFive=arrImageURL[4];
        NSString *imageURLSix=arrImageURL[5];
    
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //4
        [self.imageViewOfFour sd_setImageWithURL:[NSURL URLWithString:imageURLFour] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //5
        [self.imageViewOfFive sd_setImageWithURL:[NSURL URLWithString:imageURLFive] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];

        //6
        [self.imageViewOfSix sd_setImageWithURL:[NSURL URLWithString:imageURLSix] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        


    }
    else if (arrImageURL.count==8)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        NSString *imageURLFour=arrImageURL[3];
        NSString *imageURLFive=arrImageURL[4];
        NSString *imageURLSix=arrImageURL[5];
        NSString *imageURLSeven=arrImageURL[6];
        
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //4
        [self.imageViewOfFour sd_setImageWithURL:[NSURL URLWithString:imageURLFour] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //5
        [self.imageViewOfFive sd_setImageWithURL:[NSURL URLWithString:imageURLFive] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //6
        [self.imageViewOfSix sd_setImageWithURL:[NSURL URLWithString:imageURLSix] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //7
        [self.imageViewOfSeven sd_setImageWithURL:[NSURL URLWithString:imageURLSeven] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];


    }
    else if (arrImageURL.count==9)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        NSString *imageURLFour=arrImageURL[3];
        NSString *imageURLFive=arrImageURL[4];
        NSString *imageURLSix=arrImageURL[5];
        NSString *imageURLSeven=arrImageURL[6];
        NSString *imageURLEight=arrImageURL[7];
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //4
        [self.imageViewOfFour sd_setImageWithURL:[NSURL URLWithString:imageURLFour] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //5
        [self.imageViewOfFive sd_setImageWithURL:[NSURL URLWithString:imageURLFive] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //6
        [self.imageViewOfSix sd_setImageWithURL:[NSURL URLWithString:imageURLSix] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //7
        [self.imageViewOfSeven sd_setImageWithURL:[NSURL URLWithString:imageURLSeven] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //8
       [self.imageViewOfEight sd_setImageWithURL:[NSURL URLWithString:imageURLEight] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        
    

    }
    else if (arrImageURL.count==10)
    {
        NSString *imageURLOne=arrImageURL[0];
        NSString *imageURLTwo=arrImageURL[1];
        NSString *imageURLThree=arrImageURL[2];
        NSString *imageURLFour=arrImageURL[3];
        NSString *imageURLFive=arrImageURL[4];
        NSString *imageURLSix=arrImageURL[5];
        NSString *imageURLSeven=arrImageURL[6];
        NSString *imageURLEight=arrImageURL[7];
        NSString *imageURLNine=arrImageURL[8];
        //1
        [self.imageViewOfOne sd_setImageWithURL:[NSURL URLWithString:imageURLOne] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //2
        [self.imageViewOfTwo sd_setImageWithURL:[NSURL URLWithString:imageURLTwo] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //3
        [self.imageViewOfThree sd_setImageWithURL:[NSURL URLWithString:imageURLThree] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //4
        [self.imageViewOfFour sd_setImageWithURL:[NSURL URLWithString:imageURLFour] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //5
        [self.imageViewOfFive sd_setImageWithURL:[NSURL URLWithString:imageURLFive] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //6
        [self.imageViewOfSix sd_setImageWithURL:[NSURL URLWithString:imageURLSix] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //7
        [self.imageViewOfSeven sd_setImageWithURL:[NSURL URLWithString:imageURLSeven] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        //8
        [self.imageViewOfEight sd_setImageWithURL:[NSURL URLWithString:imageURLEight] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
        
        //9
        [self.imageViewOfNine sd_setImageWithURL:[NSURL URLWithString:imageURLNine] placeholderImage:[UIImage imageNamed:@"zhanwei-lucien"]];
    }
    


//设置发布时间
    self.labelOfTimes.text=status.publishDate;
//设置赞的button
    [self.buttonOfGrade setBackgroundImage:[UIImage imageNamed:@"zan-0-lucien"] forState:UIControlStateNormal];
}
//接收外界代码,存在bBlock中
- (void)setTapButtonOfImageGrade:(TapButtonOfGradeBlock)aBlock
{
    self.bBlock=aBlock;
}
//点击按钮执行bBlock
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
