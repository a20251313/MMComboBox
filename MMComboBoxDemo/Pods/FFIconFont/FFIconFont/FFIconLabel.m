//
//  FFIconLabel.m
//  Pods
//
//  Created by 石贵峰 on 2016/11/24.
//
//

#import "FFIconLabel.h"

@implementation FFIconLabel

+ (UILabel *)IconLabelWithIconText:(NSString *)iconText
                           BorderWidth:(CGFloat)borderWidth
                         IconTextColor:(UIColor *)iconTextColor
{
    UILabel *label = [[UILabel alloc] init];
    if (label) {
        // 设置图片
        label.text = iconText;
        // 设置边长和字体
        label.frame = CGRectMake(0, 0, borderWidth, borderWidth);
        label.font = kICONFONT(borderWidth);
        // 设置图片颜色
        label.textColor = iconTextColor;
        // 设置位置居中
        label.textAlignment = NSTextAlignmentCenter;
    }
    return label;
}

+ (UILabel *)ffIcon:(NSString *)icon
              fontColor:(UIColor *)fontColor
               fontSize:(CGFloat)fontSize
        backGroundColor:(UIColor *)backGroundColor
                   size:(CGSize )size
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, size.width, size.height);
    label.font = kICONFONT(fontSize);
    label.text = icon;
    label.textColor = fontColor;
    label.textAlignment = 1;
    label.backgroundColor = backGroundColor;
    return label;
}

- (void)setIcon:(NSString *)icon
      fontColor:(UIColor *)fontColor
           font:(NSInteger)fontSize
backGroundColor:(UIColor *)backGroundColor
{
    self.font = kICONFONT(fontSize);
    self.text = icon;
    self.textColor = fontColor;
    self.textAlignment = 1;
    self.backgroundColor = backGroundColor;
}


@end
