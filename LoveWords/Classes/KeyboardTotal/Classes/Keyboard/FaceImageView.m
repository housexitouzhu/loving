//
//  FaceImageView.m
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import "FaceImageView.h"
#import "Tools.h"
#import "ConstantDef.h"
@interface FaceImageView ()<UIScrollViewDelegate>
@property(strong,nonatomic)FaceItemBlock faceBlock;
@property(strong,nonatomic)BottomButtonBlock bottomBlock;
//@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIButton *recentButton;
@property(strong,nonatomic)UIButton *defaultButton;
@property(strong,nonatomic)UIButton *sendButton;
@property(strong,nonatomic)NSArray *faceDicArray;
@property(strong,nonatomic)UIPageControl *pageControll;
@end
@implementation FaceImageView
- (instancetype)init
{
    self = [super init];
    if (self)
    {
#pragma mark - 获取屏幕宽高
        CGFloat width = [[UIScreen mainScreen]bounds].size.width;
        _faceDicArray = [Tools fetchLocalFaceDicts];
        NSUInteger pages = _faceDicArray.count/32;
        if(_faceDicArray.count%32) pages++;
#pragma mark - 配置ScrollView
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.frame = CGRectMake(0, 0, width, 216);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(width*pages, 180);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        CGFloat scrollWidth = _scrollView.frame.size.width;
        CGFloat buttonWidth = scrollWidth/8;
        CGFloat buttonHeight = 180.0/4;
        [_faceDicArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            NSDictionary *dic = obj;
            NSString *imageName = dic[@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            NSUInteger cPage = idx/32;//页码
            NSUInteger cTag = idx%32;//当前页面的32个按钮
            NSUInteger rows = cTag/8;//第几行
            NSUInteger cols = cTag%8;//第几列
            CGFloat x = buttonWidth*cols+scrollWidth*cPage;
            CGFloat y = buttonHeight*rows;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:image forState:UIControlStateNormal];
            button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
            button.tag = idx;
            [button addTarget:self action:@selector(tapFaceItem:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }];
        
#pragma mark - 配置UIPageControl
        _pageControll = [[UIPageControl alloc]init];
        _pageControll.frame = CGRectMake(0, 178, 0, 6);
        _pageControll.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControll.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControll.numberOfPages = pages;
        _pageControll.currentPage = 0;
        [self addSubview:_pageControll];
#pragma mark - 配置底部的三个按钮
        
//        _recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _recentButton.frame = CGRectMake(0, 186, scrollWidth/3, 30);
//        [_recentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [_recentButton setTitle:@"最近" forState:UIControlStateNormal];
//        [_recentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        _recentButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _recentButton.layer.borderWidth = 1;
//        _recentButton.tag = BottomButtonTypeRecently;
//        [_recentButton addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_recentButton];
        
        
        _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_defaultButton.frame = CGRectMake(scrollWidth/3, 186, scrollWidth/3, 30);
        _defaultButton.frame=CGRectMake(0, 186, scrollWidth/2, 30);
        [_defaultButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_defaultButton setTitle:@"删除" forState:UIControlStateNormal];
        _defaultButton.tag = BottomButtonTypeDefaut;
        [_defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _defaultButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _defaultButton.layer.borderWidth = 1;
        _defaultButton.backgroundColor=HMColor(255, 192, 203);
        [_defaultButton addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_defaultButton];
        
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
       // _sendButton.frame = CGRectMake(scrollWidth*2/3, 186, scrollWidth/3, 30);
        _sendButton.frame=CGRectMake(scrollWidth/2, 186,scrollWidth/2 , 30);
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.tag = BottomButtonTypeSend;
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _sendButton.layer.borderWidth = 1;
        _sendButton.backgroundColor = HMColor(255, 192, 203);
        [_sendButton addTarget:self action:@selector(tapBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        
        
        

    }

    return self;
}

//点击表情按钮的事件
- (void)tapFaceItem:(UIButton *)sender
{
    if (_faceBlock) {
        _faceBlock(sender);
    }
}
/**
 *  点击了底部的四个按钮之一
 *
 *  @param sender 触发事件源
 */
- (void)tapBottomButton:(UIButton*)sender
{
    BottomButtonType type = (BottomButtonType)sender.tag;
    
    if (_bottomBlock) {
        _bottomBlock(type);
    }
}
- (void)setTapBottomButtonBlock:(BottomButtonBlock)bottomBlock
{
    self.bottomBlock = bottomBlock;
}
- (void)setTapFaceItemBlock:(FaceItemBlock)faceBlock
{
    self.faceBlock = faceBlock;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger offX = scrollView.contentOffset.x;
    _pageControll.currentPage = offX/scrollView.frame.size.width;
}

@end
