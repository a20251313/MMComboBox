//
//  FFWeakify.h
//  FeiFan
//
//  Created by 李魁峰 on 16/1/6.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#ifndef FFWeakify_h
#define FFWeakify_h


/**
 Synthsize a weak or strong reference.
 
 Example:
 weakObj(self)
 [self doSomething^{
 strongObj(self)
 ...
 }];
 
 */
#ifndef weakObj
    #if __has_feature(objc_arc)
        #define weakObj(object)  __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakObj(object)  __block __typeof__(object) block##_##object = object;
    #endif
#endif

#ifndef strongObj
    #if __has_feature(objc_arc)
        #define strongObj(object)  __typeof__(object) object = weak##_##object; if(!object) return;
    #else
        #define strongObj(object)  __typeof__(object) object = block##_##object; if(!object) return;
    #endif
#endif

#endif /* FFWeakify_h */
