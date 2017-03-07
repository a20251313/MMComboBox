//
//  FFIconButton.m
//  Pods
//
//  Created by 石贵峰 on 2016/11/24.
//
//

#import "FFIconButton.h"

@implementation FFIconButton


+ (FFIconButton *)IconButtonWithIconText:(NSString *)iconText
                             BorderWidth:(CGFloat)borderWidth
                           IconTextColor:(UIColor *)iconTextColor
{
    FFIconButton *button = [super buttonWithType:UIButtonTypeCustom];
    if (button) {
        // 设置文字
        [button setTitle:iconText forState:UIControlStateNormal];
        [button setTitle:iconText forState:UIControlStateSelected];
        // 设置fram和font
        button.frame = CGRectMake(0, 0, borderWidth, borderWidth);
        button.titleLabel.font =  kICONFONT(borderWidth);
        // 设置文字颜色
        [button setTitleColor:iconTextColor forState:UIControlStateNormal];
        [button setTitleColor:iconTextColor forState:UIControlStateSelected];
        
    }
    return button;
}
@end
