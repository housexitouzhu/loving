//
//  Account.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "Account.h"

@implementation Account
- (instancetype)initWithTel:(NSString *)tel
                 InfoStatus:(NSString *)infoStatus
                MatchStatus:(NSString *)matchStatus
                      Token:(NSString *)token
                     UserId:(NSString *)userId
                 MatchToken:(NSString *)matchToken
{
    if (self=[super init]) {
        _tel=tel;
        _infoStatus=infoStatus;
        _matchStatus=matchStatus;
        _token=token;
        _userId=userId;
        _matchToken=matchToken;
    }
    return self;
}
@end
