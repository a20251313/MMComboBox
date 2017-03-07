//
//  FFDebugOptionViewController
//  FeiFan
//
//  Created by xianglinlin on 15/11/8.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//


#import "FFDebugOptionTableViewCell.h"
#import "SDKViewController.h"
#import "FFSingleton.h"

@class FFdebugOptionSectionModel;
@interface FFDebugOptionViewController : SDKViewController

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, strong) NSArray <FFdebugOptionSectionModel *> *modelSectionArr;

FF_AS_SINGLETON(FFDebugOptionViewController);

@end


@interface FFdebugOptionSectionModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, strong) NSArray <NSString *> *sectionRows;

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)rows;
- (instancetype)initWithTitle:(NSString *)title rowsAndDefaultValues:(NSArray<NSDictionary *> *)rowsAndDefaultValues;

@end


