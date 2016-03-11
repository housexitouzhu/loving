//
//  ConstantDef.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//
#import "MBProgressHUD.h"
#ifndef ConstantDef_h
#define ConstantDef_h

/*----------后台接口-----------*/

//发送验证码
#define K_SENDCODE @"http://bokanappapi.sinaapp.com/AiYu/sendCode.php"
//注册新用户
#define K_REGISTER @"http://bokanappapi.sinaapp.com/AiYu/register.php"
//修改密码
#define K_RESETPASSWORD @"http://bokanappapi.sinaapp.com/AiYu/resetPassword.php"
//用户登录
#define K_LOGIN @"http://bokanappapi.sinaapp.com/AiYu/login.php"
//设置个人信息
#define K_SETPERSONALINFO @"http://bokanappapi.sinaapp.com/AiYu/setPersonalInfo.php"
//获取个人信息
#define K_GETPERSONALINFO @"http://bokanappapi.sinaapp.com/AiYu/getPersonalInfo.php"
//接受配对邀请
#define K_MATCH @"http://bokanappapi.sinaapp.com/AiYu/match.php"
//刷新匹配状态
#define K_GETMATCHSTATUS @"http://bokanappapi.sinaapp.com/AiYu/getMatchStatus.php"
//获取对方信息
#define K_GETLOVERSINFO @"http://bokanappapi.sinaapp.com/AiYu/getLoversInfo.php"
//解除匹配关系
#define K_REMOVEMATCHRELATION @"http://bokanappapi.sinaapp.com/AiYu/removeMatchRelation.php"
//发表状态/说说
#define K_PUBLISHSTATUS @"http://bokanappapi.sinaapp.com/AiYu/publishStatus.php"
//获取状态/说说
#define K_GETSTATUS @"http://bokanappapi.sinaapp.com/AiYu/getStatus.php"
//赞某条状态
#define K_ZAN @"http://bokanappapi.sinaapp.com/AiYu/zan.php"
//取消某条状态
#define K_CANCLEZAN @"http://bokanappapi.sinaapp.com/AiYu/cancleZan.php"
//删除某条状态
#define K_DELETESTATUS @"http://bokanappapi.sinaapp.com/AiYu/deleteStatus.php"
//上传文件到云存储
#define K_UPLOADFILE @"http://jiaoxue.bjbkws.com/qiniu/uploadFile.php"


/** ------- 设备宽高 --------*/

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/** ------- hud提示框 --------*/
#define SHOW_TEXT(text) MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];hud.mode = MBProgressHUDModeText;hud.labelText = text;hud.removeFromSuperViewOnHide = YES;[hud hide:YES afterDelay:1.5];

/** -------配置颜色-------*/

#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.8]
#endif /* ConstantDef_h */
