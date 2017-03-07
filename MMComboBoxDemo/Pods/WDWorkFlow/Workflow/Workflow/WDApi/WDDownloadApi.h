//
//  FFDownloadApi.h
//  FeiFan
//
//  Created by fy on 16/1/14.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDDownloadApiProtocol.h"

@class WDDownloadApi;

@protocol WDDownloadApiDelegate <NSObject>

@optional

/**
 *  下载完成回调
 */
- (void)downloadApi:(WDDownloadApi *)api didFinishedDownloadingWithResponse:(NSURLResponse *)response filePath:(NSString *)filePath;
/**
 *  下载失败回调
 */
- (void)downloadApi:(WDDownloadApi *)api downloadingError:(NSError *)error;

/**
 *  下载过程中实时获取下载进度
 */
- (void)downloadApi:(WDDownloadApi *)api downloadingProcessChanged:(NSProgress *)progress;

@end


/**
 *  实现FFDownloadApi子类，定制下载任务Api
 */
@interface WDDownloadApi : NSObject <WDDownloadApiProtocol>

@property (nonatomic, assign) BOOL isDownloading; //Api正在执行下载中与否
@property (nonatomic, weak) id<WDDownloadApiDelegate> delegate;

/**
 *  开始下载任务
 */
- (void)start;

@end

@interface WDDownloadApi(DownloadClient)
/**
 *  方法为框架本身调用，不面向使用者！
 */
- (void)downloadingProgressChanged:(NSProgress *)progress;

@end


