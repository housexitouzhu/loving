//
//  Status.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject
//发表人\的昵称
@property (nonatomic,strong) NSString *nickName;
//发表人的头像
@property (nonatomic,strong) NSString *headImageUrl;
//发表日期
@property (nonatomic,strong) NSString *publishDate;
//发表的文本内容
@property (nonatomic,strong) NSString *text;
//发表中的图片的地址(imageURLs是一个字符串,是多张图片路径使用竖线拼接的字符串,获取的状态亦是如此)
@property (nonatomic,strong) NSString *imageUrls;
//是否被赞过
@property (nonatomic,strong) NSString *zan;
//状态类型
@property (nonatomic,strong) NSString *type;
//唯一标识某一条状态
@property (nonatomic,strong) NSString *statusId;
//发布者标识
@property (nonatomic,strong) NSString *token;

-(instancetype)initWithToken:(NSString *)token
                    NickName:(NSString *)nickName
                HeadImageUrl:(NSString *)headImageUrl
                 PublishDate:(NSString *)publishDate
                        Text:(NSString *)text
                   ImageUrls:(NSString *)imageUrls
                         Zan:(NSString *)zan
                        Type:(NSString *)type
                    StatusId:(NSString *)statusId;



@end
