//
//  MTCitiesModel.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTCitiesModel.h"
#import "MJExtension.h"
#import "MTRegionModel.h"

@implementation MTCitiesModel

- (NSDictionary *)objectClassInArray{
    return @{@"regions":[MTRegionModel class]};
}

+ (NSArray *)cities{
    return [MTCitiesModel objectArrayWithFilename:@"cities.plist"];
}

@end
