//
//  UIImage+iconFont.m
//  FFiconFontDemo
//
//  Created by 石贵峰 on 2016/11/2.
//  Copyright © 2016年 shiguifeng. All rights reserved.
//

#import "UIImage+iconFont.h"
#import "FFiconFontDefine.h"


@implementation UIImage (iconFont)

/**
 获取对应颜色的string

 @param color 颜色
 @return 对应颜色的string
 */
+(NSString*)getColorString:(UIColor*)color
{
    if (![color isKindOfClass:[UIColor class]]) {
        return nil;
    }
    CGFloat red = 0;
    CGFloat blue = 0;
    CGFloat green = 0;
    CGFloat alpha = 0;
    BOOL getValue =  [color getRed:&red green:&green blue:&blue alpha:&alpha];
    if (getValue) {
        return [NSString stringWithFormat:@"%0.2f%0.2f%0.2f%0.2f",red,blue,green,alpha];
    }
    
    return nil;
}

/**
 根据text获取图像
 
 @param iconFontText text
 @param imageColor 显示颜色
 @param imageSize 对应图片高度
 @return 对应的image
 */
+ (UIImage *)iconFontImageFromText:(NSString *)iconFontText
                 imageColor:(UIColor*)imageColor
                 imageSize:(CGSize)imageSize
{
  
    NSString  *colorString = [self getColorString:imageColor];
    
    UIImage *image = [[FFIconFontCache sharedInstance] imageWithName:iconFontText size:imageSize color:colorString point:CGPointZero];
    if (image) {
        return image;
    }
    return  [self iconFontImageFromText:iconFontText imageSize:imageSize iconFontName:kICONFONT_FONTNAME textColor:imageColor backGroundColor:[UIColor clearColor]];
}

/**
 根据参数获取对应字体对应图形icon
 
 @param iconFontText text
 @param imageSize 图形大小
 @param iconFontName 字体名称 默认kICONFONT_FONTNAME
 @param textColor 图像颜色
 @param bgColor 图像背景颜色，默认[UIColor clearColor]
 @return 目的图像image
 */
+ (UIImage *)iconFontImageFromText:(NSString *)iconFontText
                         imageSize:(CGSize )imageSize
                      iconFontName:(NSString *)iconFontName
                         textColor:(UIColor *)textColor
                   backGroundColor:(UIColor *)bgColor
{
    if (iconFontName == nil || iconFontName.length < 1) {
        iconFontName = kICONFONT_FONTNAME;
    }
    if (bgColor == nil) {
        bgColor = [UIColor clearColor];
    }
    UIFont *font = [UIFont fontWithName:iconFontName size:imageSize.height];
    if (font == nil) {
        NSAssert(font == nil, @"iconFontImageFromText font is nil,Please ensure has this font!");
        return nil;
    }
    if (imageSize.width==0||imageSize.height==0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(imageSize,NO,0.0);
    [iconFontText drawInRect:CGRectMake(0,0, imageSize.width, imageSize.height) withAttributes:@{NSFontAttributeName:font,NSBackgroundColorAttributeName:bgColor,NSForegroundColorAttributeName:textColor}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (image) {
        [[FFIconFontCache sharedInstance] saveImage:image name:iconFontText size:imageSize color:[self getColorString:textColor] point:CGPointZero];
    }
    NSAssert(image, @"绘制icon异常！！！！！！！%@",image);
    return image;
}

+ (UIImage *)iconWithBackGroud:(NSString *)icon fontColor:(UIColor *)fontColor backGroudColor:(UIColor *)bgColor size:(CGSize)imageSize
{
    if (imageSize.width==0||imageSize.height==0) {
        return nil;
    }
    NSString *iconFontText = icon;
    
    NSString * iconFontName = kICONFONT_FONTNAME;
    
    CGFloat sizef = MIN(imageSize.height, imageSize.width);
    
    UIFont *font = [UIFont fontWithName:iconFontName size:sizef*0.7];
    
    UIColor *textColor = fontColor;
    
    UIImage *bgImage = [self ImageFromColor:bgColor AndSize:imageSize];
    
    NSString  *colorString = [self getColorString:textColor];
    
    
    UIImage *image = [[FFIconFontCache sharedInstance] imageWithName:iconFontText size:imageSize color:colorString point:CGPointZero];
    if (image) {
        return image;
    }
    CGSize size = CGSizeMake (bgImage.size.width ,bgImage.size.height ); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    
    [bgImage drawAtPoint:CGPointMake(0,0)];
    
    [iconFontText drawAtPoint:CGPointMake(imageSize.width/2-(sizef*0.7)/2,imageSize.height/2-(sizef*0.7)/2) withAttributes:@{NSFontAttributeName:font,NSBackgroundColorAttributeName:bgColor,NSForegroundColorAttributeName:textColor}];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (image) {
        [[FFIconFontCache sharedInstance] saveImage:image name:iconFontText size:imageSize color:[self getColorString:textColor] point:CGPointZero];
    }
    NSAssert(image, @"绘制icon异常！！！！！！！%@",image);
    
    return image;
}
// 默认图返回接口 先获取一块纯色的背景图片 再在图片的中心位置画上默认iconfont
+ (UIImage *)defaultImageWihtImageSize:(CGSize)imageSize
{
    if (imageSize.width==0||imageSize.height==0) {
        return nil;
    }
    NSString *iconFontText = kLogoFullIconIcon;
    
    NSString * iconFontName = kICONFONT_FONTNAME;
    
    CGFloat sizef = MIN(imageSize.height, imageSize.width);
    
    UIFont *font = [UIFont fontWithName:iconFontName size:sizef*0.7];
    
    UIColor *bgColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    UIColor *textColor = [UIColor whiteColor];
    
    UIImage *bgImage = [self ImageFromColor:bgColor AndSize:imageSize];
    
    NSString  *colorString = [self getColorString:textColor];
    
    CGPoint point = CGPointMake(imageSize.width/2-(sizef*0.7)/2,imageSize.height/2-(sizef*0.7)/2);
    
    UIImage *image = [[FFIconFontCache sharedInstance] imageWithName:iconFontText size:imageSize color:colorString point:point];
    if (image) {
        return image;
    }
    CGSize size = CGSizeMake (bgImage.size.width ,bgImage.size.height ); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    
    [bgImage drawAtPoint:CGPointMake(0,0)];
    
    [iconFontText drawAtPoint:point withAttributes:@{NSFontAttributeName:font,NSBackgroundColorAttributeName:bgColor,NSForegroundColorAttributeName:textColor}];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (image) {
        [[FFIconFontCache sharedInstance] saveImage:image name:iconFontText size:imageSize color:[self getColorString:textColor] point:point];
    }
    NSAssert(image, @"绘制icon异常！！！！！！！%@",image);
    return image;
}
// 返回一块纯色图片
+ (UIImage *)ImageFromColor:(UIColor *)color AndSize:(CGSize)size
{
    NSString  *colorString = [self getColorString:color];
    
    UIImage *image = [[FFIconFontCache sharedInstance] imageWithName:@"purecolor" size:size color:colorString point:CGPointZero];
    if (image) {
        return image;
    }
    if (size.width==0||size.height==0) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image) {
        [[FFIconFontCache sharedInstance] saveImage:image name:@"purecolor" size:size color:[self getColorString:color] point:CGPointZero];
    }
    NSAssert(image, @"绘制icon异常！！！！！！！%@",image);

    return image;
}
@end
