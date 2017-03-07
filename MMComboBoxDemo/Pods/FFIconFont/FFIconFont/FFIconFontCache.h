//
//  FFIconFontCache.h
//  FFIconFontDemo
//
//  Created by 石贵峰 on 2016/11/2.
//  Copyright © 2016年 shiguifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FFSingleton.h"

@interface FFIconFontCache : NSObject

FF_AS_SINGLETON(FFIconFontCache)
// 标准图的保存
@property (nonatomic, strong) NSMutableDictionary *fontCache;

// 保存图片
- (void)saveImage:(UIImage *)image
             name:(NSString *)name
             size:(CGSize)size
            color:(NSString *)color
            point:(CGPoint)point;
// 查找图片
- (UIImage *)imageWithName:(NSString *)name
                      size:(CGSize)size
                     color:(NSString *)color
                     point:(CGPoint)point;
@end
