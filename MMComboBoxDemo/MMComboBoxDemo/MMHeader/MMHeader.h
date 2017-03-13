//
//  MMHeader.h
//  MMPhotoView
//
//  Created by wyy on 16/11/10.
//  Copyright © 2016年 yyx. All rights reserved.
//

#ifndef MMHeader_h
#define MMHeader_h
#import "UIView+FFUIFactory.h"
#import "UIColor+FFUIFactory.h"
#import "Masonry.h"
#import "FFIconFontDefine.h"

#define scale [UIScreen mainScreen].scale
#define kMMScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kMMScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kMMLeftCellWidth  (kMMScreenWidth/2-40)
#define kMMMinShowRowNumer 1



#define kBusinessDisKey             @"businessDis"  //商圈参数名
#define kDistanceKey             @"distance"     //距离参数名
#define kSortKey                    @"sort"         //排序参数名
#define kCategoryIdKey              @"categoryId"   //类目ID
#define kBrandIdKey                 @"brandId"      //品牌参数名
#define kStoreTypeKey               @"storeType"    //门店类型
#define kFloorKey                   @"floor"      //楼层参数名
#define kPriceKey                   @"price"      //价格参数名




static  NSString *titleSelectedColor = @"4EBC72";
static const CGFloat  ButtonFontSize = 14.0f;
//MMPopupView

static const CGFloat DistanceBeteewnTopMargin =  64+20;
static const CGFloat DistanceBeteewnPopupViewAndBottom =80.0f;
static const CGFloat PopupViewTabBarHeight = 50.0f;
static const CGFloat LeftCellHorizontalMargin = 15.0f;

static const CGFloat ShadowAlpha = .5;
//static const CGFloat
static  NSString *MainCellID = @"MainCellID";
static  NSString *SubCellID = @"SubCellID";
static const NSTimeInterval AnimationDuration= .25;
static const CGFloat ButtonHorizontalMargin = 15;

/* fontSize*/
static const CGFloat SubTitleFontSize = 15.0f;


//MMCombinationFitlerView
static const CGFloat AlternativeTitleVerticalMargin = 10.0f;
static const CGFloat AlternativeTitleHeight = 31.0f;
static const CGFloat TitleVerticalMargin = 10.0f;
static const CGFloat TitleHeight  = 20.0f;
static const CGFloat ItemHeight  = 30.0f;
static const CGFloat ItemWidth  = 80.0f;
static const CGFloat ItemHorizontalMargin = 15.0f;
static const CGFloat ItemHorizontalDistance = 15.0f;

//MMDropDownBox
static const CGFloat DropDownBoxFontSize = 12.0f;
#endif /* MMHeader_h */
