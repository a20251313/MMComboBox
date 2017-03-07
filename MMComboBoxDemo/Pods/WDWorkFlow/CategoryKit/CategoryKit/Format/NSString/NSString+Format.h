//
//  NSString+Format.h
//  CategoryKit
//
//  Created by xinpenghui on 16/12/5.
//  Copyright © 2016年 Wanda. All rights reserved.
//

#import <Foundation/Foundation.h>


//密码强度
typedef NS_ENUM(NSUInteger, PasswordStrength) {
    weakPassword,                                   //弱
    normalPassword,                                 //中
    strongPassword,                                 //强
};

@interface NSString (Format)

/*
 * Returns the MD5 value of the string
 */
- (NSString *)md5;

/*
 * Returns the SHA-1 value of the string
 */
- (NSString *)sha1;

/*
 * Returns the long value of the string
 */
- (long)longValue;

/**
 去除前置空格 例如 @"  12 34" 截取后@"12 34"

 @return NSString
 */
- (NSString *)trimWhiteSpace;

/**
 URL编码

 @return NSString
 */
- (NSString *)urlencode;

/**
 URl解码

 @return NSString
 */
- (NSString *)urldecode;

/**
 JSON解码

 @return <#return value description#>
 */
- (id)jsonValueDecoded;



/**
 去掉数字字符串小数点后面无用的0

 @return NSString
 */
- (NSString *)stringWithCustomPriceFormat;

/**
 判断密码强弱

 @return PasswordStrength
 */
- (PasswordStrength)isStrengthPwd;

/**
 剔除字符串中的分隔符 "-"

 @return NSString
 */
- (NSString *)stringToNumberString;

/**
 安全获取obj的内容 剔除(null)内容

 @param obj 内容

 @return NSString
 */
+ (NSString *)safeFormatString:(id)obj;
////////// 以下无用
#pragma mark - URL Types

/**
 腾讯支付URL type

 @return NSString
 */
+ (NSString *)stringTenPaySourceApplication;

/**
 阿里pay URL Type

 @return NSString
 */
+ (NSString *)stringAlixPaySourceApplication;

/**
 阿里pay URL Type
 
 @return NSString
 */
+ (NSString *)stringAlixPaySourceApplication2;

/**
 获取阿里pay URLScheme

 @return NSString
 */
+ (NSString *)stringAlixPayURLScheme;

/**
 获取阿里weixin URLScheme
 
 @return NSString
 */
+ (NSString *)stringWeiXinShareURLScheme;

/**
 获取新浪微博 URLScheme
 
 @return NSString
 */
+ (NSString *)stringSinaWeiBoShareURLScheme;
/**
 获取万汇网 URLScheme
 
 @return NSString
 */
+ (NSString *)stringWanHuiURLScheme;

#pragma mark - Const String

/**
 获取AppID

 @return NSString
 */
+ (NSString *)appID;

/**
 获取iTunes下载地址

 @return <#return value description#>
 */
+ (NSString *)itunesDownloadAddress;
////////// 以上无用

/**
 通过key值获取URL scheme

 @param keyworkd 关键字

 @return NSString
 */
+ (NSString *)stringURLSchemeWithKeyword:(NSString *)keyworkd;


// 使用NSArray作为参数格式化字符串
//+ (NSString *)stringWithFormat:(NSString *) format withArray:(NSArray *) valueArray;
@end
