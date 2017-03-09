//
//  MTBusinessesModel.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTBusinessesModel.h"
#import "MJExtension.h"

@implementation MTBusinessesModel
- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

MJCodingImplementation
@end
