//
//  LTNetWorkParamsModel.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNetWorkParamsModel : NSObject

// > 城市
@property (nonatomic, copy) NSString *city;
// > 区域
@property (nonatomic, copy) NSString *region;
// > 分类
@property (nonatomic, copy) NSString *category;
// > 关键词
@property (nonatomic, copy) NSString *keyword;
// > 排序
@property (nonatomic, assign) int sort;

+ (instancetype)sharedParamsModel;
@end
