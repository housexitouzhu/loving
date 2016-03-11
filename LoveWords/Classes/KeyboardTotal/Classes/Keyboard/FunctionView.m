//
//  FunctionView.m
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import "FunctionView.h"
@interface FunctionView ()
@property(strong,nonatomic)FuncButtonBlock funcBlock;
@property(strong,nonatomic)UIButton *cameraButton;
@property(strong,nonatomic)UIButton *photoButton;
@property(strong,nonatomic)UIButton *locatiobButton;
@end
@implementation FunctionView


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //相机功能,待实现
        
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.frame = CGRectMake(10, 10, 50, 50);

        [_cameraButton setImage:[UIImage imageNamed:@"fun1"] forState:UIControlStateNormal];
        [self addSubview:_cameraButton];
        _cameraButton.tag = FuncButtonTypeCamera;
        [_cameraButton addTarget:self action:@selector(tapFuncbutton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake(70, 10, 50, 50);
        [_photoButton setImage:[UIImage imageNamed:@"fun2"] forState:UIControlStateNormal];
        [self addSubview:_photoButton];
        _photoButton.tag = FuncButtonTypePhoto;
        [_photoButton addTarget:self action:@selector(tapFuncbutton:) forControlEvents:UIControlEventTouchUpInside];
        
        //定位功能,待实现
//        _locatiobButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _locatiobButton.frame = CGRectMake(130, 10, 50, 50);
//        [_locatiobButton setImage:[UIImage imageNamed:@"fun3"] forState:UIControlStateNormal];
//        [self addSubview:_locatiobButton];
//        _locatiobButton.tag = FuncButtonTypeLocation;
//        [_locatiobButton addTarget:self action:@selector(tapFuncbutton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)tapFuncbutton:(UIButton*)sender
{
    if(_funcBlock)
    {
        _funcBlock((FuncButtonType)sender.tag);
    }
}
- (void)setFuncButtonBlock:(FuncButtonBlock)funcBlock
{
    self.funcBlock = funcBlock;
}

@end
