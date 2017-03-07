//
//  WDDownloadClient.m
//  FeiFan
//
//  Created by fy on 16/1/13.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import "WDDownloadClient.h"
#import "FF_AFURLSessionManager.h"
#import <libkern/OSAtomic.h>
#import "FFWeakObj.h"
#import "SafeCategory.h"


@interface WDDownloadClient ()

@property (nonatomic, strong) NSMutableDictionary *downloadingApis;


@end

@implementation WDDownloadClient
FF_DEF_SINGLETON(WDDownloadClient)

static OSSpinLock _downloadSpinLock = OS_SPINLOCK_INIT;

- (instancetype)init
{
    if (self = [super init]) {
        self.downloadingApis = [NSMutableDictionary dictionary];
    }
    
    return self ;
}

- (void)execute:(WDDownloadApi *)api
        success:(downloadSuccess)success
        failure:(downloadFailure)failure
{
    
    if (![api resourceUrl]) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@?file=%@&suffix=%@",[api baseUrl],[api relativePath],[api resourceUrl],[api fileType]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    FF_AFURLSessionManager *manager = [[FF_AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSProgress *progress;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:[api toDir]]) {
        [fm createDirectoryAtPath:[api toDir] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    weakObj(self);
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *filePath;
        
        if ([api fileName]) {
            
            filePath = [[[api toDir] mutableCopy] stringByAppendingPathComponent:[api fileName]];
            
        }
        else
        {
            filePath = [[[api toDir] mutableCopy] stringByAppendingPathComponent:response.suggestedFilename];
            
        }
        
        return [NSURL fileURLWithPath:filePath];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        strongObj(self);
        if (error) {
            failure(error);
        }
        else{
            success(response, filePath);
        }
        
        [progress removeObserver:self forKeyPath:@"completedUnitCount" context:nil];
        
        OSSpinLockLock(&_downloadSpinLock);
        [self.downloadingApis removeObjectForKey:urlStr];
        OSSpinLockUnlock(&_downloadSpinLock);
    }];
    
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(urlStr)];
    OSSpinLockLock(&_downloadSpinLock);
    [self.downloadingApis safeSetObject:api forKey:urlStr];
    OSSpinLockUnlock(&_downloadSpinLock);
    
    [downloadTask resume];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 由于context类型转换crash，屏蔽刷新进度
    /*
    if ([keyPath isEqualToString:@"completedUnitCount"]) {
        
        NSString *urlStr = (__bridge NSString *)(context);
        OSSpinLockLock(&_downloadSpinLock);
        WDDownloadApi *api = [self.downloadingApis objectForKey:urlStr];
        OSSpinLockUnlock(&_downloadSpinLock);
        if (api) {
            NSProgress *progress = (NSProgress *)object;
            [api downloadingProgressChanged:progress];
        }
    }  
     */
}

@end
