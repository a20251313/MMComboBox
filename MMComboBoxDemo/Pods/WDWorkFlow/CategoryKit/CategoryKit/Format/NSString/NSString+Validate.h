//
//  NSString+Validate.h
//  CategoryKit
//
//  Created by xinpenghui on 16/12/6.
//  Copyright © 2016年 Wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

/**
 *  Determines if string is not contains only whitespace and newlines
 */
- (BOOL)isNotEmpty;

/**
 *  trim whitespaces and newlines
 */
- (NSString *)trimWhiteCharacters;

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmptyOrWhitespace;

/*
 * Checks to see if the string contains the given string, case insenstive
 */
- (BOOL)containsString:(NSString *)string;

/*
 * Checks to see if the string contains the given string while allowing you to define the compare options
 */
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;

/**
 校验字符串是否为手机号码
 
 @return BOOL
 */
- (BOOL)isMobileNumber;

/**
 校验身份证信息

 @return BOOL
 */
- (BOOL)isIDCardNumber;

/**
 校验是否可以拨电话

 @return BOOL
 */
- (BOOL)canTel;

/**
 校验是否为数字

 @return BOOL
 */
- (BOOL)isNumber;

@end
