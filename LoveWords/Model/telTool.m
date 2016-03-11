//
//  telTool.m
//  LoveWords
//
//  Created by xitouzhu on 15/12/30.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "telTool.h"

@implementation telTool
/* 是否是一个正确的手机号 */
+ (BOOL)checkPhoneNumber:(NSString *)phone
{
    //正则表达式
    NSString *pattern = @"^1+[3578]+\\d{9}$";
    //创建一个谓词,一个匹配条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    //评估是否匹配正则表达式
    BOOL isMatch = [pred evaluateWithObject:phone];
    return isMatch;

}
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern =@"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

@end

