//
//  DynamicScrollView.h
//  LoveWords
//
//  Created by Ibokan on 15/12/27.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapButtonOfDeleteBlock)(NSString *deleteCount);

@interface DynamicScrollView : UIView

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,retain)NSMutableArray *images;

@property(nonatomic,retain)NSMutableArray *imageViews;

@property(nonatomic,assign)BOOL isDeleting;
//删除的第几个图片
@property (nonatomic,copy) NSString *deleteImageCount;
//添加一个新图片
- (void)addImageView:(NSString *)imageName;
- (void)setTapButtonOfDeleteBlock:(TapButtonOfDeleteBlock)aBlock;
@end
