//
//  telTool.h
//  LoveWords
//
//  Created by xitouzhu on 15/12/30.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface telTool : NSObject
+ (BOOL)checkPhoneNumber:(NSString *)phone;
+ (BOOL)checkPassword:(NSString *) password;

@end
