//
//  UIPickerView+VSPickerView.m
//  test
//
//  Created by Xiang on 14-3-25.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import "UIPickerView+VSPickerView.h"
#import "VSDependencyManager.h"

@implementation UIPickerView(VSPickerView)

-(void)setPickerDelegate:(id)delegate{
    [self setPickerDelegate:delegate];
    if (delegate) {
        if([[VSDependencyManager shareInstance] isManagerObject:delegate]){
            [[VSDependencyManager shareInstance] addObserver:delegate source:self];
        }
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
}

//setDataSource
-(void)setPickerDataSource:(id)datasoure{
    [self setPickerDataSource:datasoure];
    if (datasoure) {
        if([[VSDependencyManager shareInstance] isManagerObject:datasoure]){
            [[VSDependencyManager shareInstance] addObserver:datasoure source:self];
        }
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
}

@end
