//
//  MTDealModel.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTDealModel.h"
#import "MTBusinessesModel.h"
#import "MJExtension.h"

@implementation MTDealModel

- (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"description_inform":@"description"};
}

- (NSDictionary *)objectClassInArray{
    return @{@"businesses":[MTBusinessesModel class]};
}

- (BOOL)isEqual:(MTDealModel *) model{
    return [self.deal_id isEqualToString:model.deal_id];
}

MJCodingImplementation
@end
