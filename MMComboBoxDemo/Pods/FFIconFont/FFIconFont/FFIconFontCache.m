//
//  FFIconFontCache.m
//  FFIconFontDemo
//
//  Created by 石贵峰 on 2016/11/2.
//  Copyright © 2016年 shiguifeng. All rights reserved.
//

#import "FFIconFontCache.h"
#import "FFSingleton.h"

@implementation FFIconFontCache

FF_DEF_SINGLETON(FFIconFontCache)

- (NSMutableDictionary *)fontCache
{
    if (!_fontCache) {
        _fontCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _fontCache;
}
// 保存图片
- (void)saveImage:(UIImage *)image
             name:(NSString *)name
             size:(CGSize)size
            color:(NSString *)color
            point:(CGPoint)point
        
{
    [self.fontCache setObject:image forKey:[self keyWithName:name size:size color:color point:point]];
}
// 查找图片
- (UIImage *)imageWithName:(NSString *)name
                      size:(CGSize)size
                     color:(NSString *)color
                     point:(CGPoint)point
{
    return [self.fontCache objectForKey:[self keyWithName:name size:size color:color point:point]];
}
- (NSString *)keyWithName:(NSString *)string
                     size:(CGSize)size
                    color:(NSString *)color
                    point:(CGPoint)point
{
    NSString *sizeString = NSStringFromCGSize(size);
    NSString *pointString = NSStringFromCGPoint(point);
    return [NSString stringWithFormat:@"%@%@%@%@",string,sizeString,color,pointString];
}
@end
