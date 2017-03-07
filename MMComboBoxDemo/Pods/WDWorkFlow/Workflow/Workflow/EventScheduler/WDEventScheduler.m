//
//  WDEventScheduler.m
//  WDWorkFlow
//
//  Created by 李魁峰 on 16/8/3.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import "WDEventScheduler.h"

@implementation WDEVentHandleResult

@end

@interface WDEventScheduler ()
@property(nonatomic, copy) NSMutableArray<id<WDEventHandlerProtocol>>* handlers;

@end

@implementation WDEventScheduler


#pragma mark - action

- (void) handleEvent:(id)event
             completed:(handleCompleted) completed
{
    //eventQueue有值，则调度到队列异步处理；为空，则同步处理
    if (self.eventQueue)
    {
        dispatch_async(self.eventQueue, ^{
            
            __block WDEVentHandleResult* result = nil;
            
            if ( self.preprocessing(event) )
            {
                [self.handlers enumerateObjectsUsingBlock:^(id<WDEventHandlerProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ( [obj respondsToSelector:@selector(willHandle:)] )
                    {
                        [obj willHandle:event];
                    }
                    
                    result = [obj handle:event];
                    
                    if ( [obj respondsToSelector:@selector(didHandled:result:)] )
                    {
                        [obj didHandled:event result:result];
                    }
                    
                    *stop = result.beHandled;
                }];
            }
            if (completed)
            {
                completed(result);
            }
        });
    }
    else
    {
        __block WDEVentHandleResult* result = nil;
        
        if ( self.preprocessing(event) )
        {
            [self.handlers enumerateObjectsUsingBlock:^(id<WDEventHandlerProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ( [obj respondsToSelector:@selector(willHandle:)] )
                {
                    [obj willHandle:event];
                }
                
                result = [obj handle:event];
                
                if ( [obj respondsToSelector:@selector(didHandled:result:)] )
                {
                    [obj didHandled:event result:result];
                }
                
                *stop = result.beHandled;
            }];
        }
        if (completed)
        {
            completed(result);
        }
    }
}

- (void) addHandler:(id<WDEventHandlerProtocol>)handler
          completed:(addHandlerCompleted) completed
{
    @synchronized (self) {
        
        BOOL addSuccess = NO;
        
        if ( ![self.handlers containsObject:handler] )
        {
            [self.handlers addObject:handler];
            addSuccess = YES;
        }
        
        if (completed)
        {
            completed(addSuccess);
        }
    }
}

#pragma mark - lazy load

- (NSMutableArray<id<WDEventHandlerProtocol>> *) handlers
{
    if ( !_handlers )
    {
        _handlers = [NSMutableArray array];
    }
    
    return _handlers;
}

@end
