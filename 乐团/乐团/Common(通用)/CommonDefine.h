//
//  CommonDefine.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#pragma mark - 替换宏
#define weak_obj(obj) typeof(self) __weak
#define WEAK_SELF  weak_obj(self)
#define weak_self  WEAK_SELF

#ifdef DEBUG
#define DebugLog(format, ...)  NSLog(format, ##__VA_ARGS__)
#else
#define DebugLog(format, ...)
#endif

#pragma mark - 颜色\边距
#define MTColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MTGlobalBlackgroudColor MTColor(230,230,230)

#define MTColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]

#define MTNavigationRightBarButtonItemWidth  40

#pragma mark - 通知
#define MTCollectChangeNotification @"MTCollectChangeNotification"
#define MTCollectSelect @"isCollected"
#define MTCollectValue  @"CollectedDeal"

#define MTNotificationExit  @"NotificationExit"
#define MTNotificationInit  @"NotificationInit"
// > 改变分类通知
#define MTCagtegoryChangedNotification @"MTCagtegoryChangedNotification"
#define MTIconCategorySelected  @"IconCategorySelected"
#define MTIconHLCategorySelected  @"IconHLCategorySelected"
#define MTMainCagtegorySelected @"MainCagtegorySelected"
#define MTSubCagtegorySelected @"SubCagtegorySelected"



// > 改变城市通知
#define MTCityChangedNotification @"MTCityChangedNotification"
#define MTSelectedCity @"SelectedCity"
#define MTSelectedRegion @"SelectedRegion"
#define MTSelectedSubRegion @"SelectedSubRegion"


// > 排序通知
#define MTSortChangedNotification @"MTSortChangedNotification"
#define MTSortSelected @"SortSelected"
#define MTSortVaule @"SortVaule"

#pragma mark - 数据库
#define MTDataBaseDealPerPageNum  6

#endif /* CommonDefine_h */
