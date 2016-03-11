//
//  FunctionView.h
//  appXX-表情键盘呢
//
//  Created by MRBean on 15/8/17.
//  Copyright (c) 2015年 yangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    FuncButtonTypeCamera,
    FuncButtonTypePhoto,
    FuncButtonTypeLocation
    
}FuncButtonType;
typedef void(^FuncButtonBlock)(FuncButtonType buttonIndex);
@interface FunctionView : UIView
- (void)setFuncButtonBlock:(FuncButtonBlock)funcBlock;
@end
