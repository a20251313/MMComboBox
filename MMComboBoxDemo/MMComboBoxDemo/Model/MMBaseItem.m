//
//  MMBaseItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMBaseItem.h"
#import <objc/runtime.h>

static const void *kMMKeyKey = &kMMKeyKey;
static const void *kMMCodeKey = &kMMCodeKey;

@implementation MMBaseItem


- (void)setKey:(NSString *)key
{
    objc_setAssociatedObject(self, kMMKeyKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self setValue:key forKey:@"key"];
}

- (NSString*)key
{
    return objc_getAssociatedObject(self, kMMKeyKey);
    
}

- (void)setCode:(NSString *)code
{
    objc_setAssociatedObject(self, kMMCodeKey,code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //   [self setValue:code forKey:@"code"];
}

- (NSString*)code
{
    return objc_getAssociatedObject(self, kMMCodeKey);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayType = MMPopupViewDisplayTypeNormal;
        self.hasAllFuntion = YES;
        self.isOpen = YES;
    }
    return self;
}


@end


static const void *kFFBaseKeyCodeModelKeyKey = &kFFBaseKeyCodeModelKeyKey;
static const void *kFFBaseKeyCodeModelCodeKey = &kFFBaseKeyCodeModelCodeKey;

@interface FFBaseKeyCodeModel ()
@end


@implementation FFBaseKeyCodeModel



- (NSString*)description
{
    return [NSString stringWithFormat:@"FFBaseKeyCodeModel<%p> key:%@ code:%@",self,self.key,self.code];
}
+ (FFBaseKeyCodeModel*)modelWithKey:(NSString*)key code:(NSString*)code
{
    FFBaseKeyCodeModel  *baseModel = [[FFBaseKeyCodeModel alloc] init];
    baseModel.key = key;
    baseModel.code = code;
    return baseModel;
}
- (void)setKey:(NSString *)key
{
    objc_setAssociatedObject(self, kFFBaseKeyCodeModelKeyKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self setValue:key forKey:@"key"];
}

- (NSString*)key
{
    return objc_getAssociatedObject(self, kFFBaseKeyCodeModelKeyKey);
    
}

- (void)setCode:(NSString *)code
{
    objc_setAssociatedObject(self, kFFBaseKeyCodeModelCodeKey,code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //   [self setValue:code forKey:@"code"];
}

- (NSString*)code
{
    return objc_getAssociatedObject(self, kFFBaseKeyCodeModelCodeKey);
}


@end



