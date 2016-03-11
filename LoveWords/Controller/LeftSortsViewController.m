//
//  ViewController.h
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//


#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "SayViewController.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "OtherViewController.h"
#import "EaseMob.h"
#import "ConstantDef.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//初始化manager


    
    
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //这里可以再实现下换肤功能
    imageview.image = [UIImage imageNamed:@"zhutou2"];
    [self.view addSubview:imageview];

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = HMColor(229, 138, 142);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"主页";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"说说墙";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"聊天室";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"设置";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"其他";
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"退出";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //关闭左侧抽屉
    [tempAppDelegate.leftSlideVC closeLeftView];
    
    

    if (indexPath.row==0) {
        //关闭左侧抽屉
   // [tempAppDelegate.leftSlideVC closeLeftView];
     
    }
   else if (indexPath.row==1) {
       //找到storyboard
       UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
       //跳到说说界面
        SayViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Say"];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    }
   else if (indexPath.row==2) {
       //找到storyboard
       UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
        //跳到聊天界面
        ChatViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Chat"];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
        
    }
    else if (indexPath.row==3) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
        SettingViewController *vc=[sb instantiateViewControllerWithIdentifier:@"Setting"];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==4)
    {
        //找到storyboard
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
        //跳到聊天界面
        ChatViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Other"];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    }
    else if (indexPath.row==5)
    {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"FirstStoryboard" bundle:[NSBundle mainBundle]];
        UIViewController *LoginVC=[sb instantiateViewControllerWithIdentifier:@"Nav"];
        [self presentViewController:LoginVC animated:YES completion:nil];
//退出环信聊天
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            SHOW_TEXT(@"退出成功");
        } onQueue:nil];
       
    }
    
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
