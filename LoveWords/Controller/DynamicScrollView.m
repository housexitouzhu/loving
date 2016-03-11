//
//  DynamicScrollView.m
//  LoveWords
//
//  Created by Ibokan on 15/12/27.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "DynamicScrollView.h"

@implementation DynamicScrollView

{
    float width;
    float height;
    NSMutableArray *imageViews;
    float singleWidth;
    BOOL isDeleting;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
    TapButtonOfDeleteBlock bBlock;
}

@synthesize scrollView,imageViews,isDeleting;
#pragma mark-设置scrollView的背景
- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240 green:240 blue:255 alpha:0.8];
        UIScreen *screen = [UIScreen mainScreen];
        width = screen.bounds.size.width;
        height = screen.bounds.size.height;
        imageViews = [NSMutableArray arrayWithCapacity:images.count];
        self.images = images;
        //  singleWidth = width/(images.count-1);
        singleWidth = width/4;
        //创建底部滑动视图
        [self _initScrollView];
        [self _initViews];
    }
    return self;
}

- (void)_initScrollView
{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
       
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
    }
}

- (void)_initViews
{
    for (int i = 0; i < self.images.count; i++) {
        NSString *imageName = self.images[i];
        [self createImageViews:i withImageName:imageName];
    }
    self.scrollView.contentSize = CGSizeMake(self.images.count * singleWidth, self.scrollView.frame.size.height);
}

- (void)createImageViews:(int)i
           withImageName:(NSString *)imageName
{
    //UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    UIImageView *imgView=[[UIImageView alloc]init];
    
    imgView.image=[self strToImage:imageName];
    imgView.frame = CGRectMake(singleWidth*i, 0, singleWidth, self.scrollView.frame.size.height);
    imgView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imgView];
    [imageViews addObject:imgView];
    
//长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [imgView addGestureRecognizer:longPress];
    
//添加了删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"deleteButton-lucien"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    if (isDeleting) {
        [deleteButton setHidden:NO];
    } else {
        [deleteButton setHidden:YES];
    }
    deleteButton.frame = CGRectMake(0, 0, 25, 25);
    deleteButton.backgroundColor = [UIColor lightGrayColor];
    [imgView addSubview:deleteButton];
}
//把字符串转换成图片
-(UIImage *)strToImage:(NSString *)strImage
{
    NSData *dataImage=[[NSData alloc]initWithBase64EncodedString:strImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage=[UIImage imageWithData:dataImage];
    return decodedImage;
}

//长按调用的方法
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {//长按开始
        startPoint = [recognizer locationInView:recognizer.view];
        originPoint = imageView.center;
        isDeleting = !isDeleting;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        for (UIImageView *imageView in imageViews) {
            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
            if (isDeleting) {
                deleteButton.hidden = NO;
            } else {
                deleteButton.hidden = YES;
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {//长按移动
        CGPoint newPoint = [recognizer locationInView:recognizer.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        imageView.center = CGPointMake(imageView.center.x + deltaX, imageView.center.y + deltaY);
        NSInteger index = [self indexOfPoint:imageView.center withView:imageView];
        if (index < 0) {
            isContain = NO;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint temp = CGPointZero;
                UIImageView *currentImagView = imageViews[index];
                int idx = [imageViews indexOfObject:imageView];
                temp = currentImagView.center;
                currentImagView.center = originPoint;
                imageView.center = temp;
                originPoint = imageView.center;
                isContain = YES;
                [imageViews exchangeObjectAtIndex:idx withObjectAtIndex:index];
            } completion:^(BOOL finished) {
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {//长按结束
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformIdentity;
            if (!isContain) {
                imageView.center = originPoint;
            }
        }];
    }
    NSLog(@"*/**/*/*/**/%@",imageViews);
    NSLog(@"6666666666%@",imageView);
}

//获取view在imageViews中的位置
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view
{
    UIImageView *originImageView = (UIImageView *)view;
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *otherImageView = imageViews[i];
        if (otherImageView != originImageView) {
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

-(void)setTapButtonOfDeleteBlock:(TapButtonOfDeleteBlock)aBlock
{
    bBlock=aBlock;
}

#pragma -mark 删除图片

- (void)deleteAction:(UIButton *)button
{
    isDeleting = YES;   //正处于删除状态
    UIImageView *imageView = (UIImageView *)button.superview;
    __block int index =[imageViews indexOfObject:imageView];
    NSLog(@"移除的第几个%lu",(unsigned long)[imageViews indexOfObject:imageView]);
    self.deleteImageCount=[NSString stringWithFormat:@"%lu",(unsigned long)[imageViews indexOfObject:imageView]];
    if (bBlock)
    {
        bBlock(self.deleteImageCount);
    }
   //利用user传值
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    [user setObject:self.deleteImageCount forKey:@"deleteImageCount"];
//    [user synchronize];
    
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = index + 1; i < imageViews.count; i++) {
                UIImageView *otherImageView = imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
        } completion:^(BOOL finished) {
            [imageViews removeObject:imageView];
            if (imageViews.count > 4) {
                weakScroll.contentSize = CGSizeMake(singleWidth*imageViews.count, scrollView.frame.size.height);
            }
        }];
    }];
}

//添加一个新图片
- (void)addImageView:(NSString *)imageName
{
    [self createImageViews:imageViews.count withImageName:imageName];
    
    self.scrollView.contentSize = CGSizeMake(singleWidth*imageViews.count, self.scrollView.frame.size.height);
    //图片大于4张
    if (imageViews.count > 4) {
        [self.scrollView setContentOffset:CGPointMake((imageViews.count-4)*singleWidth, 0) animated:YES];
    }
}



@end
