//
//  CommonDefine.h
//  乐团
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
#define LTColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LTGlobalBlackgroudColor LTColor(230,230,230)

#define LTColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0]

#define LTNavigationRightBarButtonItemWidth  40

#pragma mark - 通知
#define LTCollectChangeNotification @"LTCollectChangeNotification"
#define LTCollectSelect @"isCollected"
#define LTCollectValue  @"CollectedDeal"

#define LTNotificationExit  @"NotificationExit"
#define LTNotificationInit  @"NotificationInit"
// > 改变分类通知
#define LTCagtegoryChangedNotification @"LTCagtegoryChangedNotification"
#define LTIconCategorySelected  @"IconCategorySelected"
#define LTIconHLCategorySelected  @"IconHLCategorySelected"
#define LTMainCagtegorySelected @"MainCagtegorySelected"
#define LTSubCagtegorySelected @"SubCagtegorySelected"



// > 改变城市通知
#define LTCityChangedNotification @"LTCityChangedNotification"
#define LTSelectedCity @"SelectedCity"
#define LTSelectedRegion @"SelectedRegion"
#define LTSelectedSubRegion @"SelectedSubRegion"


// > 排序通知
#define LTSortChangedNotification @"LTSortChangedNotification"
#define LTSortSelected @"SortSelected"
#define LTSortVaule @"SortVaule"

#pragma mark - 数据库
#define LTDataBaseDealPerPageNum  6

#endif /* CommonDefine_h */
