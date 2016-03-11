//
//  UserInfo.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//用户名
@property (nonatomic,copy) NSString *userName;
// 用户头像
@property (nonatomic,copy) NSString *userHeadImageUrl;
//用户签名
@property (nonatomic,copy) NSString *userAutograph;
//用户性别
@property (nonatomic,copy) NSString *userSex;
//用户匹配状态
@property (nonatomic,copy) NSString *userMatchStatus;
//用户ID
@property (nonatomic,copy) NSString *userId;
//此token用于和别人匹配
@property (nonatomic,copy) NSString *usertMatchToken;



/**
 *  给一个对应的字典生成一个实体模型
 */
//+ (instancetype)userWithDic:(NSDictionary *)dic;
@end
