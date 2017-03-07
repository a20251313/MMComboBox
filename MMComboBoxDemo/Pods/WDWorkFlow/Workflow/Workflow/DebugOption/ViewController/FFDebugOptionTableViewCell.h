//
//  FFConfigurateTestEnvironmentCellTableViewCell.h
//  FeiFan
//
//  Created by xianglinlin on 15/11/6.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFViewProtocol.h"

@interface FFDebugOptionCellModel : NSObject<FFViewModelProtocol>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSNumber *defaultValue;
@property (nonatomic) BOOL isOn;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithTitle:(NSString *)title defaltValue:(NSNumber *)defaultValue;
- (void)refreshValue;

@end

@protocol FFDebugOptionCellDelegate <NSObject>

- (void)changeSwitchStatus:(BOOL)isOn atIndexPath:(NSIndexPath *)indexPath;

@end

@interface FFDebugOptionTableViewCell : UITableViewCell<FFViewProtocol>

@property (nonatomic, weak) id<FFDebugOptionCellDelegate> delegate;

- (void)setModel:(id<FFViewModelProtocol>)viewModel;

@end
