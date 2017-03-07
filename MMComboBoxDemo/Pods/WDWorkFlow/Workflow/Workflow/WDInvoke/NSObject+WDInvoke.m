//
//  NSObject+WDInvoke.m
//  Pods
//
//  Created by bright ming on 16/11/10.
//
//

#import "NSObject+WDInvoke.h"
#import <objc/runtime.h>

@implementation NSObject(WDInvoke)

static NSUInteger _selectorArgumentCount(SEL selector)
{
    NSUInteger argumentCount = 0;
    const char *selectorStringCursor = sel_getName(selector);
    char ch;
    while((ch = *selectorStringCursor)) {
        if(ch == ':') {
            ++argumentCount;
        }
        ++selectorStringCursor;
    }
    return argumentCount;
}

id _wd_invoke(id target, SEL selector, WDInvokeArray *arguments) {
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    id oldTarget = target;
    if (!signature) {
        target = [target class];
        signature = [target methodSignatureForSelector:selector];
    }
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        if (!invocation) return nil;
        
        [invocation setSelector:selector];
        [invocation setTarget:target];
        
        if (_selectorArgumentCount(selector) == arguments.count) {
            if (arguments.count > 0){
                for (int idx = 0; idx<arguments.count; idx++) {
                    id item = arguments[idx];
                    [invocation wd_setArgument:item atIndex:idx+2];
                }
            }
        }else{
            if(object_isClass(oldTarget)){
                NSLog(@"RUNTIME ERROR: + [%@ %@] error arguments: %@\n",target,NSStringFromSelector(selector),arguments);
            }else{
                NSLog(@"RUNTIME ERROR: - [%@ %@] error arguments: %@\n",[oldTarget class],NSStringFromSelector(selector),arguments);
            }
            return nil;
        }
        
        [invocation retainArguments];
        [invocation invoke];
        if (signature.methodReturnLength) {
            
#if DEBUG && WD_INVOKE_LOG_ENABLED
            if(object_isClass(oldTarget)){
                NSLog(@"INVOKE INFO: + [%@ %@]\narguments:\n%@\n",target,NSStringFromSelector(selector),arguments);
            }else{
                NSLog(@"INVOKE INFO: - [%@ %@]\narguments:\n%@\n",[oldTarget class],NSStringFromSelector(selector),arguments);
            }
#endif
            return (id)[invocation wd_returnValue];
        }
        
        return nil;
    }else {
        if(object_isClass(oldTarget)){
            NSLog(@"RUNTIME ERROR: + [%@ %@] unrecognized selector sent to class \'%@\'",target,NSStringFromSelector(selector),target);
        }else{
            NSLog(@"RUNTIME ERROR: - [%@ %@] unrecognized selector sent to instance %@",[oldTarget class],NSStringFromSelector(selector),oldTarget);
        }
        return nil;
    }
}

+ (id)wd_obj
{
    return [[[self class] alloc] init];
}

- (id)wd_invoke:(SEL)selector
{
    return [self wd_invoke:selector arguments:nil];
}

- (id)wd_invoke:(SEL)selector arguments:(WDInvokeArray *)arguments
{
    return _wd_invoke(self, selector, arguments);
}

+ (id)wd_invoke:(SEL)selector
{
    return [self.class wd_invoke:selector arguments:nil];
}

+ (id)wd_invoke:(SEL)selector arguments:(WDInvokeArray *)arguments
{
    return _wd_invoke(self.class, selector, arguments);
}

@end

@implementation  NSString (WDInvoke)
@dynamic wd_class,wd_selector,wd_obj;

- (Class)wd_class
{
    if (self) {
        return NSClassFromString(self);
    }
    return nil;
}

- (SEL)wd_selector
{
    if (self) {
        return NSSelectorFromString(self);
    }
    return nil;
}

- (id)wd_obj
{
    return [[self.wd_class alloc] init];
}

@end


@implementation WDInvokeArray { NSUInteger count; id objs[20]; }

- (NSUInteger)count{
    return count;
}

+ (instancetype):(NSUInteger)count, ... {
    WDInvokeArray *this = [self new];
    this->count = count;
    va_list args;
    va_start(args, count);
    for (NSUInteger x = 0; x < count; ++x)
        this->objs[x] = va_arg(args, id);
    va_end(args);
    return this;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    if (count <= idx) {
        return nil;
    }
    return objs[idx];
}

- (NSString *)description
{
    NSMutableString *des = [NSMutableString stringWithFormat:@"["];
    if (self.count > 0){
        for (int idx = 0; idx<count; idx++) {
            id item = objs[idx];
            [des appendFormat:@"\narg[%d]: %@",idx,item];
        }
    }
    [des appendFormat:@"\n]"];
    return des;
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation NSInvocation (WDInvoke)

- (void)wd_setArgument:(id)object atIndex:(NSUInteger)index {
#define WD_PULL_AND_SET(type, selector) \
do { \
type val = [object selector]; \
[self setArgument:&val atIndex:(NSInteger)index]; \
} while (0)
    
    const char *argType = [self.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == 'r') {
        argType++;
    }
    
    if (strcmp(argType, @encode(id)) == 0 ||
        strcmp(argType, @encode(Class)) == 0) {
        [self setArgument:&object atIndex:(NSInteger)index];
    } else if (strcmp(argType, @encode(char)) == 0) {
        WD_PULL_AND_SET(char, charValue);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WD_PULL_AND_SET(int, intValue);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WD_PULL_AND_SET(short, shortValue);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WD_PULL_AND_SET(long, longValue);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        WD_PULL_AND_SET(long long, longLongValue);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        WD_PULL_AND_SET(unsigned char, unsignedCharValue);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        WD_PULL_AND_SET(unsigned int, unsignedIntValue);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        WD_PULL_AND_SET(unsigned short, unsignedShortValue);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        WD_PULL_AND_SET(unsigned long, unsignedLongValue);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        WD_PULL_AND_SET(unsigned long long, unsignedLongLongValue);
    } else if (strcmp(argType, @encode(float)) == 0) {
        WD_PULL_AND_SET(float, floatValue);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WD_PULL_AND_SET(double, doubleValue);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WD_PULL_AND_SET(BOOL, boolValue);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        const char *cString = [object UTF8String];
        [self setArgument:&cString atIndex:(NSInteger)index];
        [self retainArguments];
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        [self setArgument:&object atIndex:(NSInteger)index];
    } else {
        NSCParameterAssert([object isKindOfClass:NSValue.class]);
        
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment([object objCType], &valueSize, NULL);
#if DEBUG
        NSUInteger argSize = 0;
        NSGetSizeAndAlignment(argType, &argSize, NULL);
        NSCAssert(valueSize == argSize, @"Value size does not match argument size in -wd_setArgument: %@ atIndex: %lu", object, (unsigned long)index);
#endif
        unsigned char valueBytes[valueSize];
        [object getValue:valueBytes];
        
        [self setArgument:valueBytes atIndex:(NSInteger)index];
    }
#undef WD_PULL_AND_SET
}

- (id)wd_returnValue {
#define WD_WRAP_AND_RETURN(type) \
do { \
type val = 0; \
[self getReturnValue:&val]; \
return @(val); \
} while (0)
    
    const char *returnType = self.methodSignature.methodReturnType;
    // Skip const type qualifier.
    if (returnType[0] == 'r') {
        returnType++;
    }
    
    if (strcmp(returnType, @encode(id)) == 0 ||
        strcmp(returnType, @encode(Class)) == 0 ||
        strcmp(returnType, @encode(void (^)(void))) == 0) {
        __autoreleasing id returnObj;
        [self getReturnValue:&returnObj];
        return returnObj;
    } else if (strcmp(returnType, @encode(char)) == 0) {
        WD_WRAP_AND_RETURN(char);
    } else if (strcmp(returnType, @encode(int)) == 0) {
        WD_WRAP_AND_RETURN(int);
    } else if (strcmp(returnType, @encode(short)) == 0) {
        WD_WRAP_AND_RETURN(short);
    } else if (strcmp(returnType, @encode(long)) == 0) {
        WD_WRAP_AND_RETURN(long);
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        WD_WRAP_AND_RETURN(long long);
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        WD_WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        WD_WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        WD_WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        WD_WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        WD_WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(returnType, @encode(float)) == 0) {
        WD_WRAP_AND_RETURN(float);
    } else if (strcmp(returnType, @encode(double)) == 0) {
        WD_WRAP_AND_RETURN(double);
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {
        WD_WRAP_AND_RETURN(BOOL);
    } else if (strcmp(returnType, @encode(char *)) == 0) {
        WD_WRAP_AND_RETURN(const char *);
    } else if (strcmp(returnType, @encode(void)) == 0) {
        return nil;
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        
        unsigned char valueBytes[valueSize];
        [self getReturnValue:valueBytes];
        
        return [NSValue valueWithBytes:valueBytes objCType:returnType];
    }
    
    return nil;
    
#undef WD_WRAP_AND_RETURN
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
