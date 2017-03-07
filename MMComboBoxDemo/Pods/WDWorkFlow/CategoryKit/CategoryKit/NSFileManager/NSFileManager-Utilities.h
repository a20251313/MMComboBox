/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 Modified by Peter Steinberger
 */

#import <UIKit/UIKit.h>

// Path utilities
NSString *NSDocumentsFolder(void);
NSString *FFCacheFolder(void);
NSString *NSLibraryFolder(void);
NSString *NSBundleFolder(void);

@interface NSFileManager (Utilities)

/**
 文件防止备份的iCloud

 @param URL 文件路径

 @return BOOL
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end

