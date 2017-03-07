//
//  FFIconLabel.h
//  Pods
//
//  Created by 石贵峰 on 2016/11/24.
//
//

#import <UIKit/UIKit.h>
#import "FFiconFontDefine.h"


@interface FFIconLabel : UILabel

/*
 一 iconText  图片文字 从FFIconFontDefine里面选择
 二 borderWidth 边长 创建的是一个宽高等边的实体 并且字体的大小等于边长
 如果想改变实体大小 1从新设置不低于此的边长 2设置NSTextAlignment
 三 iconTextColor 字体的颜色  默认颜色为 0x666666
 四 默认的NSTextAlignment 为居中
 */
+ (UILabel *)IconLabelWithIconText:(NSString *)iconText
                           BorderWidth:(CGFloat)borderWidth
                         IconTextColor:(UIColor *)iconTextColor;

+ (UILabel *)ffIcon:(NSString *)icon
              fontColor:(UIColor *)fontColor
               fontSize:(CGFloat)fontSize
        backGroundColor:(UIColor *)backGroundColor
                   size:(CGSize )size;

- (void)setIcon:(NSString *)icon
      fontColor:(UIColor *)fontColor
           font:(NSInteger)fontSize
backGroundColor:(UIColor *)backGroundColor;


@end
