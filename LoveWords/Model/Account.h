//
//  Account.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
//手机号
@property (nonatomic,strong) NSString *tel;
//密码
@property (nonatomic,strong) NSString *password;
//个人信息状态(0已设置,1未设置)
@property (nonatomic,strong) NSString *infoStatus;
//匹配状态 (0匹配,1未匹配)
@property (nonatomic,strong) NSString *matchStatus;
//登录令牌
@property (nonatomic,strong) NSString *token;
//用户ID(在用户注册时系统会自动注册一个环信账号用来聊密码:1234)
@property (nonatomic,strong) NSString *userId;
//匹配token,生成二维码,或者直接给对方,让其匹配
@property (nonatomic,copy) NSString *matchToken;

//初始化Account
- (instancetype)initWithTel:(NSString *)tel
                 InfoStatus:(NSString *)infoStatus
                MatchStatus:(NSString *)matchStatus
                      Token:(NSString *)token
                     UserId:(NSString *)userId
                 MatchToken:(NSString *)matchToken;

@end
