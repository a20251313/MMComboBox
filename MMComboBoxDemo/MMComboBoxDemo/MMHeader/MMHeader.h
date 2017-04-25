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
#import "NSArray+Safe.h"
#import "NSMutableArray+Safe.h"

#undef scale
#define scale [UIScreen mainScreen].scale

#define kMMScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kMMScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kMMLeftCellWidth  (kMMScreenWidth/2-40)
#define kMMMinShowRowNumer 5


#pragma mark
#pragma 定义给飞凡搜索用的参数key值，如果有增加参数或更改，请参照更改
#define kBusinessDisKey             @"busiDistrictId"  //商圈参数名
#define kDistanceKey                @"distance"     //距离参数名
#define kCountyIdKey               @"countyId"    //某个参数名
#define kSortKey                    @"sortField"         //排序参数名
#define kCategoryIdKey              @"categoryId"   //类目ID
#define kBrandIdKey                 @"brandId"      //品牌参数名
#define kSortTypeKey                @"sortType"     //排序类型
#define kStoreTypeKey               @"storeType"    //门店类型
#define kFloorKey                   @"floor"      //楼层参数名
#define kPriceKey                   @"price"      //价格参数名
#define kIconKey                    @"icon"       //活动及服务
#define kPlazaUtilityKey            @"plazaUtility"    //服务参数名
#define kPlazaTypeKey               @"plazaType"      //广场
#define kCinemaAreaKey              @"CinemaArea"        //影院区域
#define kCinemaBrandKey             @"CinemaBrand"       //影院品牌
#define kCinemaSortKey              @"CinemaSort"        //影院排序
#define kCinemaServiceKey           @"CinemaService"     //影院特色服务
#define kCinemaHallKey              @"CinemaHall"        //影院特色影厅

#undef Pixel24
#define Pixel24 [UIFont systemFontOfSize:12]
#undef Pixel30
#define Pixel30 [UIFont systemFontOfSize:17]

//颜色

#undef RGBColor//(r, g, b)
#undef RGBAColor//(r, g, b, a)
#undef RGBCodeColor
#undef RGBCodeAlphaColor

#define RGBColor(r, g, b) RGBAColor(r, g, b, 255)
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]  //a -> 0 ~ 255

#define RGBCodeColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]
#define RGBCodeAlphaColor(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a] // a -> 0 ~ 1

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

static const NSTimeInterval AnimationDuration= .35;
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
