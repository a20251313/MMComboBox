//
//  FFTestLogCell.h
//  FeiFan
//
//  Created by fy on 15/12/18.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFViewProtocol.h"


@interface FFTestLogCell : UITableViewCell <FFViewProtocol>

@property (nonatomic, weak) id delegate;

@end

@interface FFTestLogCellModel : NSObject <FFViewModelProtocol>

@property (nonatomic, copy) NSString *string;

@end
