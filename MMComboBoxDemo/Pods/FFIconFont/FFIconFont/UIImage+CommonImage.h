//
//  UIImage+CommonImage.h
//  Pods
//
//  Created by YaoMing on 2016/11/30.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (CommonImage)
+ (UIImage *)backImageBlack;
+ (UIImage *)backImageWhite;
+ (UIImage *)questionImageWithColor:(UIColor *)color;
+ (UIImage *)locationImageWithColor:(UIColor *)color;
+ (UIImage *)successImageWithColor:(UIColor *)color size:(CGFloat)size;
+ (UIImage *)rightImageWithColor:(UIColor *)color size:(CGFloat )size;
+ (UIImage *)logoImageWithColor:(UIColor *)color size:(CGFloat )size;
+ (UIImage *)logoTextImageWithColor:(UIColor *)color size:(CGFloat )size;
+ (UIImage *)checkImageWithBgColor:(UIColor *)bgColor size:(CGFloat)size;
+ (UIImage *)editImageWithColor:(UIColor *)color size:(CGFloat)size;
+ (UIImage *)attentionImageWithColor:(UIColor *)color size:(CGFloat)size;
+ (UIImage *)heartImageWithColor:(UIColor *)color size:(CGFloat)size;
+ (UIImage *)fowordArrowImageWithColor:(UIColor *)color size:(CGFloat)size;
+ (UIImage *)upArrowImageWithColor:(UIColor *)color size:(CGFloat)size;
+ (UIImage *)downArrowImageWithColor:(UIColor *)color size:(CGFloat)size;

@end
