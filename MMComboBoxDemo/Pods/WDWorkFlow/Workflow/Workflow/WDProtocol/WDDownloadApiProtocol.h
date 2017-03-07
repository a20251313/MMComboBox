//
//  FFDownloadApiProtocol.h
//  FeiFan
//
//  Created by fy on 16/1/28.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WDDownloadApiProtocol <NSObject>

@required

/**
 *  下载任务的在飞凡服务器上的file值
 *
 *  @return NSString
 */
- (NSString *)resourceUrl;

/**
 *  下载文件的类型
 *
 *  @return NSString
 */
- (NSString *)fileType;

/**
 *  下载文件存储至本地沙盒中的文件夹路径
 *
 *  @return NSString
 */
- (NSString *)toDir;

@optional

/**
 *  飞凡文件下载服务器域名，一般不需实现修改
 *
 *  @return NSString
 */
- (NSString *)baseUrl;


/**
 *  飞凡下载文件接口，一般不需子类实现修改
 *
 *  @return NSString
 */
- (NSString *)relativePath;


/**
 *  如果实现此方法，则下载文件以该文件名存储至toDir路径，若未实现，则使用原文件名称。
 *
 *  @return NSString
 */
- (NSString *)fileName;

- (BOOL)isUseHTTPS;

@end

