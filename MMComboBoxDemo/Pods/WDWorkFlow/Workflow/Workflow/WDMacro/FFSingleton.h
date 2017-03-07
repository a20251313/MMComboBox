//
//  FFSingleton.h
//  FeiFan
//
//  Created by 李魁峰 on 15/11/2.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#ifndef FFSingleton_h
#define FFSingleton_h

/**
 *  单例函数声明
 *
 *  @param __class ClassName
 */
#undef  FF_AS_SINGLETON
    #define FF_AS_SINGLETON( __class ) \
    + (__class *)sharedInstance;


/**
 *  单例函数实现
 *
 *  @param __class ClassName
 */
#undef  FF_DEF_SINGLETON
#define FF_DEF_SINGLETON( __class ) \
    + (__class *)sharedInstance \
    { \
        static id __singleton__ = nil; \
        @synchronized(self) { \
            if (!__singleton__) { \
                __singleton__ = [[self alloc] init]; \
            } \
        } \
        return __singleton__; \
    }

#endif /* FFSingleton_h */

