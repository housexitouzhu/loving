
#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>

@interface Tools : NSObject
/**
 *  把普通字符串转换为属性字符串,使用默认的plist
 *
 *  @param plainText 普通文本字符串
 *
 *  @return 得到的属性字符串
 */
+(NSMutableAttributedString *)stringToAttributeString:(NSString *)plainText;
/**
 *  属性字符串转换为普通字符串
 *
 *  @param attStr 属性字符串
 *
 *  @return 转换后的普通字符串
 */
+ (NSString *)attStringToString:(NSAttributedString *)attStr;
/**
 *  根据image返回一个图片的名[XX]
 *
 *  @param image 原始图片
 *
 *  @return 图片的正则表达式名
 */
+(NSString*)imageToName:(UIImage*)image;
/**
 *  获取本地plist中所有的字典
 *
 *  @return 包含字典的数组
 */
+(NSArray*)fetchLocalFaceDicts;
/**
 *  获取所有的图片的data
 *
 *  @return 返回一个带有图片data和[XX]的数组
 */
+(NSMutableArray*)imageDataArray;
@end
