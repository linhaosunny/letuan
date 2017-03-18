//
//  LTCategoryModel.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTCategoryModel.h"
#import "LTDealModel.h"
#import "MJExtension.h"

@implementation LTCategoryModel

+ (NSArray *)categorys{
    return [LTCategoryModel objectArrayWithFilename:@"categories.plist"];
}

+ (LTCategoryModel *)categoryWithDeal:(LTDealModel *) deal{
    NSArray *categroys = [self categorys];
 
    NSString  *categroyName = [deal.categories firstObject];
    for(LTCategoryModel *model in categroys){
        
        if([model.name isEqualToString:categroyName]){
            return model;
        }
        
        if([model.subcategories containsObject:categroyName]){
            return model;
        }
    
    }
    return nil;
}
@end
