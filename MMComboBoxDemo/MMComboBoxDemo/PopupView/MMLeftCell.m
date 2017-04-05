//
//  MMLeftCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/12.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMLeftCell.h"
#import "MMHeader.h"

@interface MMLeftCell ()

@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation MMLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.infoLabel];
       // [self.layer addSublayer:self.bottomLine];
    }
    return self;
}

- (void)setItem:(MMItem *)item {
    _item = item;
    self.infoLabel.text = item.title;
    self.backgroundColor = item.isSelected?[UIColor ff_colorWithHex:0xffffff]:[UIColor ff_colorWithHex:0xe6e6e6];
    self.infoLabel.textColor = item.isSelected?[UIColor ff_colorWithHex:0x000000]:[UIColor ff_colorWithHex:0x333333];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.infoLabel.frame = CGRectMake(LeftCellHorizontalMargin, 0, self.ff_width - 2 *LeftCellHorizontalMargin, self.ff_height);
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = Pixel24;
    }
    return _infoLabel;
}

+ (CGFloat)leftCellHeight:(MMItem*)item
{
    return 44;
}
@end
