//
//  MTCategoryModel.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTCategoryModel.h"
#import "MTDealModel.h"
#import "MJExtension.h"

@implementation MTCategoryModel

+ (NSArray *)categorys{
    return [MTCategoryModel objectArrayWithFilename:@"categories.plist"];
}

+ (MTCategoryModel *)categoryWithDeal:(MTDealModel *) deal{
    NSArray *categroys = [self categorys];
 
    NSString  *categroyName = [deal.categories firstObject];
    for(MTCategoryModel *model in categroys){
        
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
