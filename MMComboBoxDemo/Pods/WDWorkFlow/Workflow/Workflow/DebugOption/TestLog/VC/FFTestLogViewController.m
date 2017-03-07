//
//  FFTestLogViewController.m
//  FeiFan
//
//  Created by fy on 15/12/16.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFTestLogViewController.h"
#import "FFTestLogManager.h"
#import "FFTestLogMainView.h"

@interface FFTestLogViewController ()

@property (nonatomic, weak) FFTestLogManager *manager;
@property (nonatomic, weak) FFTestLogMainView *mainView;
@property (nonatomic, assign) BOOL isFistLayout;
@end

@implementation FFTestLogViewController

#define kDefaultWindowWidth [UIScreen mainScreen].bounds.size.width
#define kDefaultWindowHeight [UIScreen mainScreen].bounds.size.height

#define MainViewMargin 10.0f
#define MainViewSaleToWindowHeight 0.333

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFistLayout = YES;
    [self addMainView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.isFistLayout) {
        
        self.mainView.frame = CGRectMake(MainViewMargin, 66, kDefaultWindowWidth - 2 * MainViewMargin, kDefaultWindowHeight * MainViewSaleToWindowHeight);
        self.mainView.layer.cornerRadius = 5;
        self.mainView.clipsToBounds = YES;
        self.mainView.backgroundColor = [UIColor clearColor];
        self.isFistLayout = NO;
    }
    
    [self.view layoutSubviews];
}

- (void)addMainView
{
    FFTestLogMainView *mainView = (FFTestLogMainView *)[[[UINib nibWithNibName:@"FFTestLogMainView" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    [self.view addSubview:mainView];
    self.mainView = mainView;
}


@end
