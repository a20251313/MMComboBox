//
//  NSDate+BillMonthName.m
//  FFOneCard
//
//  Created by xuyan on 16/5/9.
//  Copyright © 2016年 shaofeng. All rights reserved.
//

#import "NSDate+BillMonthName.h"

@implementation NSDate (BillMonthName)

/**
 根据某个UTC日期获取当前所在时区的日期
 
 @return NSDate
 */
-(NSDate *)localeDate
{
    //time zone
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *localeDate = [self dateByAddingTimeInterval:interval];
    return localeDate;
}

/**
 显示本月
 
 @return NSString
 */
- (NSString *)billMonthName {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];//显示年月日
    
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    
    NSDate *currentDate = [NSDate date];
    comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:currentDate];//显示年月日
    
    NSInteger currentYear = [comps year];
    NSInteger currentMonth = [comps month];
    
    NSString *monthName;
    if(year == currentYear) {
        if (month == currentMonth)
            monthName = @"本月";
        else
            monthName = [NSString stringWithFormat:@"%zd月", month];
    } else {
        monthName = [NSString stringWithFormat:@"%zd年%zd月", year, month];
    }
    return monthName;
}
@end
