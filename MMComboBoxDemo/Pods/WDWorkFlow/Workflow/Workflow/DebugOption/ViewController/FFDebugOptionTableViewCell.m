//
//  FFConfigurateTestEnvironmentCellTableViewCell.m
//  FeiFan
//
//  Created by xianglinlin on 15/11/6.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFDebugOptionTableViewCell.h"
#import "FFDebugOptionManager.h"

@implementation FFDebugOptionCellModel

- (instancetype)initWithTitle:(NSString *)title defaltValue:(NSNumber *)defaultValue
{
    if (self = [super init]) {
        self.title = title;
        self.defaultValue = defaultValue;
        
        NSNumber *localValue = [[FFDebugOptionManager sharedInstance] debugOptionValueForKey:title];
        self.isOn =  localValue ? localValue.boolValue : defaultValue.boolValue;
    }
    
    return self;
}

- (CGFloat)viewHeight
{
    return [[FFDebugOptionTableViewCell class] viewHeight:self];
}

- (Class)viewClass
{
    return [FFDebugOptionTableViewCell class];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_defaultValue forKey:@"defaultValue"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.defaultValue = [decoder decodeObjectForKey:@"defaultValue"];
        NSNumber *localValue = [[FFDebugOptionManager sharedInstance] debugOptionValueForKey:self.title];
        self.isOn =  localValue ? localValue.boolValue : self.defaultValue.boolValue;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    FFDebugOptionCellModel *model = [[[self class] allocWithZone:zone]init];
    
    model.title = [self.title copyWithZone:zone];
    model.defaultValue = [self.defaultValue copyWithZone:zone];
    NSNumber *localValue = [[FFDebugOptionManager sharedInstance] debugOptionValueForKey:model.title];
    model.isOn =  localValue ? localValue.boolValue : model.defaultValue.boolValue;
    
    return model;
}

- (void)refreshValue
{
    
    NSNumber *localValue = [[FFDebugOptionManager sharedInstance] debugOptionValueForKey:self.title];
    if ([self.title isEqualToString:@"isOnline"]) {
        self.isOn = [[FFDebugOptionManager sharedInstance] isOnline];
    }
    else if([self.title isEqualToString:@"isCloseHTTPS"]) {
        self.isOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DebugOptionPrefix_isCloseHTTPS"] boolValue];
    }
    else {
        self.isOn =  localValue ? localValue.boolValue : self.defaultValue.boolValue;
    }
    
}

@end

@interface FFDebugOptionTableViewCell()
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UISwitch *logSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FFDebugOptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [self.logSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchValueChange:(UISwitch *)switchSender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSwitchStatus:atIndexPath:)]) {
        [self.delegate changeSwitchStatus:switchSender.on atIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDelegate:(id<FFDebugOptionCellDelegate>)delegate
{
    if (_delegate == nil) {
        _delegate = delegate;
    }
}

- (void)setModel:(id<FFViewModelProtocol>)viewModel
{
    FFDebugOptionCellModel *model = (FFDebugOptionCellModel *)viewModel;
    self.titleLabel.text = model.title;
    self.indexPath = model.indexPath;
    self.logSwitch.on = model.isOn;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([FFDebugOptionTableViewCell class]);
}

+ (CGFloat)viewHeight:(id<FFViewModelProtocol>)viewModel
{
    return 44;
}

@end
