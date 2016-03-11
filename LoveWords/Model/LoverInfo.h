//
//  LoverInfo.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoverInfo : NSObject
//恋人名字
@property (nonatomic,strong) NSString *loverName;
//恋人头像
@property (nonatomic,strong) NSString *loverHeadImageUrl;
//恋人签名
@property (nonatomic,strong) NSString *loverAutograph;
//恋人性别
@property (nonatomic,strong) NSString *loverSex;
//配对日期
@property (nonatomic,strong) NSString *loverMatchDate;
//恋人ID
@property (nonatomic,strong) NSString *loverId;
@end
