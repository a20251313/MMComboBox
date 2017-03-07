//
//  WDEventScheduler.h
//  WDWorkFlow
//
//  Created by 李魁峰 on 16/8/3.
//  Copyright © 2016年 李魁峰. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDEVentHandleResult : NSObject
@property (nonatomic, assign) BOOL beHandled;
@end

@protocol WDEventHandlerProtocol <NSObject>

@optional

// 开始处理前调用，与event处理逻辑无关
- (void) willHandle:(id) event;

// msg处理完成后调用，与event处理逻辑无关
- (void) didHandled:(id) event result:(WDEVentHandleResult *) result;
@required

/*
 return:
 YES，当前handler完成event处理，需要终止其他handler处理event
 NO，当前handler尚未完成event处理，需要其他hanlder继续处理
 */
- (WDEVentHandleResult *) handle:(id)event;
@end


typedef BOOL (^preprocessing)(id event);
typedef void(^handleCompleted)(WDEVentHandleResult *result);
typedef void(^addHandlerCompleted)(BOOL successed);


/*
    使用方式：
        1. 初始化业务scheduler对象
        2. 初始化队列信息
        3. 添加preprocessing函数
        4. 添加各事业部hanlder
 */
@interface WDEventScheduler : NSObject
@property(nonatomic, strong, nonnull) preprocessing preprocessing;
@property(nonatomic, strong,nonnull) dispatch_queue_t eventQueue;

- (void) addHandler:(id<WDEventHandlerProtocol>)handler
          completed:(addHandlerCompleted) completed;

- (void) handleEvent:(id)event
             completed:(handleCompleted) completed;

@end

NS_ASSUME_NONNULL_END
