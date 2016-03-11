//
//  ToolView.h
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTextView.h"
//录音结束
typedef void(^RecordEndedHandler)(NSString*voicePath,NSTimeInterval duration);
typedef void(^SendBlock)(NSAttributedString *attStr);
//底部按钮的block
typedef void(^BottomBlock)(NSAttributedString *attStr,BottomButtonType buttonType);
@interface ToolView : UIView


@property(strong,nonatomic)MTextView *mTextView;//输入框
/**
 *  设置底部的3个按钮的回调
 *
 *  @param bottomBlock 底部3个按钮的回调
 */

- (void)setTapBottomButtonBlock:(BottomBlock)bBlock;

//设置功能键盘回调,如 拍照,相册,位置
- (void)setFuncButtonBlock:(FuncButtonBlock)funcBlock;

//点击原生键盘上的发送按钮
- (void)setTapSendBlock:(SendBlock)sendBlock;
//录音结束的回调
- (void)setRecordEndedHandler:(RecordEndedHandler)hander;


@end
