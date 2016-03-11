//
//  2DBarcodeViewController.m
//  LoveWords
//
//  Created by Ibokan on 15/12/28.
//  Copyright © 2015年 yulu. All rights reserved.
//

#import "2DBarcodeViewController.h"
#import "UIImage+ZZYQRImageExtension.h"
#import "DataManager.h"
#import "AFNetworking.h"
@interface _DBarcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation _DBarcodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *matchToken=[user objectForKey:@"matchToken"];

// 生成二维码，二维码中带有自定义图片
    UIImage *image  = [UIImage imageNamed:@""];
    self.imageView.image = [UIImage createQRCodeWithSize:200 dataString:matchToken QRCodeImageType:circularImage iconImage:image iconImageSize:40];
 
  


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
