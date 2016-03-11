//
//  UITableViewCell+Config.m
//  1130-IM
//
//  Created by Ibokan on 15/12/1.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "UITableViewCell+Config.h"

@implementation UITableViewCell (Config)
- (void)configCell:(Message *)msg
{
   // NSLog(@"实现");
}
- (void)configCellForMessage:(EMConversation *)con
{
    // NSLog(@"实现");
}
- (void)configCellForRequest:(NSDictionary  *)dicOfRequest
{
  //  NSLog(@"实现");

}
- (void)configCellForSay:(Status *)status
{
   // NSLog(@"实现");

}

//配置赞
- (void)setTapButtonOfImageGrade:(TapButtonOfGradeBlock)aBlock
{
    //NSLog(@"实现");

}
- (void)setTapButtonOfTextGrade:(TapButtonOfGradeBlock)aBlock
{
    //NSLog(@"实现");

}
@end
