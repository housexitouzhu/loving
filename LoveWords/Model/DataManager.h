//
//  DataManager.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "LoverInfo.h"
#import "Status.h"
#import "Account.h"
/**
 *
 * block定义
 *
 */
/**
 *  返回值为两个参数:code/result,统一定为一个block
 *
 *  @param code   请求状态码:200请求成功,400请求失败(参数有误,等)
 *  @param result 请求结果:0发送验证码成功,1失败
 *
 *  @return 空
 */

//发送验证码的block  2
//赞/取消赞说说的block  2
//删除说说的block  2
typedef void(^BlockOfTwoReturn)(NSString *code,NSString *result);


/**
 *  返回值为三个参数:code/result/error的,统一定为一个block
 *
 *  @param code    请求状态码:200请求成功,400请求失败(参数有误,等)
 *  @param result  请求结果:0发送验证码成功,1失败
 *  @param error   错误原因:result=0时,没有该项
 *
 *  @return 空
 */
//注册的block 3
//修改密码的block 3
//设置个人信息的block 3
//配对的block 3
//刷新配对的block 3
//解除匹配的block 3
//发送状态的block 3
typedef void(^BlockOfThreeReturn)(NSString *code,NSString *result,NSString *error);
/**
 *  带实体的block
 *
 *  @param code    请求状态码:200请求成功,400请求失败(参数有误,等)
 *  @param result  请求结果:0发送验证码成功,1失败
 *  @param account 返回的数据撞到一个实体里面
 *
 *  @return 空
 */
//登陆的block
typedef void(^BlockOfLogin)(NSString *code,NSString *result,NSString *error,Account *account);
//获取个人信息的block
typedef void(^BlockOfGetPersonalInfo)(NSString *code,NSString *result,UserInfo *userInfo);
//获取恋人信息的block
typedef void(^BlockOfGetLoverInfo)(NSString *code,NSString *result,LoverInfo *loverInfo);

/******
 *
 *获取说说的block
 *
 *******/
typedef void(^BlockOfGetStatus)(NSString *code,NSString *result,NSString *error,NSString *totolPages, NSArray *arr);
/********
 *
 *上传的block
 *
 ********/
typedef void(^BlockOfUpLoad)(NSString *code,NSString *url);

@interface DataManager : NSObject
/**
 *  发送验证码的类型,默认为注册.
 */
typedef NS_ENUM(NSUInteger,sendCodeType) {
    /**
     *  注册
     */
    sendCodeTypeRegister,
    /**
     *  修改密码
     */
    sendCodeTypeOfResetPassword
};

/**
 *  创建单例对象
 */
#pragma mark -创建单例对象
+ (instancetype)shareManager;

/**
 *  发送验证码方法:每天总共有8次机会发送注册验证码和找回密码验证码
 *
 *  @param tel    手机号
 *  @param type   发送验证码的类型
 *  @param sBlock 成功或失败要走的block,返回两个参数,一个是请求是否成功,一个是发送验证码是否成功
 */
#pragma mark -发送验证码
- (void)requestSendCodeWithTel:(NSString *)tel
                          Type:(sendCodeType)type
                   Complention:(BlockOfTwoReturn)sBlock;
/**
 *  注册:根据手机号,密码,验证码进行新用户注册
 *
 *  @param tel      手机号
 *  @param password 密码
 *  @param code     验证码
 *  @param sBlock   成功或失败要走的block,返回三个参数,一个请求是否成功,第二个注册账号是否成功,第三个注册失败时返回的错误信息
 */
#pragma mark -注册新用户
- (void)requestRegisterWithTel:(NSString *)tel
                          Code:(NSString *)code
                      Password:(NSString *)password
                    Completion:(BlockOfThreeReturn)sBlock;
/**
 *  修改密码:根据手机号,新密码,验证码修改
 *
 *  @param tel         手机号
 *  @param newPassword 新密码
 *  @param code        验证码
 *  @param sBlock      成功或失败要走的block,返回三个参数,一个请求是否成功,第二个修改密码是否成功,第三个修改失败时返回的错误信息
 */
#pragma mark -修改密码
- (void)requestResetPasswordWithTel:(NSString *)tel
                        NewPassword:(NSString *)newPassword
                               Code:(NSString *)code
                        Complention:(BlockOfThreeReturn)sBlock;
/**
 *  登陆:使用手机号,密码登陆,可以返回一些信息
 *
 *  @param tel      手机号
 *  @param password 密码
 *  @param sBlock   成功或失败要走的block,返回三个参数,第一个是请求状态,第二个是注册是否成功,第三个是返回一个字典
 */
#pragma mark -用户登陆
- (void)requestLoginWithTel:(NSString *)tel
                   Password:(NSString *)password
                Complention:(BlockOfLogin)sBlock;

/**
 *  设置个人信息
 *
 *  @param token            登录用户的token
 *  @param userName         用户名
 *  @param userHeadImageUrl 用户头像
 *  @param userSex          用户性别 0:男 1:女
 *  @param userAutograph    用户签名
 *  @param sBlock           成功或失败要走的block,返回三个参数,第一个是请求状态,第二个是注册是否成功,第三个是返回失败的原因
 */
#pragma mark -设置个人信息
- (void)RequestSetPersonalInfoWithToken:(NSString *)token
                               UserName:(NSString *)userName
                       UserHeadImageUrl:(NSString *)userHeadImageUrl
                                UserSex:(NSString *)userSex
                          UserAutograph:(NSString *)userAutograph
                            Complention:(BlockOfThreeReturn)sBlock;
/**
 *  获取个人信息的方法
 *
 *  @param token  登录用户的token
 *  @param sBlock 成功或失败要走的block,返回两个参数,第一个是否成功,第二个是否有用户实体
 */
#pragma mark -获取个人信息
- (void)requestGetPersonalInfoWithToken:(NSString *)token
                            Complention:(BlockOfGetPersonalInfo)sBlock;
/**
 *  获取恋人信息的方法
 *
 *  @param token  登录用户的token
 *  @param sBlock 成功或失败要走的block,返回两个参数,第一个是否成功,第二个是否有恋人实体
 */
#pragma mark -获取恋人信息
- (void)requestGetLoverInfoWithToken:(NSString *)token
                         Complention:(BlockOfGetLoverInfo)sBlock;
/**
 *  匹配
 *
 *  @param token      用户的token
 *  @param matchtoken 邀请人的匹配token
 *  @param sBlock     成功或者失败要走的代码,返回三个是参数,第一个是请求结果,第二个是接受配对邀请的结果,第三个是接受配对邀请失败的时候才有提示,表示接受配对邀请失败的原因
 */
#pragma mark -匹配方法
- (void)requestMatchWithToken:(NSString *)token
                   MatchToken:(NSString *)matchtoken
                  Complention:(BlockOfThreeReturn)sBlock;
/**
 *  刷新匹配状态
 *
 *  @param token  登陆用户的token
 *  @param sBlock 成功或者失败要走的代码,返回三个是参数,第一个是请求结果,第二个是匹配的结果,第三个是匹配失败的时候才有提示,表示匹配失败的原因
 */
#pragma mark -刷新匹配状态
- (void)requestRefreshMatchStatusWithToken:(NSString *)token
                               Complention:(BlockOfThreeReturn)sBlock;
/**
 *  解除匹配的方法
 *
 *  @param token  用户的token
 *  @param sBlock 成功或者失败要走的代码,返回三个是参数,第一个是请求结果,第二个是解除匹配关系的结果,第三个是解除匹配关系失败的时候才有提示,表示解除匹配关系失败的原因
 
 */
#pragma mark -解除匹配关系
- (void)requestRemoveMatchRelationWithToken:(NSString *)token
                                Complention:(BlockOfThreeReturn)sBlock;
/**
 *  发表说说的方法
 *
 *  @param token     登陆用户的token
 *  @param type      说说类型描述:纯文本(text)跟文本图片混合(image)
 *  @param text      文本内容
 *  @param imageUrls 图片地址(imageURLs是一个字符串,是多张图片路径使用竖线拼接的字符串,获取的状态亦是如此:示例: http://aa.png|http://bb.png)
 *  @param sBlock    成功或者失败要走的代码,返回三个是参数,第一个是请求结果,第二个是发表说说的结果,第三个是发表说说失败的时候才有提示,表示发表说说失败的原因
 
 */
#pragma mark -发表说说
- (void)requestPublishStatusWithToken:(NSString *)token
                                 Type:(NSString *)type
                                 Text:(NSString *)text
                            ImageUrls:(NSString *)mageUrls
                          Complention:(BlockOfThreeReturn)sBlock;
/**
 *  获取说说,每页20条
 *
 *  @param token  登录用户的token
 *  @param page   页码,N默认1
 *  @param sBlock 成功或者失败要走的代码,返回三个是参数,第一个是请求结果,第二个是获取说说的结果,第三个是获取说说失败的时候才有提示,表示获取说说失败的原因.
 */
#pragma mark -获取说说
- (void)requestGetStatuswithToken:(NSString *)token
                             Page:(NSString *)page
                      Complention:(BlockOfGetStatus)sBlock;
/**
 *  赞的方法
 *
 *  @param token    登陆用户的token
 *  @param statusId 说说唯一ID
 *  @param sBlock   成功或者失败要走的代码,返回两个是参数,第一个是请求结果,第二个是赞某条说说的结果
 */
#pragma mark -赞的方法
- (void)requestZanWithToken:(NSString *)token
                   StatusId:(NSString *)statusId
                Complention:(BlockOfTwoReturn)sBlock;
/**
 *  取消赞的方法
 *
 *  @param token    登陆用户的token
 *  @param statusId 说说唯一标示ID
 *  @param sBlock   成功或者失败要执行的代码,返回两个参数,第一个是请求结果,第二个是取消赞某条说说的结果
 */
#pragma mark -取消赞的方法
- (void)RequestCancelZanWithToken:(NSString *)token
                         StatusId:(NSString *)statusId
                      Complention:(BlockOfTwoReturn)sBlock;
/**
 *  删除说说的方法
 *
 *  @param token    登陆用户的token
 *  @param statusId 说说唯一标识ID
 *  @param sBlock   成功或者失败要执行的代码,返回两个是参数,第一个是请求结果,第二个是删除某条说说的结果
 */
#pragma mark -删除说说
- (void)requestDeleteStatusWithToken:(NSString *)token
                            StatusId:(NSString *)statusId
                         Complention:(BlockOfTwoReturn)sBlock;
/**
 *  上传文件到云存储
 *
 *  @param file   内容
 *  @param sBlock 成功或者失败要执行的代码,返回两个参数,第一个参数是上传的结果,第二个参数是文件的远程路径
 
 */
#pragma mark -上传文件到云存储
- (void)requestUploadWithFiles:(NSData *)file
                   Complention:(BlockOfUpLoad)sBlock;
@end
