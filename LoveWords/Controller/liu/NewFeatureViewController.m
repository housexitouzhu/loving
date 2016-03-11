//
//  NewFeatureViewController.m
//  LoveWords
//
//  Created by xitouzhu on 15/12/23.
//  Copyright © 2015年 yulu. All rights reserved.
//


#define Inch ([UIScreen mainScreen].bounds.size.height ==736.0)
#define NewfeatureImageCount 4

#import "NewfeatureViewController.h"
#import "UIView+Extension.h"
#import "LoginViewController.h"
#import "ConstantDef.h"




@interface NewFeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation NewFeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
    [self setupPageControl];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<NewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"xt%d",i+1];
                imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == NewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(NewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
//warning 别在scrollView.subviews中通过索引来查找对应的子控件
    //    [scrollView.subviews lastObject];
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = NewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 20;
    [self.view addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = HMColor(253, 98, 42); // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = HMColor(189, 189, 189); // 非当前页的小圆点颜色
    self.pageControl = pageControl;
}

/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];
    

}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
//    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish1"] forState:UIControlStateNormal];
    startButton.backgroundColor=[UIColor clearColor];
    
    // 3.设置frame
    startButton.size = startButton.currentBackgroundImage.size;
    startButton.centerX = self.view.width * 0.5;
    startButton.centerY = self.view.height * 0.88;
    
    // 4.设置文字
    [startButton setTitle:@"Go" forState:UIControlStateNormal];
    
    [startButton setTitleColor:HMColor(255, 105, 180) forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始爱语
 */
- (void)start
{
    // 显示主控制器（HMTabBarController）
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FirstStoryboard" bundle:nil];
UIViewController *vc= [sb instantiateViewControllerWithIdentifier:@"Nav"];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    AYLoginViewController *vc = [[AYLoginViewController alloc]init];
//    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
    window.rootViewController = vc;
   
    
    
//
//    // 切换控制器
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = vc;
    // push : [self.navigationController pushViewController:vc animated:NO];
    // modal : [self presentViewController:vc animated:NO completion:nil];
    // window.rootViewController : window.rootViewController = vc;    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}

- (void)dealloc
{
NSLog(@"dealloc-------");
}

@end

