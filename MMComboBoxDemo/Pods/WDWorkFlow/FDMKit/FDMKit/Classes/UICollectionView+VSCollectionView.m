//
//  UICollectionView+VSCollectionView.m
//  VDMTest
//
//  Created by YaoMing on 2016/11/7.
//  Copyright © 2016年 YaoMing. All rights reserved.
//

#import "UICollectionView+VSCollectionView.h"
#import "VSDependencyManager.h"

@implementation UICollectionView (VSCollectionView)

-(void)setCollectionDelegate:(id)delegate
{
    [self setCollectionDelegate:delegate];
    if([[VSDependencyManager shareInstance] isManagerObject:delegate]){
        [[VSDependencyManager shareInstance] addObserver:delegate source:self];
    }
}

-(void)setCollectionDataSource:(id)datasoure
{
    [self setCollectionDataSource:datasoure];
    if([[VSDependencyManager shareInstance] isManagerObject:datasoure]){
        [[VSDependencyManager shareInstance] addObserver:datasoure source:self];
    }
}
@end
