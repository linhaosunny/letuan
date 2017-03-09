//
//  MTCitiesModel.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCitiesModel : NSObject

// > 城市名称
@property (nonatomic, copy) NSString *name;
// > 城市拼音
@property (nonatomic, copy) NSString *pinYin;
// > 城市拼音头部
@property (nonatomic, copy) NSString *pinYinHead;
// > 城市区域
@property (nonatomic, strong) NSArray *regions;

+ (NSArray *)cities;
@end
