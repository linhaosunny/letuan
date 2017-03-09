//
//  MTCategoryModel.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTDealModel;

@interface MTCategoryModel : NSObject
// > 名称
@property (nonatomic, copy) NSString  *name;
// > 图片
@property (nonatomic, copy) NSString  *icon;
// > 选中图片
@property (nonatomic, copy) NSString  *highlighted_icon;
// > icon图片
@property (nonatomic, copy) NSString  *small_icon;
// > icon选中图片
@property (nonatomic, copy) NSString  *small_highlighted_icon;
// > 地图图标
@property (nonatomic, copy) NSString  *map_icon;
// > 子类
@property (nonatomic, copy) NSArray  *subcategories;

+ (NSArray *)categorys;
+ (MTCategoryModel *)categoryWithDeal:(MTDealModel *) deal;
@end
