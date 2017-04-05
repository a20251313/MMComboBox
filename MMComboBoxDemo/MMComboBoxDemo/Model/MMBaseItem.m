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
static const void *kMMChoiceKey = &kMMChoiceKey;
static const void *kMMChoiceKey2 = &kMMChoiceKey2;
static const void *kMMCode2Key = &kMMCode2Key;

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

- (void)setChoiceDefault:(BOOL)choiceDefault
{
    objc_setAssociatedObject(self, kMMChoiceKey, @"choiceDefault", OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)choiceDefault
{
    return (BOOL)objc_getAssociatedObject(self, kMMChoiceKey);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayType = MMPopupViewDisplayTypeNormal;
        self.hasAllFuntion = YES;
        self.isOpen = YES;
        self.filterNeedCall = NO;
    }
    return self;
}


- (NSString*)key2
{
    return objc_getAssociatedObject(self, kMMChoiceKey2);
    
}

- (void)setKey2:(NSString *)key
{
    objc_setAssociatedObject(self, kMMChoiceKey2, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setCode2:(NSString *)code
{
    objc_setAssociatedObject(self, kMMCode2Key,code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //   [self setValue:code forKey:@"code"];
}

- (NSString*)code2
{
    return objc_getAssociatedObject(self, kMMCode2Key);
}

@end


static const void *kFFBaseKeyCodeModelKeyKey = &kFFBaseKeyCodeModelKeyKey;
static const void *kFFBaseKeyCodeModelCodeKey = &kFFBaseKeyCodeModelCodeKey;
static const void *kFFBaseKeyCodeModelChoiceKey = &kFFBaseKeyCodeModelChoiceKey;
static const void *kFFBaseKeyCodeModelCodeKey2 = &kFFBaseKeyCodeModelCodeKey2;
static const void *kFFBaseKeyCodeModelChoiceKey2 = &kFFBaseKeyCodeModelChoiceKey2;

@interface FFBaseKeyCodeModel ()
@end


@implementation FFBaseKeyCodeModel

- (NSString*)description
{
    return [NSString stringWithFormat:@"FFBaseKeyCodeModel<%p> key:%@ code:%@ choiceDefault:%d key2:%@ code2:%@",self,self.key,self.code,self.choiceDefault,self.key2,self.code2];
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

- (void)setChoiceDefault:(BOOL)choiceDefault
{
    objc_setAssociatedObject(self, kFFBaseKeyCodeModelChoiceKey, @"choiceDefault", OBJC_ASSOCIATION_ASSIGN);
}

- (NSString*)key2
{
    return objc_getAssociatedObject(self, kFFBaseKeyCodeModelCodeKey2);
    
}


- (void)setKey2:(NSString *)key
{
    objc_setAssociatedObject(self, kFFBaseKeyCodeModelCodeKey2, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setCode2:(NSString *)code
{
    objc_setAssociatedObject(self, kFFBaseKeyCodeModelChoiceKey2,code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //   [self setValue:code forKey:@"code"];
}

- (NSString*)code2
{
    return objc_getAssociatedObject(self, kFFBaseKeyCodeModelChoiceKey2);
}

- (BOOL)choiceDefault
{
    return (BOOL)objc_getAssociatedObject(self, kFFBaseKeyCodeModelChoiceKey);
}


@end



