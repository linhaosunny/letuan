//
//  MTCityGroupsModel.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCityGroupsModel : NSObject
// > 分组标题
@property (nonatomic, copy) NSString *title;
// > 城市
@property (nonatomic, strong) NSArray *cities;
@end
