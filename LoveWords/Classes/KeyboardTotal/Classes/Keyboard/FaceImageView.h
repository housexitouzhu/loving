//
//  FaceImageView.h
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  需要有一个ScrollView和3个按钮
 */

typedef enum
{
    BottomButtonTypeRecently,
    BottomButtonTypeDefaut,
    BottomButtonTypeSend,
    
}BottomButtonType;//底部按钮类型

typedef void(^FaceItemBlock)(UIButton*buttonItem);
typedef void(^BottomButtonBlock)(BottomButtonType buttonIndex);
@interface FaceImageView : UIView

@property(strong,nonatomic)UIScrollView *scrollView;
/**
 *  设置表情被点击的时候的回调
 *
 *  @param faceBlock 外界传入的代码
 */
- (void)setTapFaceItemBlock:(FaceItemBlock)faceBlock;
/**
 *  设置底部的3个按钮的回调
 *
 *  @param bottomBlock 底部3个按钮的回调
 */
- (void)setTapBottomButtonBlock:(BottomButtonBlock)bottomBlock;
@end
