//
//  LTDealModel.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDealModel.h"
#import "LTBusinessesModel.h"
#import "MJExtension.h"

@implementation LTDealModel

- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"description_inform":@"description"};
}

- (NSDictionary *)objectClassInArray{
    return @{@"businesses":[LTBusinessesModel class]};
}

- (BOOL)isEqual:(LTDealModel *) model{
    return [self.deal_id isEqualToString:model.deal_id];
}

MJCodingImplementation
@end
