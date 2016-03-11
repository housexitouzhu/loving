//
//  DataManager.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "ConstantDef.h"
#import "Account.h"
#import "UserInfo.h"
#import "LoverInfo.h"
#import "Status.h"
@interface DataManager ()
@property (nonatomic,strong) AFHTTPSessionManager *afManager;
@end

@implementation DataManager

#pragma mark 单例实现
+ (instancetype)shareManager
{
    static DataManager *manager=nil;
     static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          manager =[[DataManager alloc]init];
     });
    return manager;
}
#pragma mark init初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化afManager
        self.afManager=[AFHTTPSessionManager  manager];
        //设置手动解析
        self.afManager.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
    return self;
}
#pragma mark -发送验证码
- (void)requestSendCodeWithTel:(NSString *)tel
                          Type:(sendCodeType)type
                   Complention:(BlockOfTwoReturn)sBlock
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"tel"]=tel;
    params[@"type"]=@"0";
    switch (type) {
        case sendCodeTypeRegister:
            params[@"type"]=@"0";
            break;
        case sendCodeTypeOfResetPassword:
            params[@"type"]=@"1";
            break;
            
        default:
            break;
    }
    
    [self.afManager GET:K_SENDCODE parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSString *result=[NSString stringWithFormat:@"%@", [dic[@"data"]firstObject][@"result"]];
        
        if (sBlock) {
            sBlock(code,result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}
#pragma mark -注册新用户
- (void)requestRegisterWithTel:(NSString *)tel
                          Code:(NSString *)code
                      Password:(NSString *)password
                    Completion:(BlockOfThreeReturn)sBlock
{
    NSDictionary *params=@{@"tel":tel,@"code":code,@"password":password};
    [self.afManager GET:K_REGISTER parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *code =[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            if (sBlock) {
                sBlock(code,result,error);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog( @"注册信息错误:++++++++%@",error);
    }];
}
#pragma mark -修改密码
- (void)requestResetPasswordWithTel:(NSString *)tel
                        NewPassword:(NSString *)newPassword
                               Code:(NSString *)code
                        Complention:(BlockOfThreeReturn)sBlock
{
    NSDictionary *params=@{@"tel":tel,@"newPassword":newPassword,@"code":code};
    [self.afManager GET:K_RESETPASSWORD parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *code =[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            if (sBlock) {
                sBlock(code,result,error);
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改密码的错误信息是:%@",error);
    }];
}
#pragma mark -用户登陆
- (void)requestLoginWithTel:(NSString *)tel
                   Password:(NSString *)password
                Complention:(BlockOfLogin)sBlock
{
    NSDictionary *params=@{@"tel":tel,@"password":password};
    [self.afManager GET:K_LOGIN parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"登陆的时候的dic=%@",dic);
        NSString *code =[NSString stringWithFormat:@"%@",dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            NSString *result=[NSString stringWithFormat:@"%@",dic[@"result"]];
            NSString *error=dic[@"error"];
        Account *account=[[Account alloc]initWithTel:tel InfoStatus:dic[@"infoStatus"] MatchStatus:dic[@"matchStatus"] Token:dic[@"token"] UserId:dic[@"userId"] MatchToken:dic[@"matchToken"]];
 
            sBlock(code,result,error,account);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改密码的错误信息是:%@",error);
    }];
    
}
#pragma mark -设置个人信息
- (void)RequestSetPersonalInfoWithToken:(NSString *)token
                               UserName:(NSString *)userName
                       UserHeadImageUrl:(NSString *)userHeadImageUrl
                                UserSex:(NSString *)userSex
                          UserAutograph:(NSString *)userAutograph
                            Complention:(BlockOfThreeReturn)sBlock
{
    NSDictionary *params=@{@"token":token,@"nickName":userName,@"headImageURL":userHeadImageUrl,@"sex":userSex,@"sign":userAutograph};
    
    [self.afManager GET:K_SETPERSONALINFO parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"个人信息%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            sBlock(code,result,error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"错误信息为:%@",error);
    }];
}
#pragma mark -获取个人信息
- (void)requestGetPersonalInfoWithToken:(NSString *)token
                            Complention:(BlockOfGetPersonalInfo)sBlock
{
    [self.afManager GET:K_GETPERSONALINFO parameters:@{@"token":token} progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"我的信息dic=%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        
        
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSDictionary *dicUserInfo=dic[@"userInfo"];
            
            UserInfo *info=[UserInfo new];
            info.userName=dicUserInfo[@"nickName"];
            info.userHeadImageUrl=dicUserInfo[@"headImageURL"];
            info.userSex=dicUserInfo[@"sex"];
            info.userAutograph=dicUserInfo[@"sign"];
            info.userMatchStatus=dicUserInfo[@"matchStatus"];
            info.userId=dicUserInfo[@"userId"];
            info.usertMatchToken=dicUserInfo[@"matchToken"];
                
                sBlock(code,result,info);
           
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
#pragma mark -匹配方法
- (void)requestMatchWithToken:(NSString *)token
                   MatchToken:(NSString *)matchtoken
                  Complention:(BlockOfThreeReturn)sBlock
{
    NSDictionary *params=@{@"token":token,@"matchToken":matchtoken};
    
    [self.afManager GET:K_MATCH parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data ) {
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            
            sBlock(code,result,error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"匹配的错误信息:%@",error);
    }];
}
#pragma mark -刷新匹配状态
- (void)requestRefreshMatchStatusWithToken:(NSString *)token
                               Complention:(BlockOfThreeReturn)sBlock
{
    [self.afManager GET:K_GETMATCHSTATUS parameters:token progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"刷新匹配状态=%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            
            sBlock(code,result,error);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"刷新配对的错误信息:%@",error);
    }];
}
#pragma mark -获取恋人信息
- (void)requestGetLoverInfoWithToken:(NSString *)token
                         Complention:(BlockOfGetLoverInfo)sBlock
{
    [self.afManager GET:K_GETLOVERSINFO parameters:@{@"token":token} progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"恋人信息dic=%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        
        
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSDictionary *dicLoverInfo=dic[@"loverInfo"];
            
            LoverInfo *info=[LoverInfo new];
                info.loverName=dicLoverInfo[@"loverNickName"];
                info.loverHeadImageUrl=dicLoverInfo[@"loverHeadImageURL"];
            NSLog(@"info.hi=%@",info.loverHeadImageUrl);
                info.loverSex=dicLoverInfo[@"loverSex"];
                info.loverAutograph=dicLoverInfo[@"loverSign"];
                info.loverMatchDate=dicLoverInfo[@"matchDate"];
                info.loverId=dicLoverInfo[@"loverUserId"];
                
                
                sBlock(code,result,info);
           
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取恋人信息的错误信息:%@",error);
    }];
}
#pragma mark -解除匹配关系
-(void)requestRemoveMatchRelationWithToken:(NSString *)token
                               Complention:(BlockOfThreeReturn)sBlock
{
    [self.afManager GET:K_REMOVEMATCHRELATION parameters:@{@"token":token} progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"解除配对code=%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            sBlock(code,result,error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"解除匹配关系的错误信息:%@",error);
    }];
}
#pragma mark -发表说说
- (void)requestPublishStatusWithToken:(NSString *)token
                                 Type:(NSString *)type
                                 Text:(NSString *)text
                            ImageUrls:(NSString *)imageUrls
                          Complention:(BlockOfThreeReturn)sBlock
{
    NSDictionary *params=@{@"token":token,@"type":type,@"text":text,@"imageURLs":imageUrls};
    [self.afManager GET:K_PUBLISHSTATUS parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"发表说说=%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@", dic[@"result"]];
            NSString *error=dic[@"error"];
            sBlock(code,result,error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发表说说失败的原因:%@",error);
    }];
    
}
#pragma mark -获取说说
- (void)requestGetStatuswithToken:(NSString *)token
                             Page:(NSString *)page
                      Complention:(BlockOfGetStatus)sBlock
{
    NSDictionary *params=@{@"token":token,@"page":page};
    [self.afManager GET:K_GETSTATUS parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取说说的内容的dic=%@",dic);
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        NSDictionary *dicData=[data firstObject];
        
        NSMutableArray *marr=[[NSMutableArray alloc]init];
        
        NSString *result=[NSString stringWithFormat:@"%@", dicData[@"result"]];
        NSString *error=dicData[@"error"];
        NSString *totolPages=[NSString stringWithFormat:@"%@",dicData[@"totolPages"]];
        NSArray *arr=dicData[@"status"];
       [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Status *status=[[Status alloc]initWithToken:obj[@"token"] NickName:obj[@"nickName"] HeadImageUrl:obj[@"headImageURL"] PublishDate:obj[@"publishDate"] Text:obj[@"text"] ImageUrls:obj[@"imageURLs"] Zan:obj[@"zan"] Type:obj[@"type"] StatusId:obj[@"statusId"]];
           [marr addObject:status];

       }];
        
        sBlock(code,result,error,totolPages,marr);
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取说书哦失败的原因:%@",error);
    }];
    
}
#pragma mark -赞的方法
- (void)requestZanWithToken:(NSString *)token
                   StatusId:(NSString *)statusId
                Complention:(BlockOfTwoReturn)sBlock
{
    NSDictionary *params=@{@"token":token,@"statusId":statusId};
    [self.afManager GET:K_ZAN parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSString *result=[NSString stringWithFormat:@"%@",[dic[@"data"]firstObject][@"result"]];
        
        if (sBlock) {
            sBlock(code,result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"赞说说失败的原因:%@",error);
    }];
}
#pragma mark -取消赞的方法
- (void)RequestCancelZanWithToken:(NSString *)token
                         StatusId:(NSString *)statusId
                      Complention:(BlockOfTwoReturn)sBlock
{
    NSDictionary *params=@{@"token":token,@"statusId":statusId};
    [self.afManager GET:K_CANCLEZAN parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *code=[NSString stringWithFormat:@"%@", dic[@"code"]];
        NSArray *data=dic[@"data"];
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@",dic[@"result"]];
            
            sBlock(code,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"赞说说失败的原因:%@",error);
    }];
}
#pragma mark -删除说说
- (void)requestDeleteStatusWithToken:(NSString *)token
                            StatusId:(NSString *)statusId
                         Complention:(BlockOfTwoReturn)sBlock
{
    NSDictionary *params=@{@"token":token,@"statusId":statusId};
    [self.afManager GET:K_DELETESTATUS parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *code=[NSString stringWithFormat:@"%@",dic[@"code"]];
        NSArray *data=dic[@"data"];
        NSLog(@"删除说说---------%@",dic);
        for (NSDictionary *dic in data) {
            
            NSString *result=[NSString stringWithFormat:@"%@",dic[@"result"]];
            
            sBlock(code,result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除说说失败的原因:%@",error);
    }];
}
#pragma mark -上传文件到云存储
- (void)requestUploadWithFiles:(NSData *)file
                   Complention:(BlockOfUpLoad)sBlock
{
    [self.afManager POST:K_UPLOADFILE parameters:@{@"file":file} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //图片上传
        [formData appendPartWithFileData:file name:@"file" fileName:@"xxx.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull downloadProgress) {
        //无进度条设置
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动解析下
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *success=dic[@"success"];
        NSString *url=dic[@"url"];
        sBlock(success,url);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传云存储的失败原因:%@",error);
    }];
    
    
}
@end
