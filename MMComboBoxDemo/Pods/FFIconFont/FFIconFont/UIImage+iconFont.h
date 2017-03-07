//
//  UIImage+iconFont.h
//  FFiconFontDemo
//
//  Created by 石贵峰 on 2016/11/2.
//  Copyright © 2016年 shiguifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFiconFontCache.h"
#import "FFiconFontDefine.h"

@interface UIImage (iconFont)

/**
 根据text获取图像

 @param iconFontText text
 @param imageColor 显示颜色
 @param imageSize 对应图片高度
 @return 对应的image
 */
+ (UIImage *)iconFontImageFromText:(NSString *)iconFontText
                imageColor:(UIColor*)imageColor
                 imageSize:(CGSize)imageSize;

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
                   backGroundColor:(UIColor *)bgColor;

+ (UIImage *)iconWithBackGroud:(NSString *)icon
                     fontColor:(UIColor *)fontColor
                backGroudColor:(UIColor *)bgColor
                          size:(CGSize)imageSize;

// 默认图返回接口 先获取一块纯色的背景图片 再在图片的中心位置画上默认iconfont
+ (UIImage *)defaultImageWihtImageSize:(CGSize)imageSize;
@end
