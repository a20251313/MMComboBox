//
//  FFViewProtocol.h
//  FeiFan
//
//  Created by 李魁峰 on 15/5/27.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#ifndef FeiFan_FFViewProtocol_h
#define FeiFan_FFViewProtocol_h

#import <UIKit/UIKit.h>
@class SDKViewController;

@protocol FFViewModelProtocol <NSObject>

@required
@property (nonatomic, readonly) CGFloat viewHeight;

@optional
@property (nonatomic, readonly) CGFloat viewWidth;

- (Class)viewClass;

@end

@protocol FFViewProtocol <NSObject>

@required
+ (CGFloat)viewHeight:(id<FFViewModelProtocol>)viewModel;

@optional
- (void)setModel:(id<FFViewModelProtocol>)viewModel;
- (void)setDelegate:(id)delegate;
- (void)viewDidSelect;
+ (NSString *)reuseIdentifier;
+(CGFloat)viewWidth:(id<FFViewModelProtocol>)viewModel;

@property (nonatomic, weak) SDKViewController *controller;

@end


#endif
