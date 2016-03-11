//
//  MatchViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "MatchViewController.h"
#import "CheckViewController.h"
#import "GetSecretViewController.h"
@interface MatchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getSecretButton;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet UILabel *matchLable;
@property (weak, nonatomic) IBOutlet UILabel *matchExplainLable;
@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"配对";

self.navigationController.hidesBottomBarWhenPushed=YES;
 
    //设置返回按钮
    UIBarButtonItem *backButton=[UIBarButtonItem new];
    backButton.title=@" ";
    self.navigationItem.backBarButtonItem=backButton;
    self.matchExplainLable.numberOfLines=5;
    
//    self.navigationItem.hidesBackButton = YES;//直接隐藏掉了返回按钮
    
}

//验证码
- (IBAction)getSecretButton:(UIButton *)sender
{
    
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
    
    GetSecretViewController *vc=[sb instantiateViewControllerWithIdentifier:@"GetSecret"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//校验
- (IBAction)checkButton:(id)sender
{
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Match" bundle:[NSBundle mainBundle]];
    
    CheckViewController *vc=[sb instantiateViewControllerWithIdentifier:@"Check"];
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
