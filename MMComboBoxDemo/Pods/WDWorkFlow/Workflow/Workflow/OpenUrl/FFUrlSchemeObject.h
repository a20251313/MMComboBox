//
//  FFUrlSchemeObject.h
//  FeiFan
//
//  Created by lihui on 15/10/13.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUrlSchemeObject : NSObject

@property (nonatomic, strong) NSString *publicURL;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *storyboardFileName;
@property (nonatomic, strong) NSString *viewControllerName;
@property (nonatomic, strong) NSArray <NSString *> *requireParameters;
@property (nonatomic, strong) NSArray <NSString *> *optionalParameters;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *tagInfo;
@property (nonatomic, strong) NSString *creater;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
