//
//  FFSecurityManager.m
//  Pods
//
//  Created by dash on 2016/10/25.
//
//

#import "FFMonitorManager.h"

#import "FFWildPointerChecker.h"
#import "CrashReporter.h"
#import "PerformanceMonitor.h"

@implementation FFMonitorManager

+ (void)wildPointerCheckStart
{
    startWildPointerCheck();
    
    NSLog(@"startWildPointerCheck-----------------------");
}

+ (void)wildPointerCheckStop
{
    stopWildPointerCheck();
}

+ (NSString *)outputCurrentStackInfo
{
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                              withTextFormat:PLCrashReportTextFormatiOS];
    NSLog(@"-------------------当前栈信息为--------------------------------\n");
    NSLog(@"%@",report);
    NSLog(@"---------------------------------------------------");
    return report;
}

+ (void)performanceMonitorStart
{
    [[PerformanceMonitor sharedInstance] start];
}
    
+ (void)performanceMonitorStop
{
    [[PerformanceMonitor sharedInstance] stop];
}

@end
