//
//  WDDownloadApi.m
//  FeiFan
//
//  Created by fy on 16/1/14.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import "WDDownloadApi.h"
#import "WDDownloadClient.h"
#import "WDBaseApi.h"
#import "FFWeakObj.h"

@implementation WDDownloadApi

- (instancetype)init
{
    if (self = [super init]) {
        self.isDownloading = NO;
    }

    return self;
}

- (NSString *)baseUrl
{
    return @"";
}

- (NSString *)relativePath
{
    return @"";
}

- (BOOL)isUseHTTPS
{
    return YES;
}

- (NSString *)resourceUrl
{
    return nil;
}

- (NSString *)fileType
{
    return nil;
}

- (NSString *)toDir
{
    return nil;
}

- (NSString *)fileName
{
    return nil;
}

- (void)start
{
    weakObj(self);

    if (self.isDownloading == YES) {
        return;
    }
    self.isDownloading = YES;

    if (![self resourceUrl]) {
        return;
    }

    NSLog(@"开始下载:%@",[self resourceUrl]);
    [[WDDownloadClient sharedInstance] execute:self success:^(NSURLResponse *response, NSURL *filePath) {
        strongObj(self);
        self.isDownloading = NO;
        [self safeDelegateDidFinishDownloadingWithRespnse:response filePath:filePath.absoluteString];
    } failure:^(NSError *error) {

        strongObj(self);
        self.isDownloading = NO;
        [self safeDelegateDownloadingFailureWithError:error];
    }];

}

- (void)safeDelegateDidFinishDownloadingWithRespnse:(NSURLResponse *)response filePath:(NSString *)filePath
{
    if ([self.delegate respondsToSelector:@selector(downloadApi:didFinishedDownloadingWithResponse:filePath:)]) {
        [self.delegate downloadApi:self didFinishedDownloadingWithResponse:response filePath:filePath];
    }
}

- (void)safeDelegateDownloadingFailureWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(downloadApi:downloadingError:)]) {
        [self.delegate downloadApi:self downloadingError:error];
    }
}

- (void)downloadingProgressChanged:(NSProgress *)progress
{
    if ([self.delegate respondsToSelector:@selector(downloadApi:downloadingProcessChanged:)]) {
        [self.delegate downloadApi:self downloadingProcessChanged:progress];
    }
}

@end
