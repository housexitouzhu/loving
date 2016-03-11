//
//  Message.h
//  LoveWords
//
//  Created by Ibokan on 16/1/3.
//  Copyright © 2016年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
//cell的内容
@property(copy,nonatomic)NSString *cellKind;
@property(copy,nonatomic)NSString *content;
@property (nonatomic,copy) NSString *image;

//好友请求
@property (nonatomic,strong) NSString *friendsName;
@property (nonatomic,strong) NSString *requestMessage;
//语音时间,路径
@property (nonatomic,strong) NSString *voiceTimes;
@property (nonatomic,strong) NSString *voicePath;
//CELL的头像
@property (nonatomic,copy) NSString *headImageOfMe;
@property (nonatomic,copy) NSString *headImageOfHer;


@end
