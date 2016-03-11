//
//  Status.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "Status.h"

@implementation Status
-(instancetype)initWithToken:(NSString *)token
                    NickName:(NSString *)nickName
                HeadImageUrl:(NSString *)headImageUrl
                 PublishDate:(NSString *)publishDate
                        Text:(NSString *)text
                   ImageUrls:(NSString *)imageUrls
                         Zan:(NSString *)zan
                        Type:(NSString *)type
                    StatusId:(NSString *)statusId
{
    if (self=[super init]) {
        
        _token=token;
        _nickName=nickName;
        _headImageUrl=headImageUrl;
        _publishDate=publishDate;
        _text=text;
        _imageUrls=imageUrls;
        _zan=zan;
        _type=type;
        _statusId=statusId;
        
    }
    return self;
}
@end
