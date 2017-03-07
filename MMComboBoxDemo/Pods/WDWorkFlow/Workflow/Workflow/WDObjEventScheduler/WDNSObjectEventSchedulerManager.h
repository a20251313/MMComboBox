//
//  WDNSObjectEventSchedulerManager.h
//  WDWorkFlow
//
//  Created by 王楠 on 16/10/10.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFSingleton.h"

#define WDSafeBox(_obj) ([WDSafeBox boxWithValue:(_obj)])

@interface WDSafeBox : NSObject
@property (nonatomic,strong)id safeValue;
+(WDSafeBox *)boxWithValue:(id)obj;
@end

@interface WDSchedulerModel : NSObject

@property (nonatomic, weak) id receiver;
//@property (nonatomic, copy) NSString *selectorName;
//@property (nonatomic, copy) NSString *className;

@end

typedef void(^SchedulerReturn)(id result);

@interface WDNSObjectEventSchedulerManager : NSObject

FF_AS_SINGLETON(WDNSObjectEventSchedulerManager)

//供每个仓注册对象时使用
//如果注册的对象不是单例，那么需要在调度处先进行对象注册然后在进行方法调度
- (void) setSchedulerDicWithWReceiver:(id)receiver;

//删除临时注册的对象
//-(void)removeReceiver:(id)receiver;

/**调度单例对象函数**/
//同步调度函数
- (id) sendEventWithClassName:(NSString*)className
                      selName:(SEL)sel
                       params:(NSArray<WDSafeBox *>*)params;
//异步调度函数
-(void) postEventWithClassName:(NSString*)className
                       selName:(SEL)sel
                        params:(NSArray<WDSafeBox *>*)params
                getReturnValue:(SchedulerReturn) getReturn;

/**调度临时对象的函数**/
//同步调度函数
-  (id) sendEventWithReceive:(id)receiver
                     selName:(SEL)sel
                      params:(NSArray<WDSafeBox *>*)params;
//异步调度函数
-(void) postEventWithReceive:(id)receiver
                     selName:(SEL)sel
                      params:(NSArray<WDSafeBox *>*)params
              getReturnValue:(SchedulerReturn) getReturn;

@end


