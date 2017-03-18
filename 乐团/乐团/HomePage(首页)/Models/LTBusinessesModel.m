//
//  LTBusinessesModel.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTBusinessesModel.h"
#import "MJExtension.h"

@implementation LTBusinessesModel
- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

MJCodingImplementation
@end
