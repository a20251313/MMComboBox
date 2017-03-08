//
//  MMWaveView.m
//  MMComboBoxDemo
//
//  Created by ran jingfu on 2017/3/8.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMWaveView.h"



@implementation MMWaveView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddCurveToPoint(context,125,150,175,150,200,100);
    CGContextAddCurveToPoint(context,225,50,275,75,300,200);
    CGContextStrokePath(context);
}


- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
    [self setNeedsDisplay];
}

@end
