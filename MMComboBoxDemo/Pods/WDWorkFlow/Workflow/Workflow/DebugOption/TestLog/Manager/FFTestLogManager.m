//
//  FFTestLogManager.m
//  FeiFan
//
//  Created by fy on 15/12/16.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFTestLogManager.h"
#import "FFTestLogViewController.h"
#import <libkern/OSAtomic.h>
#import "FFDebugOptionManager.h"

#import "SafeCategory.h"


#define DisplayLogCount 50
#define LocalSaveCount 100
@interface FFTestLogManager()
@property (nonatomic, strong) FFTestLogWindow *testLogWindow;
@property (nonatomic, strong)NSPipe *pipe;
@property (nonatomic, strong)NSMutableArray *logArray;
@property (nonatomic, assign)BOOL haveCatchLog;

@end

@implementation FFTestLogManager
@synthesize logArray = _logArray;

#define kDefaultWindowWidth [UIScreen mainScreen].bounds.size.width
#define kDefaultWindowHeight [UIScreen mainScreen].bounds.size.height

FF_DEF_SINGLETON(FFTestLogManager)

- (void)load
{
    self.haveCatchLog = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugValueChanged:) name:NKey_DebugOptionKeyValueChanged object:nil];
}

- (void)debugValueChanged:(NSNotification *)notify
{
    NSDictionary *keyValue = notify.object;
    
    if ([[keyValue objectForKey:@"key"] isEqualToString:@"ScreenLog"] ) {
        if (![[keyValue objectForKey:@"value"] boolValue]) {
            [self closeLogWindow];
        }
        else
        {
            [self showLogOnScreen];
        }
        
    }
}

- (void)showLogOnScreen
{
    if (!self.haveCatchLog) {
        [self catchLog];
    }
    self.testLogWindow.hidden = NO;
    [self.testLogWindow makeKeyAndVisible];
}

- (void)closeLogOnScreen
{
    
    [self closeLogWindow];
    [self sendCloseNotify];

}

- (void)closeLogWindow
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window makeKeyWindow];
    self.testLogWindow.hidden = YES;
}

- (void)sendCloseNotify
{
    [[FFDebugOptionManager sharedInstance] setDebugOptionValue:@(0) forKey:@"ScreenLog"];
    
}

- (void)clean
{
    self.logArray = [NSMutableArray array];
}

- (void)addLogString:(NSString *)string
{
    @synchronized(self) {
        
        
        [self.logArray addObjectsFromArray:[self logsArrayWithString:string]];
        
        [self limitLogCountWithInteger:LocalSaveCount];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationGetANewLog" object:nil];
        
    }
}

#pragma mark - Private

- (void)limitLogCountWithInteger:(NSInteger)maxCount
{
    if (self.logArray.count > maxCount) {
        [self.logArray removeObjectsInRange:NSMakeRange(0, LocalSaveCount/2)];
    }
}

- (NSArray *)logsArrayWithString:(NSString *)string
{
    NSMutableString *tmpStr = [string mutableCopy];
    NSString *re = @"\\d+-\\d+-\\d+\\s\\d+:\\d+:\\d+\\.\\d+\\s\\w+\\[\\d+:\\d+\\]\\s"; //正则表达式勿动
    NSRange range;
    NSString *tmp;
    NSMutableArray *stringArray = [NSMutableArray array];
    
    range = [tmpStr rangeOfString:re options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return [NSArray arrayWithObject:string];
    }else
    {
        while (range.location != NSNotFound) {
            tmpStr = [[tmpStr substringFromIndex:range.location + range.length] mutableCopy];
            
            range = [tmpStr rangeOfString:re options:NSRegularExpressionSearch];
            
            if (range.location != NSNotFound) {
                tmp = [tmpStr substringToIndex:range.location - 1];
                
            }
            else
            {
                tmp = [tmpStr mutableCopy];
            }
            [stringArray safeAddObject:tmp];
        }
    }
    return [NSArray arrayWithArray:stringArray];
}

- (void)redirectNotificationHandle:(NSNotification *)nf{
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addLogString:str];
    
    [[nf object] readInBackgroundAndNotify];
}

- (void)catchLog
{
    
    NSPipe * pipe = [NSPipe pipe] ;
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    dup2([[pipe fileHandleForWriting] fileDescriptor], STDERR_FILENO);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle];
    [pipeReadHandle readInBackgroundAndNotify];
    
    self.haveCatchLog = YES;
}

#pragma mark - Property

- (UIWindow *)testLogWindow
{
    if (!_testLogWindow) {
        
        _testLogWindow = [[FFTestLogWindow alloc] init];
        _testLogWindow.windowLevel = 2001;
        _testLogWindow.frame = CGRectMake(0, 0, kDefaultWindowWidth, kDefaultWindowHeight);
        _testLogWindow.backgroundColor = [UIColor clearColor];
        _testLogWindow.rootViewController = [[FFTestLogViewController alloc] initWithNibName:nil bundle:nil];
        
    }
    
    return _testLogWindow;
}

- (NSMutableArray *)logArray
{
    if (!_logArray) {
        _logArray = [NSMutableArray array];
    }
    return _logArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
