//
//  FFConfigurateTestEnvironmentViewController.m
//  FeiFan
//
//  Created by xianglinlin on 15/11/8.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFDebugOptionViewController.h"
#import "FFTestLogManager.h"
#import "FFDebugOptionManager.h"
#import "SafeCategory.h"
#import "FFUIFactory.h"

@interface FFDebugOptionViewController ()<UITableViewDataSource, UITableViewDelegate, FFDebugOptionCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UILabel *buildInfoLabel;
@property (nonatomic, strong) NSArray<NSString *> *sectionTitleArray;

@property (nonatomic, strong) NSMutableArray<NSArray<NSDictionary *> *> *sectionRowArray;

@end

@implementation FFDebugOptionViewController

FF_DEF_SINGLETON(FFDebugOptionViewController);

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"飞凡调试选项";
    
    UIImage *closeImg = [UIImage imageNamed:@"common_nav_close"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, closeImg.size.width, closeImg.size.height)];
    [backBtn setImage:closeImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
//    if (![FFDebugOptionManager sharedInstance].modelSectionArr) {
//        [FFDebugOptionManager sharedInstance].modelSectionArr = self.modelSectionArr;
//    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DebugOptionNeedChangeWithKeyValue:) name:NKey_DebugOptionKeyValueChanged object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FFDebugOptionTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:[[FFDebugOptionTableViewCell class] reuseIdentifier]];
    self.tableView.tableFooterView = self.buildInfoLabel;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    

- (void)DebugOptionNeedChangeWithKeyValue:(NSNotification *)notify
{
    [self reloadData];
}

- (void)reloadData
{
    NSMutableArray *tmpSectionTitleArr = [NSMutableArray array];
    NSMutableArray *tmpSectionRowArr = [NSMutableArray array];
    for (FFdebugOptionSectionModel *section in self.modelSectionArr) {
        
        
        [tmpSectionTitleArr safeAddObject:section.sectionTitle];
        
        
        if (section.sectionRows && section.sectionRows.count > 0) {
            for (int i = 0; i < section.sectionRows.count ; i++) {
                
                FFDebugOptionCellModel *cellModel = [section.sectionRows safeObjectAtIndex:i];
                [cellModel refreshValue];
                
            }
        }
        
        [tmpSectionRowArr safeAddObject:section.sectionRows];
        
    }
    self.sectionTitleArray = tmpSectionTitleArr;
    self.sectionRowArray = tmpSectionRowArr;

    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)[self.sectionRowArray safeObjectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44.0;
    }
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *key = [self.sectionTitleArray safeObjectAtIndex:section];
    
    float y_start = 0.0;
    if (section == 0) {
        y_start = 15.0;
    }
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, y_start, 310.0, 25.0)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.frame = CGRectMake(10.0, y_start, 310.0, 25.0);
    headerLabel.text = key;
    [customView addSubview:headerLabel];
    
    return customView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFDebugOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FFDebugOptionTableViewCell class])
                                                                                          forIndexPath:indexPath];
    
    [cell setDelegate:self];
    NSArray* session =  [self.sectionRowArray safeObjectAtIndex:indexPath.section];
    FFDebugOptionCellModel *cellModel = [session safeObjectAtIndex:indexPath.row];
    cellModel.indexPath = indexPath;
    [cell setModel:cellModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)changeSwitchStatus:(BOOL)isOn atIndexPath:(NSIndexPath *)indexPath
{
    NSArray* session =  [self.sectionRowArray safeObjectAtIndex:indexPath.section];
    FFDebugOptionCellModel *cellModel = [session safeObjectAtIndex:indexPath.row];
    
    [[FFDebugOptionManager sharedInstance] setDebugOptionValue:[NSNumber numberWithBool:isOn] forKey:cellModel.title];
}
    
    
- (UILabel *)buildInfoLabel{
    if (_buildInfoLabel == nil) {
        _buildInfoLabel = [UILabel ff_labelWithWidth:[[UIScreen mainScreen] bounds].size.width font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] backgroudColor:[UIColor clearColor] alignment:NSTextAlignmentCenter numberOfLines:0];
        _buildInfoLabel.ff_height = 100;
        NSString *gitBranchName  = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITBranch"];
        NSString *gitCommitCount = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITCommitCount"];
        NSString *gitRevSha      = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITHash"];
        NSString *gitCommitDate  = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITDate"];
        NSString *buildNumber    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        
        _buildInfoLabel.text = [NSString stringWithFormat:@"gitBranchName:%@ \n gitCommitCount:%@ \n gitRevSha:%@ \n gitCommitDate:%@ \n buildNumber:%@",gitBranchName,gitCommitCount,gitRevSha,gitCommitDate,buildNumber];
    }
    return _buildInfoLabel;
}
@end

@implementation FFdebugOptionSectionModel

- (instancetype)initWithTitle:(NSString *)title rows:(NSArray *)rows
{
    NSMutableArray *tmpRowsAndValues = [NSMutableArray array];
    for (NSString *title in rows) {
        [tmpRowsAndValues safeAddObject:@{title:@(0)}];
    }
    
    return [self initWithTitle:title rowsAndDefaultValues:[NSArray arrayWithArray:tmpRowsAndValues]];
}

- (instancetype)initWithTitle:(NSString *)title rowsAndDefaultValues:(NSArray<NSDictionary *> *)rowsAndDefaultValues
{
    if (self = [super init]) {
        self.sectionTitle = title;
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        
        for (NSDictionary *row in rowsAndDefaultValues) {
            NSString *title = (NSString *)row.allKeys.firstObject;
            NSNumber *defaultValue = (NSNumber *)row.allValues.firstObject;
            FFDebugOptionCellModel *cellModel = [[FFDebugOptionCellModel alloc] initWithTitle:title defaltValue:defaultValue];
            [tmpArr safeAddObject:cellModel];
        }
        
        self.sectionRows = [NSArray arrayWithArray:tmpArr];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_sectionTitle forKey:@"title"];
    [coder encodeObject:_sectionRows forKey:@"rows"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.sectionTitle = [decoder decodeObjectForKey:@"title"];
        self.sectionRows = [decoder decodeObjectForKey:@"rows"];
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    FFdebugOptionSectionModel *model = [[[self class] allocWithZone:zone]init];
    
    model.sectionTitle = [self.sectionTitle copyWithZone:zone];
    model.sectionRows = [self.sectionRows copyWithZone:zone];

    return model;
}
@end
