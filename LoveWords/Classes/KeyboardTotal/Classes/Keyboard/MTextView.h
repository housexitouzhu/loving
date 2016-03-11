//
//  MTextView.h
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceImageView.h"
#import "FunctionView.h"
typedef enum
{
    ButtonTypeVoiceSelected,
    ButtonTypeVoiceUnSelected,
    ButtonTypeFaceSelected,
    ButtonTypeFaceUnSelected,
    ButtonTypeMoreSelected,
    ButtonTypeMoreUnSelected,
}ButtonType;
@interface MTextView : UITextView
/**
 *  设置键盘状态
 *
 *  @param keyboardStatus 按钮的状态对应键盘的inputView
 */
- (void)setKeyboardStatus:(ButtonType)keyboardStatus;

/**
 *  设置底部的3个按钮的回调
 *
 *  @param bottomBlock 底部3个按钮的回调
 */
- (void)setTapBottomButtonBlock:(BottomButtonBlock)bottomBlock;


/**
 *  在textView中设置功能键盘的回调
 *
 *  @param funcBlock textView使用者的回调代码
 */
- (void)setFuncButtonBlock:(FuncButtonBlock)funcBlock;





@end
