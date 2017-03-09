//
//  MTSortsModel.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSortsModel : NSObject
// > 排序名称
@property (nonatomic, copy) NSString  *label;
// > 排序编号
@property (nonatomic, assign) NSInteger  value;

+ (NSArray *)sorts;
@end
