//
//  VSDependencyManage.m
//  VSReplaceMethod
//
//  Created by YaoMing on 14-3-24.
//  Copyright (c) 2014年 YaoMing. All rights reserved.
//

#import "VSDependencyManager.h"
#import "VSDependencyObject.h"
#import "VSMethodHander.h"
#import "UIGestureRecognizer+VSDependencyManager.h"
#import "UIView+VSDependencyManager.h"
#import "UIViewController+VSDependencyManager.h"
#import "UIControl+VSDependencyManager.h"
#import "NSObject+VSDependencyManager.h"

#import "UIScrollView+VSScrollView.h"
#import "UITableView+VSTableView.h"
#import "UIPickerView+VSPickerView.h"
#import "NSTimer+VSTimer.h"
#import "UIWebView+VSWebView.h"
#import "UICollectionView+VSCollectionView.h"
static VSDependencyManager *VSDependencyManageInstance = nil;
@interface VSDependencyManager()
@property (atomic,strong)NSMutableDictionary *dic;
@end



@implementation VSDependencyManager


+ (VSDependencyManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == VSDependencyManageInstance) {
            VSDependencyManageInstance = [[VSDependencyManager alloc] init];
            VSDependencyManageInstance.dic = [NSMutableDictionary dictionary];
        }
    });
    return VSDependencyManageInstance;
}

- (void)start
{
    [[VSMethodHander shareInstance] replaceClass:[UIView class] newSEL:@selector(VSDealloc) origSEL:NSSelectorFromString(@"dealloc")];
    [[VSMethodHander shareInstance] replaceClass:[UIViewController class] newSEL:@selector(VSDealloc) origSEL:NSSelectorFromString(@"dealloc")];
    [[VSMethodHander shareInstance] replaceClass:[UIGestureRecognizer class] newSEL:@selector(initDependencyWithTarget:action:) origSEL:@selector(initWithTarget:action:)];
    [[VSMethodHander shareInstance] replaceClass:[UIGestureRecognizer class] newSEL:@selector(addDependencyTarget:action:) origSEL:@selector(addTarget:action:)];
    [[VSMethodHander shareInstance] replaceClass:[UIControl class] newSEL:@selector(addDependencyTarget:action:forControlEvents:) origSEL:@selector(addTarget:action:forControlEvents:)];
    [[VSMethodHander shareInstance] replaceClass:[NSObject class] newSEL:@selector(addDependencyObserver:forKeyPath:options:context:) origSEL:@selector(addObserver:forKeyPath:options:context:)];
    [[VSMethodHander shareInstance] replaceClass:[NSObject class] newSEL:@selector(removeOCObserver:forKeyPath:) origSEL:@selector(removeObserver:forKeyPath:)];
    [[VSMethodHander shareInstance] replaceClass:[NSObject class] newSEL:@selector(removeOCObserver:forKeyPath:context:) origSEL:@selector(removeObserver:forKeyPath:context:)];

    
    [[VSMethodHander shareInstance] replaceClass:[UIScrollView class] newSEL:@selector(setScrollDelegate:) origSEL:@selector(setDelegate:)];
    [[VSMethodHander shareInstance] replaceClass:[UITableView class] newSEL:@selector(setTableDelegate:) origSEL:@selector(setDelegate:)];
    [[VSMethodHander shareInstance] replaceClass:[UITableView class] newSEL:@selector(setTableDataSource:) origSEL:@selector(setDataSource:)];
    [[VSMethodHander shareInstance] replaceClass:[UIWebView class] newSEL:@selector(setWebViewDelegate:) origSEL:@selector(setDelegate:)];

    [[VSMethodHander shareInstance] replaceClass:[UICollectionView class] newSEL:@selector(setCollectionDelegate:) origSEL:@selector(setDelegate:)];
    [[VSMethodHander shareInstance] replaceClass:[UICollectionView class] newSEL:@selector(setCollectionDataSource:) origSEL:@selector(setDataSource:)];

    [[VSMethodHander shareInstance] replaceClass:[UIPickerView class] newSEL:@selector(setPickerDelegate:) origSEL:@selector(setDelegate:)];
    [[VSMethodHander shareInstance] replaceClass:[UIPickerView class] newSEL:@selector(setPickerDataSource:) origSEL:@selector(setDataSource:)];
    
    [[VSMethodHander shareInstance] replaceClassMethod:[NSTimer class] newSEL:@selector(scheduledVSTimerWithTimeInterval:target:selector:userInfo:repeats:) origSEL:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
    
    

}

- (void)addObserver:(id)observer source:(id)source
{
    if (nil == observer || nil == source) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([observer class]),observer];
    if ([_dic objectForKey:key]) {
        id obj = [_dic objectForKey:key];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:obj];
            if (![array containsObject:source]) {
                [array addObject:source];
                [_dic setObject:array forKey:key];
            }
        }
    }else{
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:source];
        [_dic setObject:array forKey:key];
    }
}

- (void)addObserver:(id)observer keySource:(VSDependencyObject *)keySource
{
    [self addObserver:observer source:keySource];
}

- (BOOL)observer:(id)observer inkeySource:(id)keySource keyPath:(NSString*)path{
    NSString *key = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([observer class]),observer];
    id obj = [_dic objectForKey:key];
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        for (id source in obj) {
            if ([source isKindOfClass:[VSDependencyObject class]]) {
                if ([(VSDependencyObject*)source resource] == keySource&&[(VSDependencyObject*)source key] == path) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL)observerremove:(id)observer inkeySource:(id)keySource keyPath:(NSString*)path{
    NSString *key = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([observer class]),observer];
    id obj = [_dic objectForKey:key];
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        for (id source in obj) {
            if ([source isKindOfClass:[VSDependencyObject class]]) {
                if ([(VSDependencyObject*)source resource] == keySource&&[(VSDependencyObject*)source key] == path) {
                    [obj removeObject:source];
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (void)removeObserver:(id)observer
{
    if (nil == observer) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([observer class]),observer];
    id obj = [_dic objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:obj];
        if ([array count] > 0) {
            for (id source in array) {
                if ([source isKindOfClass:[VSDependencyObject class]]) {
                    VSDependencyObject *dependencyObj = (VSDependencyObject *)source;
                    if (dependencyObj.resource != nil && dependencyObj.key != nil) {
                            [dependencyObj.resource removeObserver:observer forKeyPath:dependencyObj.key context:nil];
                    }
                }
                
                if ([source isKindOfClass:[UIControl class]]) {
                    [source removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                }else if ([source isKindOfClass:[UIGestureRecognizer class]]){
                    [source removeTarget:nil action:NULL];
                }else if([source isKindOfClass:[UITableView class]]){
                    [source setDelegate:nil];
                    [source setDataSource:nil];
                }else if ([source isKindOfClass:[UIWebView class]]){
                    [source stopLoading];
                    ((UIWebView *)source).scrollView.delegate = nil;
                    [source setDelegate:nil];
                }else if ([source isKindOfClass:[UICollectionView class]]){
                    [source setDelegate:nil];
                    if([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
                    {
                        [source setDataSource:nil];
                    }
                }else if([source isKindOfClass:[UIPickerView class]]){
                    [source setDelegate:nil];
                    [source setDataSource:nil];
                }else if ([source isKindOfClass:[UIScrollView class]]){
                    [source setDelegate:nil];
                }else if([source isKindOfClass:[NSTimer class]]){
                    if ([source isValid]) {
                        [source invalidate];
                    }
                }
            }
        }
        [_dic removeObjectForKey:key];
    }
}

- (void)removeObserverAll:(id)observer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:observer];
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    [self removeObserver:observer];
}


- (BOOL)isManagerObject:(id)object
{
    if(object && ([object isKindOfClass:[UIView class]] || [object isKindOfClass:[UIViewController class]])){
        return YES;
    }
    return NO;
}

@end
