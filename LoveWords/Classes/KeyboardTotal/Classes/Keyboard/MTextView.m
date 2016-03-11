//
//  MTextView.m
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import "MTextView.h"
@interface MTextView ()
@property(strong,nonatomic)FaceImageView *faceView;
@property(strong,nonatomic)FunctionView *funcView;
@property(strong,nonatomic)BottomButtonBlock bottomBlock;
//textView接收外界的block
@property(strong,nonatomic)FuncButtonBlock funButtonBlock;
@end
@implementation MTextView
-(void)setTapBottomButtonBlock:(BottomButtonBlock)bottomBlock
{
    self.bottomBlock = bottomBlock;
}

//textView接收外界传来的block
- (void)setFuncButtonBlock:(FuncButtonBlock)funcBlock
{
    self.funButtonBlock = funcBlock;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        CGFloat height = [[UIScreen mainScreen]bounds].size.height;
        CGFloat width  = [[UIScreen mainScreen]bounds].size.width;
        _faceView = [[FaceImageView alloc]init];
        _faceView.backgroundColor = [UIColor lightGrayColor];
        _faceView.frame = CGRectMake(0, height-216, width, 216);
#pragma mark - 设置点击表情后的回调
        __weak typeof(self) weak_self = self;
        [_faceView setTapFaceItemBlock:^(UIButton *buttonItem)
        {
            NSMutableAttributedString *mattStr = [[NSMutableAttributedString alloc]initWithAttributedString:weak_self.attributedText];
            NSTextAttachment *attach = [[NSTextAttachment alloc]init];
            attach.image = buttonItem.imageView.image;
            [mattStr appendAttributedString:[NSMutableAttributedString attributedStringWithAttachment:attach]];
            weak_self.attributedText = mattStr;
        }];
        
        [_faceView setTapBottomButtonBlock:^(BottomButtonType buttonIndex) {
            if (weak_self.bottomBlock) {
                weak_self.bottomBlock(buttonIndex);
            }
        }];
        
        
        _funcView = [[FunctionView alloc]init];
        _funcView.backgroundColor = [UIColor whiteColor];
        _funcView.frame = CGRectMake(0, height-216, width, 216);
        
        //textView使用functionView所必须的block回调代码
        [_funcView setFuncButtonBlock:^(FuncButtonType buttonIndex) {
            if (weak_self.funButtonBlock) {
                weak_self.funButtonBlock(buttonIndex);
            }
        }];
        
        
        
    }
    return self;
}

- (void)setKeyboardStatus:(ButtonType)keyboardStatus
{
    
    switch (keyboardStatus) {
        case ButtonTypeVoiceUnSelected://第一个按钮第一次被点击
            [self resignFirstResponder];
            break;
        case ButtonTypeVoiceSelected:
        {
            self.inputView = nil;
            if ([self isFirstResponder])
            {
                [self reloadInputViews];//重新加载输入view
            }
            else
            {
                [self becomeFirstResponder];
            }

        }
            break;
            //点击表情安妮时,需要把键盘的inputView替换为自定义的表情view
        case ButtonTypeFaceUnSelected:
        {
            self.inputView = _faceView;//设置键盘上的view
            if ([self isFirstResponder])
            {
                [self reloadInputViews];//重新加载输入view
            }
            else
            {
                [self becomeFirstResponder];
            }

        }
            break;
            //恢复到系统键盘
        
        case ButtonTypeFaceSelected:
        
            self.inputView = nil;//为系统默认的文字键盘
            if ([self isFirstResponder])
            {
                [self reloadInputViews];//重新加载输入view
            }
            else
            {
                [self becomeFirstResponder];
            }

        
            break;
            case ButtonTypeMoreUnSelected:
            self.inputView = _funcView;//设置键盘上的view
            if ([self isFirstResponder])
            {
                [self reloadInputViews];//重新加载输入view
            }
            else
            {
                [self becomeFirstResponder];
            }

            break;
            case ButtonTypeMoreSelected:
            self.inputView = nil;//为系统默认的文字键盘
            if ([self isFirstResponder])
            {
                [self reloadInputViews];//重新加载输入view
            }
            else
            {
                [self becomeFirstResponder];
            }

            break;
            
        default:
            break;
    }

}

@end
