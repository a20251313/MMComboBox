//
//  NSInvocation+utility.h
//  XUtility
//
//  Created by go886 on 15/1/21.
//  Copyright (c) 2015年 go886. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (utility)
-(void)argFromvalist:(va_list)valist beginIndex:(NSInteger)index;
@end
