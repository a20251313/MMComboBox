//
//  FFSystemTimeManager.m
//  Pods
//
//  Created by 刘彬 on 2016/12/29.
//
//

#import "FFSystemTimeManager.h"
#import "FFTimerTask.h"

@interface FFKVOModel : NSObject
/*!
 *  @brief 观察者
 */
@property (nonatomic, weak) NSObject *observer;
/*!
 *  @brief 回调block
 */
@property (nonatomic, copy) FFKVOBlock callback;

@end

@implementation FFKVOModel

@end

@interface FFSystemTimeManager()
/*!
 *  @brief 观察者集合
 */
@property (atomic, strong) NSMutableArray *observerArray;
/*!
 *  @brief 计时器
 */
@property (nonatomic, strong) FFTimerTask *timerTask;
/*!
 *  @brief 切换后台的时间
 */
@property (nonatomic, assign) NSTimeInterval enterBackgroundTime;

@end

@implementation FFSystemTimeManager

@synthesize systemTime = _systemTime;

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static FFSystemTimeManager *_manager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _manager = [[FFSystemTimeManager alloc] init];
    });
    
    return _manager;
}

- (void)dealloc{
    [self stopTimer];
}

#pragma mark - private
- (void)startTimer {
    [self stopTimer];
    __weak typeof(self) w_self = self;
    self.timerTask = [[FFTimerTask alloc] initTimerTaskWithTarget:self timeInterval:1.0 repeats:YES afterDelay:0 handler:^(long long repeatCount, BOOL *stop) {
        __strong typeof(w_self) self = w_self;
        // 系统时间递增后通知观察者，如果没有观察者了，停止timer
        if (self.systemTime > 0 && self.observerArray.count > 0) {
            self.systemTime += 1;
            [self excuteCallbackWithValue:@(self.systemTime) dictionary:@{NSKeyValueChangeNewKey:@(self.systemTime),NSKeyValueChangeOldKey:@(self.systemTime-1)}];
        } else{
            *stop = YES;
            self.timerTask = nil;
        }
    }];
}

- (void)stopTimer{
    if (self.timerTask) {
        [self.timerTask stopTimerTask];
        self.timerTask = nil;
    }
}

- (void)excuteCallbackWithValue:(id)value dictionary:(NSDictionary *)info{
    __weak typeof(self) w_self = self;
    void (^callback)() = ^{
        __strong typeof(w_self) self = w_self;
        [self.observerArray enumerateObjectsUsingBlock:^(FFKVOModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 观察者已经被释放则移除
            if (obj.observer == nil) {
                [self.observerArray removeObject:obj];
            }else{
                // 执行回调
                if (obj.callback) {
                    obj.callback(self, obj.observer, value, info ? info : [NSDictionary new]);
                }
            }
        }];
    };
    
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), callback);
    } else {
        callback();
    }
}

#pragma mark - public
- (void)addObserverForSystemTime:(__weak NSObject *)observer onChanged:(FFKVOBlock)block {
    [self removeObserverForSystemTime:observer];
    if (observer && block) {
        FFKVOModel *model = [[FFKVOModel alloc] init];
        model.observer = observer;
        model.callback = block;
        [self.observerArray addObject:model];
    }
    // 只要有一个观察者就启动timer
    if (self.observerArray.count > 0 && self.timerTask == nil) {
        [self startTimer];
    }
}

- (void)removeObserverForSystemTime:(NSObject *)observer{
    [self.observerArray enumerateObjectsUsingBlock:^(FFKVOModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.observer == nil || obj.observer == observer || obj.callback == nil) {
            [self.observerArray removeObject:obj];
        }
    }];
    // 没有观察者的时候停止timer
    if (self.observerArray.count == 0 && self.timerTask) {
        [self stopTimer];
    }
}

- (void)applicationWillEnterForeground {
    NSTimeInterval currentTime = [[NSDate new] timeIntervalSince1970];
    if (self.enterBackgroundTime > 0 && self.systemTime > 0 && currentTime > self.enterBackgroundTime) {
        self.systemTime += (currentTime-self.enterBackgroundTime);
    }
    self.enterBackgroundTime = 0;
}

- (void)applicationDidEnterBackground {
    self.enterBackgroundTime = [[NSDate new] timeIntervalSince1970];
}

#pragma mark - getter & setter
- (NSMutableArray *)observerArray{
    if (_observerArray == nil) {
        _observerArray = [NSMutableArray array];
    }
    return _observerArray;
}

- (NSTimeInterval)systemTime {
    if (_systemTime <= 0) {
        return [[NSDate new] timeIntervalSince1970];
    } else {
        return _systemTime;
    }
}

- (void)setSystemTime:(NSTimeInterval)systemTime {
    if (_systemTime <= systemTime && systemTime > 0) {
        _systemTime = systemTime;
    }
}

@end
