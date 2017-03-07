//
//  FFDebugOptionManager.m
//  FeiFan
//
//  Created by fy on 16/2/2.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import "FFDebugOptionManager.h"
#import "SafeCategory.h"

#define kDebugOptionKeyNamed(keyName) [NSString stringWithFormat:@"DebugOptionKey_%@",keyName]
#define ModelSectionPath [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] mutableCopy] stringByAppendingPathComponent:@"ModelSectionArr.data"]

@interface FFDebugOptionManager ()

{
    NSArray <FFdebugOptionSectionModel *> * _modelSectionArr;
}

@end

@implementation FFDebugOptionManager


FF_DEF_SINGLETON(FFDebugOptionManager)


- (BOOL)isRelease
{
    NSString *gitBranchName  = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITBranch"];
    if ([gitBranchName isEqualToString:@"develop"]) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isOnline
{
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"DebugOptionKey_isOnline"];
    if (!obj) {
        return [self isRelease];
    }else{
         return [[[NSUserDefaults standardUserDefaults] objectForKey:@"DebugOptionKey_isOnline"] boolValue];
    }

}

- (NSNumber *)debugOptionValueForKey:(NSString *)keyName
{
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:kDebugOptionKeyNamed(keyName)];
    
    return value;
}

- (void)setDebugOptionValue:(NSNumber *)value forKey:(NSString *)keyName
{
    if (value && [value isKindOfClass:[NSNumber class]]) {
        NSString *key = kDebugOptionKeyNamed(keyName);
        if ([keyName isEqualToString:@"isOnline"]) {
            key = @"DebugOptionKey_isOnline";
        }else if([keyName isEqualToString:@"isCloseHTTPS"]){
            key = @"DebugOptionPrefix_isCloseHTTPS";
        }
        [[NSUserDefaults standardUserDefaults] safeSetObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:NKey_DebugOptionKeyValueChanged object:@{@"key":keyName,@"value":value}]; 
        
    }
}

- (NSArray<FFdebugOptionSectionModel *> *)modelSectionArr
{
    
//    if (!_modelSectionArr) {
//        _modelSectionArr = [NSKeyedUnarchiver unarchiveObjectWithFile:ModelSectionPath];
//        
//        return _modelSectionArr ? _modelSectionArr : nil;
//    }
//    else
//    {
//        return _modelSectionArr;
//    }
    return nil;
}

- (void)setModelSectionArr:(NSArray<FFdebugOptionSectionModel *> *)modelSectionArr
{
    _modelSectionArr = modelSectionArr;
    
    [[NSFileManager defaultManager] removeItemAtPath:ModelSectionPath error:nil];
    [NSKeyedArchiver archiveRootObject:modelSectionArr toFile:ModelSectionPath];
}



@end
