//
//  UITableView+VSTableView.m
//  test
//
//  Created by Xiang on 14-3-24.
//  Copyright (c) 2014年 Vip. All rights reserved.
//

#import "UITableView+VSTableView.h"
#import "VSDependencyManager.h"

@implementation UITableView(VSTableView)

//setDelegate
-(void)setTableDelegate:(id)delegate{
    [self setTableDelegate:delegate];
    if([[VSDependencyManager shareInstance] isManagerObject:delegate]){
        [[VSDependencyManager shareInstance] addObserver:delegate source:self];
    }
}

//setDataSource
-(void)setTableDataSource:(id)datasoure{
    [self setTableDataSource:datasoure];
    if([[VSDependencyManager shareInstance] isManagerObject:datasoure]){
        [[VSDependencyManager shareInstance] addObserver:datasoure source:self];

    }
}

@end
