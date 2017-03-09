//
//  MTDealTool.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/25.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTDealModel;

@interface MTDealTool : NSObject

/**
 *  // > (int) NumOfPage - 每页多少个数据
 *  // > (int) page      - 页码
 *  // > (NSArray *)     - 一页页码对应的数据
 */
+ (NSArray *)collectDealsWithNumofPage:(int) NumOfPage withPage:(int) page;
+ (NSArray *)recentDealsWithNumofPage:(int) NumOfPage withPage:(int) page;

+ (void)addCollectDeal:(MTDealModel *) deal;
+ (void)removeCollectDeal:(MTDealModel *) deal;
+ (BOOL)isCollectDeal:(MTDealModel *) deal;
+ (int)collectDealsCount;

+ (void)addRecentDeal:(MTDealModel *) deal;
+ (void)removeRecentDeal:(MTDealModel *) deal;
+ (BOOL)isRecentDeal:(MTDealModel *) deal;
+ (int)recentDealsCount;
@end
