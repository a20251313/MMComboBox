//
//  FFSecurityManager.h
//  Pods
//
//  Created by dash on 2016/10/25.
//
//

#import <Foundation/Foundation.h>

@interface FFMonitorManager : NSObject

// 野指针检测启动
+ (void)wildPointerCheckStart;

//野指针检测停止
+ (void)wildPointerCheckStop;

//获取并打印当前栈信息
+ (NSString *)outputCurrentStackInfo;
    
//runloop性能监控启动
+ (void)performanceMonitorStart;
    
//runloop性能监控停止
+ (void)performanceMonitorStop;

@end
