//
//  MTSortsModel.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTSortsModel.h"
#import "MJExtension.h"

@implementation MTSortsModel

+ (NSArray *)sorts{
    return [MTSortsModel objectArrayWithFilename:@"sorts.plist"];
}

@end
