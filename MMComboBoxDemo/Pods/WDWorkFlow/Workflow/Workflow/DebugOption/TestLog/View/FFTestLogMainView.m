//
//  FFTestLogMainView.m
//  FeiFan
//
//  Created by fy on 15/12/16.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFTestLogMainView.h"
#import "FFTestLogManager.h"
#import "FFTestLogCell.h"
#import "FFDebugOptionViewController.h"
#import "FFDebugOptionManager.h"
#import "SDKNavigationController.h"
#import "SafeCategory.h"

@interface FFTestLogMainView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, strong) NSMutableArray *cellModels;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) CGRect smallRect;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *cookieBtn;

@end

@implementation FFTestLogMainView
- (IBAction)settingAction:(id)sender {
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIWindow *mainWindow;

    if (keyWindow == self.window) {
        mainWindow = [windows objectAtIndex:0];
    }
    else
    {
        mainWindow = keyWindow;
    }
    UIViewController *visibleVc;
    
    UIViewController *rootVC = mainWindow.rootViewController;
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        visibleVc = [(UINavigationController *)rootVC visibleViewController];
    }
    else
    {
        visibleVc = rootVC;
    }

    
    if ([visibleVc isKindOfClass:[FFDebugOptionViewController class]]) {
        return;
    }
    else
    {
        
        FFDebugOptionViewController *debugVc = [[FFDebugOptionViewController alloc] initWithNibName:nil bundle:nil];
        debugVc.openType = EViewControllerOpenMethodPresent;
        debugVc.modelSectionArr = [FFDebugOptionManager sharedInstance].modelSectionArr;
        debugVc.isJumpAnimate = YES;
        
        SDKNavigationController *nav = [[SDKNavigationController alloc]initWithRootViewController:debugVc];
        [visibleVc presentViewController:nav animated:YES completion:nil];
    }
}
- (IBAction)cleanAction:(id)sender {
    [[FFTestLogManager sharedInstance] clean];
    [self reloadData];
    [self.tableView scrollsToTop];
    
}

- (IBAction)closeAction:(id)sender {
    
    [[FFTestLogManager sharedInstance]closeLogOnScreen];
}
- (IBAction)cookieAction:(id)sender {
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *array = [cookieStorage cookies];
    NSLog(@"cookies:%@",array);
}

- (IBAction)zoomAction:(id)sender {
    
    if (self.isFullScreen) {
        self.frame = self.smallRect;
        self.isFullScreen = NO;
    }
    else
    {
        self.smallRect = self.frame;
        self.frame = self.superview.bounds;
        self.isFullScreen = YES;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self reloadData];
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.alpha = 0.7;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FFTestLogCell class]) bundle:nil] forCellReuseIdentifier:[FFTestLogCell reuseIdentifier]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addANewLog) name:@"NotificationGetANewLog" object:nil];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBtnPan:)];
    [self.headerView addGestureRecognizer:pan];
    
    self.cookieBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cookieBtn.layer.borderWidth = 0.7f;
    self.cookieBtn.layer.cornerRadius = 3;
    self.isFullScreen = NO;
    
}

- (void)addANewLog
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        
        if (self.cellModels.count > 0)
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:self.cellModels.count -1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

    });
}

- (void)reloadData
{
    self.cellModels = [NSMutableArray array];
    
    @synchronized(self)
    {
        if ([FFTestLogManager sharedInstance].logArray.count > 0) {
            for (int i = 0; i < [FFTestLogManager sharedInstance].logArray.count; i ++) {
                FFTestLogCellModel *cellModel = [[FFTestLogCellModel alloc] init];
                cellModel.string = [[FFTestLogManager sharedInstance].logArray safeObjectAtIndex:i];
                [self.cellModels safeAddObject:cellModel];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)moveBtnPan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.startY = self.frame.origin.y;
    }
    else
    {
        CGFloat moveY = [pan translationInView:self].y;
        
        CGRect frame = self.frame;
        
        if (self.startY + moveY < 0 ) {
            
            frame.origin.y = 0;
        }
        else if (self.startY + frame.size.height + moveY > self.superview.frame.size.height)
        {
            frame.origin.y = self.superview.frame.size.height - self.frame.size.height;
        }
        else
        {
            frame.origin.y = self.startY + moveY;
        }
        self.frame = frame;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <FFViewModelProtocol> cellModel = [self.cellModels safeObjectAtIndex:indexPath.row];
    
    UITableViewCell <FFViewProtocol> *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([cellModel viewClass]) forIndexPath:indexPath];
    
    [cell setDelegate:self];
    [cell setModel:cellModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <FFViewModelProtocol> viewModel = [self.cellModels safeObjectAtIndex:indexPath.row];
    
    return [viewModel viewHeight];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    return view;
}

@end
