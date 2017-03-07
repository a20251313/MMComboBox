//
//  NSString+Validate.m
//  CategoryKit
//
//  Created by xinpenghui on 16/12/6.
//  Copyright © 2016年 Wanda. All rights reserved.
//

#import "NSString+Validate.h"
#import <UIKit/UIKit.h>

@implementation NSString (Validate)
/**
 *  Determines if string is not contains only whitespace and newlines
 */
- (BOOL)isNotEmpty
{
    NSString *trimmed = [self trimWhiteCharacters];
    return trimmed.length > 0;
}
/**
 *  trim whitespaces and newlines
 */
- (NSString *)trimWhiteCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
/**
 * Determines if the string contains only whitespace and newlines.
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

/**
 * Determines if the string is empty or contains only whitespace.
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmptyOrWhitespace {
    return !self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

/*
 * Checks to see if the string contains the given string, case insenstive
 */
- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:NSCaseInsensitiveSearch];
}
/*
 * Checks to see if the string contains the given string while allowing you to define the compare options
 */
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
    return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

/**
 校验字符串是否为手机号码

 @return BOOL
 */
- (BOOL)isMobileNumber
{
    if (!self || self.length <= 0) {
        return NO;
    }
    
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
/**
 校验身份证信息
 
 @return BOOL
 */
- (BOOL)isIDCardNumber
{
    if (!self || self.length <= 0) {
        return NO;
    }
    
    NSString *cardRegex = @"[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:self];
}
/**
 校验是否可以拨电话
 
 @return BOOL
 */
- (BOOL)canTel
{
    if (!self || self.length <= 0) {
        return NO;
    }
//    telStr = [telStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *telStr = [self trimWhiteCharacters];
    telStr = [telStr stringByReplacingOccurrencesOfString:@"转" withString:@","];
    if (!(telStr && telStr.length)) {
        return NO;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",telStr]]] == YES) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",telStr]]];
        return YES;
    }
    return NO;
}
/**
 校验是否为数字
 
 @return BOOL
 */
- (BOOL)isNumber
{
    if (!self || self.length <= 0) {
        return NO;
    }
    
    NSString * regex = @"^[1-9]\\d*|0$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
