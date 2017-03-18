//
//  LTDealTool.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/25.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LTDealModel;

@interface LTDealTool : NSObject

/**
 *  // > (int) NumOfPage - 每页多少个数据
 *  // > (int) page      - 页码
 *  // > (NSArray *)     - 一页页码对应的数据
 */
+ (NSArray *)collectDealsWithNumofPage:(int) NumOfPage withPage:(int) page;
+ (NSArray *)recentDealsWithNumofPage:(int) NumOfPage withPage:(int) page;

+ (void)addCollectDeal:(LTDealModel *) deal;
+ (void)removeCollectDeal:(LTDealModel *) deal;
+ (BOOL)isCollectDeal:(LTDealModel *) deal;
+ (int)collectDealsCount;

+ (void)addRecentDeal:(LTDealModel *) deal;
+ (void)removeRecentDeal:(LTDealModel *) deal;
+ (BOOL)isRecentDeal:(LTDealModel *) deal;
+ (int)recentDealsCount;
@end
