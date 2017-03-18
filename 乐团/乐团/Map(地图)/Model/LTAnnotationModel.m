//
//  LTAnnotationModel.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTAnnotationModel.h"

@implementation LTAnnotationModel
- (BOOL)isEqual:(LTAnnotationModel *) model{
    return [self.title isEqualToString:model.title];
}
@end
