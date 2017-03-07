//
//  NSInvocation+utility.m
//  XUtility
//
//  Created by go886 on 15/1/21.
//  Copyright (c) 2015年 go886. All rights reserved.
//

#import "NSInvocation+utility.h"
#import <objc/message.h>
#import <CoreGraphics/CGGeometry.h>


template<typename T>
T parser(va_list* valist) {
    T value = va_arg(*valist, T);
    return value;
}

template <>
short parser(va_list* valist) {
    return (va_arg(*valist, int));
}

template <>
unsigned short parser(va_list* valist) {
    return (va_arg(*valist, int));
}

template <>
char parser(va_list* valist) {
    return (va_arg(*valist, int));
}

template <>
signed char parser(va_list* valist) {
    return (va_arg(*valist, int));
}

template <>
unsigned char parser(va_list* valist) {
    return (va_arg(*valist, int));
}

template <>
bool parser(va_list* valist) {
    return (va_arg(*valist, int));
}

template <>
float parser(va_list* valist) {
    return (va_arg(*valist, double));
}


template<typename T>
void setArgument(NSInvocation* invo, NSUInteger index, va_list* valist) {
    T v = parser<T>(valist);
    [invo setArgument:&v atIndex:index];
}

static void _setArgument(NSInvocation* invo, NSUInteger index, va_list* valist) {
    const char *argType = [invo.methodSignature getArgumentTypeAtIndex:index];
    if (argType[0] == _C_CONST) argType++;       // Skip const type qualifier.
    
    
#define typecase(T) \
if(0 == strncmp(argType, @encode(T), strlen(@encode(T))) ) { \
setArgument<T>(invo, index, valist); \
return; \
}
    
    //    typecase(void (^)());
    typecase(IMP)
    typecase(__unsafe_unretained id)
    typecase(__unsafe_unretained Class)
    typecase(SEL)
    typecase(char)
    typecase(int)
    typecase(short)
    typecase(long)
    typecase(long long)
    typecase(unsigned char)
    typecase(unsigned int)
    typecase(unsigned short)
    typecase(unsigned long)
    typecase(unsigned long long)
    typecase(float)
    typecase(double)
    typecase(BOOL)
    typecase(bool)
    typecase(char*)
    
    typecase(CGRect);
    typecase(CGSize);
    typecase(CGPoint)
    typecase(CGVector)
    
    
    if (*argType == _C_PTR) {
        setArgument<void*>(invo, index, valist);
        return;
    }
#undef typecase
}

@implementation NSInvocation (utility)
-(void)argFromvalist:(va_list)valist beginIndex:(NSInteger)index {
    va_list va;
    va_copy(va, valist);
    
    for (NSInteger i = index; i<self.methodSignature.numberOfArguments; ++i) {
        _setArgument(self, i, &va);
    }
    va_end(va);
}
@end
