//
//  SayViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//
#import "SayViewController.h"
#import "AppDelegate.h"
#import "AddSayViewController.h"
#import "DataManager.h"
#import "MJRefresh.h"
#import "Status.h"
#import "UITableViewCell+Config.h"
#import "ConstantDef.h"
@interface SayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonOfAddSay;
@property (strong, nonatomic) IBOutlet UITableView *tableViewOfSay;
@property (nonatomic,strong) DataManager *manager;
@property (nonatomic,assign) int pageOfSay;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSString *statusId;
@property (nonatomic,assign) int maxPages;
@end

@implementation SayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//初始化page
    self.pageOfSay=1;
//初始化marr
    self.data=[NSMutableArray new];
//初始化manager
    self.manager=[DataManager shareManager];
//设置代理
    self.tableViewOfSay.dataSource=self;
    self.tableViewOfSay.delegate=self;
//设置自动行高
    self.tableViewOfSay.rowHeight=UITableViewAutomaticDimension;
    self.tableViewOfSay.estimatedRowHeight=120;
//去掉tableView下面的线
    self.tableViewOfSay.separatorStyle=UITableViewCellSeparatorStyleNone;
//设置刷新
     //__weak typeof(self) weak_self = self;
    self.tableViewOfSay.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDown)];
   self.tableViewOfSay.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
//设置去掉顶部空白
//    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.tableViewOfSay.tableFooterView=[UIView new];
//    self.edgesForExtendedLayout=NO;
//界面的颜色标题
   self.view.backgroundColor = [UIColor blueColor];
   self.navigationItem.title=@"说说界面";
//注册cell
    [self.tableViewOfSay registerNib:[UINib nibWithNibName:@"MySayTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MySayTextCell"];
    [self.tableViewOfSay registerNib:[UINib nibWithNibName:@"MySayImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MySayImageCell"];
//视图加载完毕,进行刷新

  
    //开辟子线程获取数据
    [self fetchData];

}

//获取数据
-(void)fetchData
{
    //初始化一个子线程
    NSOperationQueue *queueOne=[[NSOperationQueue alloc]init];
    
    [queueOne addOperationWithBlock:^{
   
     }];
        
        //在主队列更新UI
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        __weak typeof(self) weak_self = self;
        NSString *page=[NSString stringWithFormat:@"%d",self.pageOfSay];
        //获取token
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSString *token=[user objectForKey:@"token"];
            //调用方法获取说说数据
            [self.manager requestGetStatuswithToken:token Page:page Complention:^(NSString *code, NSString *result, NSString *error, NSString *totolPages, NSArray *arr) {
                weak_self.maxPages=totolPages.intValue;
                
                [weak_self.data addObjectsFromArray:arr];
                NSLog(@"weak_self.marr addObject:status=%@",weak_self.data);
                if ([result isEqualToString:@"1"])
                {
                    SHOW_TEXT(error);
                    return ;
                }
                
                if ([totolPages isEqualToString:@"0"]) {
                    [weak_self.tableViewOfSay.header endRefreshing];
                }
                
             [weak_self.tableViewOfSay reloadData];
            
            //设置刷新完毕后,关闭refresh
            [weak_self.tableViewOfSay.header endRefreshing];
           
            [weak_self.tableViewOfSay.footer endRefreshing];
           
        }];
    }];
    
    
    
    


}
-(void)dropDown
{
    self.pageOfSay=1;
    self.data=[NSMutableArray new];
    [self fetchData];
    
}
-(void)nextPage
{
    self.pageOfSay++;
    if (self.pageOfSay>self.maxPages)
    {
        [self.tableViewOfSay.footer endRefreshingWithNoMoreData];
        return;
    }
    [self fetchData];
 
    
 
}
#pragma mark-添加说说按钮
- (IBAction)tapBarButtonOfAddSay:(UIBarButtonItem *)sender
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    AddSayViewController *vc=[sb instantiateViewControllerWithIdentifier:@"AddSay"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//设置tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Status *status=self.data[indexPath.row];

    
    if ([status.type isEqualToString:@"image"]) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MySayImageCell" forIndexPath:indexPath];
        Status *status=self.data[indexPath.row];
        [cell configCellForSay:status];
//配置图片cell的button
        [cell setTapButtonOfImageGrade:^(id obj, int i) {
            if (i%2==0) {
            [obj setBackgroundImage:[UIImage imageNamed:@"zan-0-lucien"] forState:UIControlStateNormal];
                  SHOW_TEXT(@"赞取消");
            }
            else if (i%2==1)
            {
            [obj setBackgroundImage:[UIImage imageNamed:@"zan-1-lucien"] forState:UIControlStateNormal];
                  SHOW_TEXT(@"赞成功");
            }
        }];
    
        return cell;
        
      // [button setBackgroundImage:[UIImage imageNamed:@"zan-1-lucien"] forState:UIControlStateNormal];

    }
    UITableViewCell *cellT=[tableView dequeueReusableCellWithIdentifier:@"MySayTextCell" forIndexPath:indexPath];
    
    Status *statusT=self.data[indexPath.row];
    [cellT configCellForSay:statusT];
    [cellT setTapButtonOfTextGrade:^(id obj, int i) {
        if (i%2==0) {
            [obj setBackgroundImage:[UIImage imageNamed:@"zan-0-lucien"] forState:UIControlStateNormal];
            SHOW_TEXT(@"赞取消");
            
        }
        else if (i%2==1)
        {
            [obj setBackgroundImage:[UIImage imageNamed:@"zan-1-lucien"] forState:UIControlStateNormal];
            SHOW_TEXT(@"赞成功");
        }
    }];
    return cellT;
}

//选中时,不改变cell的颜色
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//删除说说
-(BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Status *status=self.data[indexPath.row];
    self.statusId=status.statusId;
    NSLog(@"status.statusId\\\\\\\\\%@",self.statusId);
//获取token
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *token=[user objectForKey:@"token"];
//获取

    __weak typeof(self) weak_self = self;
    [weak_self.manager requestDeleteStatusWithToken:token StatusId:self.statusId Complention:^(NSString *code, NSString *result) {
        if ([code isEqualToString:@"200"]&&[result isEqualToString:@"0"]) {
           //移除本行数据
            [self.data removeObjectAtIndex:indexPath.row];
            
            //移除动画
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            SHOW_TEXT(@"删除成功");
        }
        else
        {
            SHOW_TEXT(@"您不能删除对方的状态");
        }
   
    }];
}

//设置左侧菜单

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.leftSlideVC.closed)
    {
        [tempAppDelegate.leftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
}

//视图将要出现的时候



@end
