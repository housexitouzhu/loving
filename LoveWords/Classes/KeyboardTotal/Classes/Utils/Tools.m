//
//  Tools.m
//  MyWeiXin
//
//  Created by 杨斌 on 14-9-25.
//  Copyright (c) 2014年 杨斌. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+(NSMutableAttributedString *)stringToAttributeString:(NSString *)plainText
{
    //先把普通的字符串text转化生成Attributed类型的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:plainText];
    NSString * zhengze = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * arr = [re matchesInString:plainText options:0 range:NSMakeRange(0, plainText.length)];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:@"emotions" ofType:@"plist"];
    NSArray * face = [[NSArray alloc]initWithContentsOfFile:path];
    for (int j =(int) arr.count - 1; j >= 0; j--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = arr[j];
        for (int i = 0; i < face.count; i++) {
            if ([[plainText substringWithRange:result.range] isEqualToString:face[i][@"chs"]])
            {
                NSString * imageName = [NSString stringWithString:face[i][@"png"]];
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
                textAttachment.image = [UIImage imageNamed:imageName];
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [attStr replaceCharactersInRange:result.range withAttributedString:imageStr];
                break;
            }
        }
    }
    return attStr;
}
//传入一张图片，返回图片的名字
//通过二进制比对获得图片的[XX]名
//image是附件中的Image

+(NSString *)imageToName:(UIImage *)image
{
        NSData * d1 = UIImagePNGRepresentation(image);
    NSMutableArray *imageDataArray = [Tools imageDataArray];
        //遍历已保存的图片数组
        for (NSDictionary *dic in imageDataArray)
        {
            //data我们保存的字典中的图片二进制数据
            NSData * data = dic[@"data"];
            if ([d1 isEqualToData:data])//找到该image
            {
                NSString * name = dic[@"name"];//取出图片对应的正则名[xx]
                return name;
            }
        }
        return nil;
    

}
+(NSArray *)fetchLocalFaceDicts
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"emotions" ofType:@"plist"];
    NSArray *faces = [NSArray arrayWithContentsOfFile:path];
    return faces;
}
+(NSMutableArray*)imageDataArray
{
    NSMutableArray *marr = [NSMutableArray array];
    NSArray *faces = [Tools fetchLocalFaceDicts];
    [faces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        //取出图片正则名[XX]
        NSString * imageName = dic[@"chs"];//[兔子]
        UIImage * image = [UIImage imageNamed:dic[@"png"]];
        //把图片转换为二进制
        NSData * imageData = UIImagePNGRepresentation(image);
        //根据图片正则名和图片的二进制构建一个字典,加入到数组中
        NSDictionary * dic1 = @{@"name":imageName,@"data":imageData};
        [marr addObject:dic1];
    }];
    return marr;
}

/**
 *  属性字符串转换为普通字符串
 *  原则:把图片换成[XX]的文本
 *  @param attStr 属性字符串
 *
 *  @return 普通字符串
 */
+ (NSString *)attStringToString:(NSAttributedString *)attStr
{
    //创建一个可变的属性字符串,初始化为_tv1的属性字符串
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
    //枚举指定范围内的属性信息和range(位置)信息
    //遍历属性字符串,得到相关的文本附件和附件所在的位置
    [attString enumerateAttributesInRange:NSMakeRange(0, attString.length) options:(NSAttributedStringEnumerationReverse) usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        //        NSLog(@"range = %@",[NSValue valueWithRange:range]);
        //        NSLog(@"substring = %@",[attString.string substringWithRange:range]);
        //        NSLog(@"====%@",attrs);
        //取出附文本
        NSTextAttachment * attachment = attrs[@"NSAttachment"];
        //找到附文本的图片的位置
        if (attachment)
        {
            //取出附件中的图片
            UIImage * image = attachment.image;
            //根据图片找到图片的正则名
            NSString * imageName = [Tools imageToName:image];
            //在图片的位置用正则名文本将该位置的图片替换
            [attString replaceCharactersInRange:range withString:imageName];
            //替换之后 abcd[兔子][兔子],纯文本形式
            //替换之前  abcd(兔子图片)(兔子图片)
            
        }
    }];
    
    return attString.string;
    
}

@end
