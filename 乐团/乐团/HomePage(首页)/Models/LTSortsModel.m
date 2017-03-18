//
//  LTSortsModel.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTSortsModel.h"
#import "MJExtension.h"

@implementation LTSortsModel

+ (NSArray *)sorts{
    return [LTSortsModel objectArrayWithFilename:@"sorts.plist"];
}

@end
