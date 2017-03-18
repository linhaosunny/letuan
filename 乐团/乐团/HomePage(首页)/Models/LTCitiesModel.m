//
//  LTCitiesModel.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTCitiesModel.h"
#import "MJExtension.h"
#import "LTRegionModel.h"

@implementation LTCitiesModel

- (NSDictionary *)objectClassInArray{
    return @{@"regions":[LTRegionModel class]};
}

+ (NSArray *)cities{
    return [LTCitiesModel objectArrayWithFilename:@"cities.plist"];
}

@end
