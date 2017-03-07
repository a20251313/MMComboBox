//
//  CLLocation+YCLocation.h
//  YCMapViewDemo
//
//  Created by gongliang on 13-9-16.
//  Copyright (c) 2013年 gongliang. All rights reserved.
//  火星坐标系转换扩展
/*
 从 CLLocationManager 取出来的经纬度放到 mapView 上显示，是错误的!
 从 CLLocationManager 取出来的经纬度去 Google Maps API 做逆地址解析，当然是错的！
 从 MKMapView 取出来的经纬度去 Google Maps API 做逆地址解析终于对了。去百度地图API做逆地址解析，依旧是错的！
 从上面两处取的经纬度放到百度地图上显示都是错的！错的！的！
 
 分为 地球坐标，火星坐标（iOS mapView 高德 ， 国内google ,搜搜、阿里云 都是火星坐标），百度坐标(百度地图数据主要都是四维图新提供的)
 
 火星坐标: MKMapView
 地球坐标: CLLocationManager
 
 当用到CLLocationManager 得到的数据转化为火星坐标, MKMapView不用处理
 
 
 API                坐标系
 百度地图API         百度坐标
 腾讯搜搜地图API      火星坐标
 搜狐搜狗地图API      搜狗坐标
 阿里云地图API       火星坐标
 图吧MapBar地图API   图吧坐标
 高德MapABC地图API   火星坐标
 灵图51ditu地图API   火星坐标
 
 */

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (YCLocation)


/**
 从地图坐标转化到火星坐标

 @return CLLocation
 */
- (CLLocation*)locationMarsFromEarth;


/**
 从火星坐标转化到百度坐标

 @return CLLocation
 */
- (CLLocation*)locationBaiduFromMars;

/**
 从百度坐标到火星坐标

 @return CLLocation
 */
- (CLLocation*)locationMarsFromBaidu;

//从火星坐标到地图坐标
//- (CLLocation*)locationEarthFromMars; // 未实现

/**
 计算两个经纬度直接的直线距离

 @param lon1 第一个经度
 @param lat1 第一个纬度
 @param lon2 第二个经度
 @param lat2 第二个纬度

 @return double
 */
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;


/**
 判断是不是在中国

 @param location CLLocationCoordinate2D坐标

 @return BOOL
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02

/**
 地球坐标系 (WGS-84)到火星坐标系 (GCJ-02)

 @param wgsLoc CLLocationCoordinate2D坐标

 @return CLLocationCoordinate2D
 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end
