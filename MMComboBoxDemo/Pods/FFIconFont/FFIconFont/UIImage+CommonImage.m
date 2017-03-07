//
//  UIImage+CommonImage.m
//  Pods
//
//  Created by YaoMing on 2016/11/30.
//
//

#import "UIImage+CommonImage.h"
#import "UIImage+iconFont.h"
@implementation UIImage (CommonImage)
+ (UIImage *)backImageBlack
{
    float size = 102.0/256.0;
    return [self iconFontImageFromText:kBackArrowIcon imageColor:[UIColor colorWithRed:size green:size blue:size alpha:1.0] imageSize:CGSizeMake(20, 20)];
}

+ (UIImage *)backImageWhite
{
    float size = 244/256.0;
    return [self iconFontImageFromText:kBackArrowIcon imageColor:[UIColor colorWithRed:size green:size blue:size alpha:1.0] imageSize:CGSizeMake(20, 20)];
}

+ (UIImage *)questionImageWithColor:(UIColor *)color
{
    return [self iconFontImageFromText:kHelpIcon imageColor:color imageSize:CGSizeMake(20, 20)];
}

+ (UIImage *)locationImageWithColor:(UIColor *)color
{
    return [self iconFontImageFromText:kLocationIcon imageColor:color imageSize:CGSizeMake(20, 20)];
}

+ (UIImage *)successImageWithColor:(UIColor *)color size:(CGFloat)size
{
        return [self iconFontImageFromText:kSuccessIon imageColor:color imageSize:CGSizeMake(size, size)];
}


+ (UIImage *)rightImageWithColor:(UIColor *)color size:(CGFloat )size
{
    return [self iconFontImageFromText:kCheckIcon imageColor:color imageSize:CGSizeMake(size, size)];
}

+ (UIImage *)logoImageWithColor:(UIColor *)color size:(CGFloat )size
{
    return [self iconFontImageFromText:kLogoWhalelIcon imageColor:color imageSize:CGSizeMake(size, size)];
}

+ (UIImage *)logoTextImageWithColor:(UIColor *)color size:(CGFloat )size
{
    return [self iconFontImageFromText:kLogoFullIconIcon imageColor:color imageSize:CGSizeMake(size, size)];
}

+ (UIImage *)checkImageWithBgColor:(UIColor *)bgColor size:(CGFloat)size
{
    NSString *iconFontText = kCheckIcon;
    
    NSString * iconFontName = kICONFONT_FONTNAME;
    
    CGFloat sizef = size;
    
    UIFont *font = [UIFont fontWithName:iconFontName size:sizef*0.7];
    
    CGSize  imageSize = CGSizeMake(size, size);
    UIColor *textColor = [UIColor whiteColor];
    
    UIImage *bgImage = [self fillEllipseImageWithColor:bgColor AndBorderWidth:size];
    
    UIImage *image = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageSize,NO,0.0);
    
    [bgImage drawAtPoint:CGPointMake(0,0)];
    
    [iconFontText drawAtPoint:CGPointMake(imageSize.width/2-(sizef*0.7)/2,imageSize.height/2-(sizef*0.7)/2) withAttributes:@{NSFontAttributeName:font,NSBackgroundColorAttributeName:bgColor,NSForegroundColorAttributeName:textColor}];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)fillEllipseImageWithColor:(UIColor *)color AndBorderWidth:(CGFloat)width
{
    
    CGRect rect = CGRectMake(0, 0, width, width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)editImageWithColor:(UIColor *)color size:(CGFloat)size
{
    return [self iconFontImageFromText:kEditIcon imageColor:color imageSize:CGSizeMake(size, size)];
}


+ (UIImage *)attentionImageWithColor:(UIColor *)color size:(CGFloat)size
{
    return [self iconFontImageFromText:kAttentionIcon imageColor:color imageSize:CGSizeMake(size, size)];
}

+ (UIImage *)heartImageWithColor:(UIColor *)color size:(CGFloat)size
{
    return [self iconFontImageFromText:kHeartIcon imageColor:color imageSize:CGSizeMake(size, size)];
}

+ (UIImage *)fowordArrowImageWithColor:(UIColor *)color size:(CGFloat)size
{
    return [self iconFontImageFromText:kFowordArrowIcon imageColor:color imageSize:CGSizeMake(size, size)];
}

+ (UIImage *)upArrowImageWithColor:(UIColor *)color size:(CGFloat)size
{
    return [self iconFontImageFromText:kUpArrowIcon imageColor:color imageSize:CGSizeMake(size, size)];
}
+ (UIImage *)downArrowImageWithColor:(UIColor *)color size:(CGFloat)size
{
    return [self iconFontImageFromText:kDownArrowIcon imageColor:color imageSize:CGSizeMake(size, size)];
}
@end
