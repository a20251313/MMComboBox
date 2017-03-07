//
//  NSDate+BillMonthName.h
//  FFOneCard
//
//  Created by xuyan on 16/5/9.
//  Copyright © 2016年 shaofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BillMonthName)

/**
 根据某个UTC日期获取当前所在时区的日期

 @return NSDate
 */
-(NSDate *)localeDate;

/**
 显示本月

 @return NSString
 */
- (NSString *)billMonthName;

@end
