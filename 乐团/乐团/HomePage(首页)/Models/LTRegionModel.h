//
//  LTRegionModel.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTRegionModel : NSObject
// > 区域名称
@property (nonatomic, copy) NSString *name;
// > 子区域
@property (nonatomic, strong) NSArray *subregions;
@end
