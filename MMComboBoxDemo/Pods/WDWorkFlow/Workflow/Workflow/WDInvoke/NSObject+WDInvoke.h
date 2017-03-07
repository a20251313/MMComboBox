//
//  NSObject+WDInvoke.h
//  Pods
//
//  Created by bright ming on 16/11/10.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

// DEBUG LOG 输出控制
#define WD_INVOKE_LOG_ENABLED  0

/*
 *  支持以下类型参数和返回值：
 *  0> 无参数/无返回值
 *  1> id, NSObject, (nil), Class,
 *  2> char, int, short, long, long long, float, double, BOOL,(NSInteger)
 *  3> unsigned char, unsigned int, unsigned short, unsigned long, unsigned long long,(NSUInteger)
 *  4> CGPoint, CGSize, CGRect, CGVector, CGAffineTransform, UIEdgeInsets, UIOffset,
 *
 */

// 类型转换
#define WDBoxNSNumber(_number)             @(_number)
#define WDBoxCGPoint(_point)               [NSValue valueWithCGPoint:(_point)]
#define WDBoxCGVector(_vector)             [NSValue valueWithCGVector:(_vector)]
#define WDBoxCGSize(_size)                 [NSValue valueWithCGSize:(_size)]
#define WDBoxCGRect(_rect)                 [NSValue valueWithCGRect:(_rect)]
#define WDBoxCGAffineTransform(_transform) [NSValue valueWithCGAffineTransform:(_transform)]
#define WDBoxUIEdgeInsets(_insets)         [NSValue valueWithUIEdgeInsets:(_insets)]
#define WDBoxUIOffset(_insets)             [NSValue valueWithUIOffset:(_insets)]

#define WDManiFold(...) \
__WDManiFold(__VA_ARGS__, 20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1)

#define __WDManiFold(_1, _2, _3, _4, _5, _6,_7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, N, ...) \
[WDInvokeArray:N, _1, _2, _3,_4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20]

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@class WDInvokeArray;
@interface NSObject(WDInvoke)

/**
 初始化对象 等价于[[[self class] alloc] init];
 
 @return 返回值
 */

+ (id)wd_obj;

/**
 调用实例方法，相当于[obj selector]
 
 @param selector 方法
 
 @return 取决于selector具体实现
 */

- (id)wd_invoke:(SEL)selector;

/**
 对象调用方法，相当于[obj selector:arg2:arg3:...]
 
 @param selector  方法
 @param arguments 参数列表，使用宏封装，WDManiFold(arg1,arg2,arg3...)，arg1，arg2，arg3...参数必须是对象
 
 @return 取决于selector具体实现
 */
- (id)wd_invoke:(SEL)selector arguments:(WDInvokeArray *)arguments;

/**
 调用类方法, 相当于[Class selector]
 
 @param selector 方法
 
 @return 取决于selector具体实现
 */
+ (id)wd_invoke:(SEL)selector;

/**
 调用类方法, 相当于[Class selector:arg2:arg3:...]
 
 @param selector  方法
 @param arguments 参数列表，使用宏封装，WDManiFold(arg1,arg2,arg3...)，arg1，arg2，arg3...参数必须是对象
 
 @return 取决于selector具体实现
 */
+ (id)wd_invoke:(SEL)selector arguments:(WDInvokeArray *)arguments;

@end

@interface NSString (WDInvoke)

@property (nonatomic,assign) Class wd_class;
@property (nonatomic,assign) SEL wd_selector;
@property (nonatomic,assign) id wd_obj;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface WDInvokeArray : NSObject

- (NSUInteger)count;
+ (id):(NSUInteger)count, ...;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end

@interface NSInvocation (WDInvoke)

- (void)wd_setArgument:(id)object atIndex:(NSUInteger)index;
- (id)wd_returnValue;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

