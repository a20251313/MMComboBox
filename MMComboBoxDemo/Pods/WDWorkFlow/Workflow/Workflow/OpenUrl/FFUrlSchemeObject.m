//
//  FFUrlSchemeObject.m
//  FeiFan
//
//  Created by lihui on 15/10/13.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFUrlSchemeObject.h"
#import "SafeCategory.h"

@implementation FFUrlSchemeObject

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if (dic) {
            self.publicURL = [NSString safeStringFromObject:dic[@"publicURL"]];
            self.tag = [NSString safeStringFromObject:dic[@"tagName"]];
            self.storyboardFileName = [NSString safeStringFromObject:dic[@"storyboardFileName"]];
            self.viewControllerName = [NSString safeStringFromObject:dic[@"viewControllerName"]];
            NSString *parameters = [NSString safeStringFromObject:dic[@"requiredParameters"]];
            self.requireParameters =  parameters.length > 0 ? [parameters componentsSeparatedByString:@","] : [NSArray array];
            parameters = [NSString safeStringFromObject:dic[@"optionalParameters"]];
            self.optionalParameters = parameters.length > 0 ? [parameters componentsSeparatedByString:@","] : [NSArray array];
            self.version = [NSString safeStringFromObject:dic[@"version"]];
            self.tagInfo = [NSString safeStringFromObject:dic[@"tagInfo"]];
            self.creater = [NSString safeStringFromObject:dic[@"creater"]];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, \ntag: %@\nviewControllerName:%@\nversion:%@\ncreater:%@\nrequiredParameters:%@\noptionalParameters:%@\ntagInfo:%@", [super description], self.tag, self.viewControllerName, self.version, self.creater, self.requireParameters, self.optionalParameters, self.tagInfo];
}

@end
