//
//  FFDataProviderProtocol.h
//  FeiFan
//
//  Created by 李魁峰 on 15/8/4.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    DP_None = 0,
    DP_LoadLocal,
    DP_Query,
    DP_Refresh,
    DP_LoadMore,
} DPMethod;

@protocol FFDataProviderProtocol;


@protocol FFDataProviderDelegate <NSObject>
@required
/**
 *  请求成功
 *
 *  @param dp
 */
- (void)requestSuccessed:(id<FFDataProviderProtocol>)dp;

/**
 *  请求失败
 *
 *  @param dp
 *  @param error 失败Error !!!有可能非空
 */
- (void)requestFailured:(id<FFDataProviderProtocol>)dp
                   error:(NSError *) error;

@end


/**
 *  数据提供层协议: 一次请求一次回调
 */
@protocol FFDataProviderProtocol <NSObject>

@optional
/**
 *  仅从本地加载数据，不管数据过期与否都将数据返回
 */
- (void)loadLocal;

/**
 *  从数据库检索数据,同步请求,只会进入 requestSuccessed 分支，无数据时返回 nil
 *  注意:
 *      1. query，永远只会成功
 *      2. query，为同步
 *      3. 在(requestSuccessed|requestFailured)中不要发起query操作，以免(requestSuccessed|requestFailured)错乱
 */
- (void)query;

@required
/**
 *  从服务器刷新数据，异步请求,请求成功刷新数据库
 */
- (void)refresh;

@optional
/**
 *  @return 当前的请求类型
 *  注意:
 1. 有效期: (query | resfresh) -> (requestSuccessed|requestFailured)之后
 2. 在(requestSuccessed|requestFailured)之后设置为:DP_None, 以确保在回调中状态值为非DP_None
 */
- (DPMethod)method;

/**
 *  @return 当前的请求状态
 *  注意:
 1. 有效期: (query | refresh) -> (requestSuccessed|requestFailured)之前
 2. 在(requestSuccessed|requestFailured)之前设置为:NO, 以确保回调处理中状态值为NO
 */
- (BOOL)isQuerying;

/**
 *  @return 返回数据的过期状态
 *  注意:
 1. 有效期:(requestSuccessed|requestFailured)中
 2. 在(requestSuccessed|requestFailured)之前设置值,以确保回调处理中正确使用
 3. 只有query操作才有可能会过期，refresh永不过期
 */
- (BOOL)expired;

/**
 *  判断当前数据是否与上一次请求的数据重复
 */
- (BOOL)repeated;

/**
 ** !!!慎用!!!
 ** 清除dp对应的缓存，使下次query强制刷新
 **/
- (void)clearCache;

/**
 *  从服务器刷新数据，异步请求,请求成功“不会刷新“数据库
 */
- (void)loadMore;

@end
