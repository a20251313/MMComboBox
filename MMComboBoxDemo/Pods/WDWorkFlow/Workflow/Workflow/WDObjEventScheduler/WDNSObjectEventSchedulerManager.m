//
//  WDNSObjectEventSchedulerManager.m
//  WDWorkFlow
//
//  Created by 王楠 on 16/10/10.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import "WDNSObjectEventSchedulerManager.h"
#import "NSInvocation+utility.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "SafeCategory.h"

@implementation WDSafeBox

+(WDSafeBox *)boxWithValue:(id)obj
{
    WDSafeBox *_obj = [WDSafeBox new];
    _obj.safeValue = obj;
    return _obj;
}

@end

@implementation WDSchedulerModel
@end

@interface WDNSObjectEventSchedulerManager ()

@property (nonatomic, strong,readwrite) NSMutableDictionary *schedulerDic;
@end

@implementation WDNSObjectEventSchedulerManager
FF_DEF_SINGLETON(WDNSObjectEventSchedulerManager)

//- (void) setSchedulerDicWithWDSchedulerModel:(WDSchedulerModel*)schedulerModel{
//    
//    @synchronized (self.schedulerDic) {
//        
//        Class class = [schedulerModel.receiver class];
//        NSString *classKey = NSStringFromClass(class);
//        NSMutableSet *schedulerModelSet = self.schedulerDic[classKey];
//        if (!schedulerModelSet) {
//            schedulerModelSet = [NSMutableSet set];
//        }
//        [schedulerModelSet safeAddObject:schedulerModel];
//        [self.schedulerDic safeSetObject:schedulerModelSet forKey:classKey];
//        
//    }
//}

- (void) setSchedulerDicWithWReceiver:(id)receiver{
    
    @synchronized (self.schedulerDic) {
        
        WDSchedulerModel *schedulerModel = [[WDSchedulerModel alloc] init];
        schedulerModel.receiver = receiver;
        
        Class class = [schedulerModel.receiver class];
        NSString *classKey = NSStringFromClass(class);
        NSMutableSet *schedulerModelSet = self.schedulerDic[classKey];
        if (!schedulerModelSet) {
            schedulerModelSet = [NSMutableSet set];
        }
        [schedulerModelSet safeAddObject:schedulerModel];
        [self.schedulerDic safeSetObject:schedulerModelSet forKey:classKey];
        
    }
    
}

-(void)removeReceiver:(id)receiver{
    @synchronized (self.schedulerDic) {
        Class class = [receiver class];
        NSString *classKey = NSStringFromClass(class);
        NSMutableSet *set = self.schedulerDic[classKey];
        [set removeObject:receiver];
        if (set.count == 0) {
            [self.schedulerDic removeObjectForKey:classKey];
        }
    }
}


//同步发送调度请求
- (id) sendEventWithClassName:(NSString*)className selName:(SEL)sel params:(NSArray<WDSafeBox *>*)params{
    
    id result = [self dotoSelectorWithClassName:className selName:sel params:params];

    return result;
}

//异步发送调度请求
-(void) postEventWithClassName:(NSString*)className selName:(SEL)sel params:(NSArray<WDSafeBox *>*)params getReturnValue:(SchedulerReturn) getReturn{
    
    
    const char *label = [NSString stringWithFormat:@"EventScheduler_%@_%@",className,NSStringFromSelector(sel)].UTF8String;
    dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue, ^{

        id result = [self dotoSelectorWithClassName:className selName:sel params:params];
        
        getReturn(result);
        
    });
    
}

- (id) sendEventWithReceive:(id)receiver selName:(SEL)sel params:(NSArray<WDSafeBox *>*)params{
    
    id result = [self dotoSelectorWithReceive:receiver selName:sel params:params];
//    [self removeReceiver:receiver];
    return result;
}
//异步调度函数
-(void) postEventWithReceive:(id)receiver selName:(SEL)sel params:(NSArray<WDSafeBox *>*)params getReturnValue:(SchedulerReturn) getReturn{
    
    Class class = [receiver class];
    NSString *className = NSStringFromClass(class);
    const char *label = [NSString stringWithFormat:@"EventScheduler_%@_%@",className,NSStringFromSelector(sel)].UTF8String;
    dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        id result = [self dotoSelectorWithReceive:receiver selName:sel params:params];
//        [self removeReceiver:receiver];
        
        getReturn(result);
        
    });
    
}

-(id)dotoSelectorWithClassName:(NSString *)clsName selName:(SEL)sel params:(NSArray<WDSafeBox *>*)params{
    
    NSArray * receiveModelArray = [self.schedulerDic[clsName] allObjects];
    
    for (WDSchedulerModel *receiverModule in receiveModelArray) {
        
        id receiver = receiverModule.receiver;
        id result = [self dotoSelectorWithReceive:receiver selName:sel params:params];
        return result;
    }
    
    return nil;
}


-(id)dotoSelectorWithReceive:(id)receiver selName:(SEL)sel params:(NSArray<WDSafeBox *>*)params{
    
    if ([receiver respondsToSelector:sel]) {
        
        NSMethodSignature * sig = [receiver methodSignatureForSelector:sel];
        if (!sig) return nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        if (!invocation) return nil;
        
        [invocation setSelector:sel];
        [invocation setTarget:receiver];
        
        if (params.count > 0 && selectorArgumentCount(sel) == params.count) {
            [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[WDSafeBox class]]) {
                    id safeValue = ((WDSafeBox *)obj).safeValue;
                    if (safeValue) {
                        [invocation setArgument:&safeValue atIndex:idx+2];
                    }
                }
            }];
        }
        
        [invocation retainArguments];
        [invocation invoke];
        
        if (sig.methodReturnLength) { // 有返回值类型，才去获得返回值
            void *result ;
            [invocation getReturnValue:&result];
            return (__bridge id)result;
        }
        return nil;
        
#pragma clang diagnostic pop
        
        
    }
    
    return nil;
    
}


static NSUInteger selectorArgumentCount(SEL selector)
{
    NSUInteger argumentCount = 0;
    //sel_getName获取selector名的C字符串
    const char *selectorStringCursor = sel_getName(selector);
    char ch;
    //    遍历字符串有几个:来确定有几个参数
    while((ch = *selectorStringCursor)) {
        if(ch == ':') {
            ++argumentCount;
        }
        ++selectorStringCursor;
    }
    
    return argumentCount;
}


-(NSMutableDictionary*)schedulerDic{
    if (!_schedulerDic) {
        _schedulerDic = [[NSMutableDictionary alloc] init];
    }
    return _schedulerDic;
}


/*************************************************************************/


static NSMethodSignature* methodSignatureFromBlock(id block) {
    struct CTBlockLiteral {
        void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
        int flags;
        int reserved;
        void (*invoke)(void *, ...);
        struct block_descriptor {
            unsigned long int reserved;	// NULL
            unsigned long int size;         // sizeof(struct Block_literal_1)
            // optional helper functions
            void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
            void (*dispose_helper)(void *src);             // IFF (1<<25)
            // required ABI.2010.3.16
            const char *signature;                         // IFF (1<<30)
        } *descriptor;
        // imported variables
    };
    
    enum {
        CTBlockDescriptionFlagsHasCopyDispose = (1 << 25),
        CTBlockDescriptionFlagsHasCtor = (1 << 26), // helpers have C++ code
        CTBlockDescriptionFlagsIsGlobal = (1 << 28),
        CTBlockDescriptionFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
        CTBlockDescriptionFlagsHasSignature = (1 << 30)
    };
    typedef int CTBlockDescriptionFlags;
    
    struct CTBlockLiteral *blockRef = (__bridge struct CTBlockLiteral *)block;
    CTBlockDescriptionFlags flags = blockRef->flags;
    
    if (flags & CTBlockDescriptionFlagsHasSignature) {
        void *signatureLocation = blockRef->descriptor;
        signatureLocation += sizeof(unsigned long int);
        signatureLocation += sizeof(unsigned long int);
        
        if (flags & CTBlockDescriptionFlagsHasCopyDispose) {
            signatureLocation += sizeof(void(*)(void *dst, void *src));
            signatureLocation += sizeof(void (*)(void *src));
        }
        
        const char *signature = (*(const char **)signatureLocation);
        return [NSMethodSignature signatureWithObjCTypes:signature];
    }
    return nil;
}


static NSString*  selectorSignatureStringFromBlockMethodSignature(NSMethodSignature* method) {
    NSMutableString* signatureString = [NSMutableString string];
    [signatureString appendFormat:@"%s", method.methodReturnType];
    for (NSInteger i =0; i<method.numberOfArguments; ++i) {
        [signatureString appendFormat:@"%s", [method getArgumentTypeAtIndex:i]];
        if (0 == i) [signatureString appendString:@":"];
    }
    
    return signatureString;
}

static BOOL isBlock(id block) {
    Class cls = NSClassFromString(@"NSBlock");
    return block && [block isKindOfClass:cls];
}

static void swizzler(Class cls, SEL oldSelector, SEL newSelector, IMP newImp) {
    if (!class_respondsToSelector(cls, newSelector)) {
        const char * method_encoding = method_getTypeEncoding(class_getInstanceMethod(cls, oldSelector));
        IMP oldImp = class_getMethodImplementation(cls, oldSelector);
        class_replaceMethod(cls, oldSelector, newImp, method_encoding);
        class_addMethod(cls, newSelector, oldImp, method_encoding);
    }
}


static void copyInvocationArgs(NSInvocation* invoFrom, NSInteger indexFrom, NSInvocation* invoTo, NSInteger indexTo) {
    const NSUInteger numAgrsFrom = invoFrom.methodSignature.numberOfArguments;
    const NSUInteger numArgsTo = invoTo.methodSignature.numberOfArguments;
    void *argBuf = NULL;
    for (NSInteger i =indexFrom; i<numAgrsFrom; ++i) {
        const NSInteger toIdx = indexTo + i - indexFrom;
        if (toIdx >= numArgsTo) break;
        
        const char *argType = [invoFrom.methodSignature getArgumentTypeAtIndex:i];
        NSUInteger argSize;
        NSGetSizeAndAlignment(argType, &argSize, NULL);
        if (!(argBuf = reallocf(argBuf, argSize))) {
            assert(false);
            break;
        }
        
        [invoFrom getArgument:argBuf atIndex:i];
        [invoTo setArgument:argBuf atIndex:toIdx];
    }
    
    if (argBuf != NULL) {
        free(argBuf);
    }
}


static void copyInvocationReturnValue(NSInvocation* invoFrom, NSInvocation* invoTo) {
    void *argBuf = NULL;
    const char* type = invoFrom.methodSignature.methodReturnType;
    NSUInteger argSize;
    NSGetSizeAndAlignment(type, &argSize, NULL);
    
    if (argSize) {
        if ((argBuf = malloc(argSize))) {
            [invoFrom getReturnValue:argBuf];
            [invoTo setReturnValue:argBuf];
            
            free(argBuf);
            argBuf = NULL;
        }
    }
}

static SEL newSelector(SEL selector) {
    return NSSelectorFromString([NSString stringWithFormat:@"_new$_%@", NSStringFromSelector(selector)]);
}

static IMP getMsgForwardIMP(Class cls, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    const char *encoding = method_getTypeEncoding(class_getInstanceMethod(cls, selector));
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

-(void)installSelectorWithBlockTarget:(id)target sel:(SEL)selector block:(id)block{
    
    assert(target);
    assert(selector);
    assert(target != block);
    
#define keySelector(sel) sel
    static SEL newMethodSignatureForSelector = nil;
    static IMP newMethodSignatureForSelectorImp = nil;
    static SEL newRespondsToSelector = nil;
    static IMP newRespondsToSelectorImp = nil;
    static SEL newForwardInvocationSelector = nil;
    static IMP newForwardInvocationImp = nil;
    
    if (!newMethodSignatureForSelector) {
        newMethodSignatureForSelector = newSelector(@selector(methodSignatureForSelector:));
        newMethodSignatureForSelectorImp =
        imp_implementationWithBlock(^NSMethodSignature*(__unsafe_unretained id slf, SEL aSelector) {
            id block = objc_getAssociatedObject(slf, keySelector(aSelector));
            if (isBlock(block)) {
                NSMethodSignature* methodSig = methodSignatureFromBlock(block);
                NSString* signatureString = selectorSignatureStringFromBlockMethodSignature(methodSig);
                return [NSMethodSignature signatureWithObjCTypes:signatureString.UTF8String];
            }else if (class_respondsToSelector(object_getClass(slf), newSelector(aSelector)))
                aSelector = newSelector(aSelector);
            
            return ((id (*)(id, SEL, SEL))objc_msgSend)(slf, newMethodSignatureForSelector, aSelector);
        });
        
        newRespondsToSelector = newSelector(@selector(respondsToSelector:));
        newRespondsToSelectorImp =
        imp_implementationWithBlock(^BOOL(__unsafe_unretained id slf, SEL aSelector) {
            if (((BOOL (*)(id, SEL, SEL))objc_msgSend)(slf, newRespondsToSelector, aSelector))
                return YES;
            return isBlock(objc_getAssociatedObject(slf, keySelector(aSelector)));
        });
        
        newForwardInvocationSelector = newSelector(@selector(forwardInvocation:));
        newForwardInvocationImp =
        imp_implementationWithBlock(^(__unsafe_unretained id slf, NSInvocation* anInvocation){
            id block = objc_getAssociatedObject(slf, keySelector(anInvocation.selector));
            if (isBlock(block)) {
                NSInvocation* invo = [NSInvocation invocationWithMethodSignature:methodSignatureFromBlock(block)];
                copyInvocationArgs(anInvocation, 2, invo, 1);
                [invo invokeWithTarget:block];
                copyInvocationReturnValue(invo, anInvocation);
                return;
            }else if (class_respondsToSelector(object_getClass(slf), newSelector(anInvocation.selector))) {
                [anInvocation setSelector:newSelector(anInvocation.selector)];
                [anInvocation invokeWithTarget:slf];
                return;
            }
            return ((void (*)(id, SEL, id))objc_msgSend)(slf, newForwardInvocationSelector, anInvocation);
        });
    }
    
    Class cls = object_getClass(target);
    swizzler(cls, @selector(methodSignatureForSelector:), newMethodSignatureForSelector, newMethodSignatureForSelectorImp);
    swizzler(cls, @selector(respondsToSelector:), newRespondsToSelector, newRespondsToSelectorImp);
    swizzler(cls, @selector(forwardInvocation:), newForwardInvocationSelector, newForwardInvocationImp);
    
    if (class_respondsToSelector(cls, selector)) {
        swizzler(cls, selector, newSelector(selector), getMsgForwardIMP(cls, selector));
    }
    objc_setAssociatedObject(target, keySelector(selector), [block copy] , OBJC_ASSOCIATION_RETAIN);
#undef keySelector
}

@end
