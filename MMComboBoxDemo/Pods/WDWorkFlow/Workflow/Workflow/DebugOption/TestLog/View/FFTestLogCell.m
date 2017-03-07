//
//  FFTestLogCell.m
//  FeiFan
//
//  Created by fy on 15/12/18.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFTestLogCell.h"
#import "FFTestLogMainView.h"

@interface FFTestLogCell()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation FFTestLogCell

#define kDefaultWindowWidth [UIScreen mainScreen].bounds.size.width
#define kDefaultWindowHeight [UIScreen mainScreen].bounds.size.height

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.font = LogFont;
    self.backgroundColor = [UIColor clearColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

+ (CGFloat)viewHeight:(FFTestLogCellModel *)viewModel;
{
    NSString *str = viewModel.string;
    
    NSDictionary *attri = @{NSFontAttributeName:LogFont};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(kDefaultWindowWidth - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attri context:nil].size;
    
    return size.height + 20;
}

- (void)setModel:(FFTestLogCellModel *)viewModel
{
    _textView.text = viewModel.string;
}

- (void)setDelegate:(id)delegate
{
    _delegate = self;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([FFTestLogCell class]);
}

@end

@implementation FFTestLogCellModel

- (Class)viewClass
{
    return [FFTestLogCell class];
}

- (CGFloat)viewHeight
{
    return [FFTestLogCell viewHeight:self];
}

@end
