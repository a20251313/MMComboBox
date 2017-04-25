//
//  MMDropDownBox.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMDropDownBox.h"
#import "MMHeader.h"

@interface MMDropDownBox ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) MMPopupViewIconType iconType;
@property (nonatomic, strong) UIView *dotView;

@end

@implementation MMDropDownBox

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title withIcon:(MMPopupViewIconType)iconType {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.isSelected = NO;
        self.iconType = iconType;
        self.userInteractionEnabled = YES;
        //add recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapAction:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.top.bottom.left.right.mas_offset(0);
        }];
        [self addSubview:self.dotView];
        [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(3);
            make.right.mas_offset(-1);
            make.centerY.mas_equalTo(0);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_offset(0);
            make.height.mas_equalTo(2);
            
        }];
        
    }
    return self;

}


-(UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kICONFONT(DropDownBoxFontSize);
        _titleLabel.text = [self getTitleDesription];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
-(UIView*)dotView
{
    if (_dotView == nil) {
        UIColor *dotColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _dotView.layer.borderWidth = 1;
        _dotView.layer.masksToBounds = YES;
        _dotView.layer.cornerRadius = 2.5;
        _dotView.backgroundColor = dotColor;
        _dotView.layer.borderColor = dotColor.CGColor;
    }
    return _dotView;
}

-(UIView*)lineView
{
    if (_lineView == nil) {
        UIColor *lineColor = [UIColor colorWithRed:0x2a/255.0 green:0xbf/255.0 blue:0xff/255.0 alpha:1];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _lineView.backgroundColor = lineColor;
    }
    return _lineView;
}



- (NSString*)getTitleDesription
{
    NSString *iconString = nil;
    switch (self.iconType) {
        case MMPopupViewNoneIcon:
            break;
        case MMPopupViewSortIcon:
            iconString = kSortedIcon;
            break;
        case MMPopupViewFilterIcon:
            iconString = kFilterIcon;
            break;
        case MMPopupViewLocationIcon:
            iconString = kLocationIcon;
            break;
        case MMPopupViewTypeIcon:
            iconString = kTypeIcon;
            break;
        case MMPopupViewFloorIcon:
            iconString = kFloorIcon;
            break;
        default:
            break;
    }
    if (iconString) {
        return [NSString stringWithFormat:@"%@ %@",iconString,self.title];
    }
    return self.title;
}

- (void)setDotHide:(BOOL)dotHide
{
    self.dotView.hidden = dotHide;
}

- (void)setLineHide:(BOOL)dotHide
{
    self.lineView.hidden = dotHide;
}

- (void)updateTitleState:(BOOL)isSelected {
    if (isSelected) {
       // self.titleLabel.textColor = [UIColor ff_colorWithHexString:titleSelectedColor];
        //self.arrow.image = [UIImage imageNamed:@"pullup"];
    } else{
     //   self.titleLabel.textColor = [UIColor blackColor];
       // self.arrow.image = [UIImage imageNamed:@"pulldown"];
    }
}

- (void)updateTitleContent:(NSString *)title {
    
    self.title = title;
    self.titleLabel.text = [self getTitleDesription];
}

- (void)respondToTapAction:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
        [self.delegate didTapDropDownBox:self atIndex:self.tag];
    }
}
@end
