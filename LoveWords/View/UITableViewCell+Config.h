//
//  UITableViewCell+Config.h
//  1130-IM
//
//  Created by Ibokan on 15/12/1.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "EaseMob.h"
#import "Status.h"

typedef void(^TapButtonOfGradeBlock)(id obj,int i);

@interface UITableViewCell (Config)
- (void)configCell:(Message *)msg;
- (void)configCellForMessage:(EMConversation *)con;
- (void)configCellForRequest:(NSDictionary  *)dicOfRequest;
- (void)configCellForSay:(Status *)status;

//配置赞
- (void)setTapButtonOfImageGrade:(TapButtonOfGradeBlock)aBlock;
- (void)setTapButtonOfTextGrade:(TapButtonOfGradeBlock)aBlock;
@end
