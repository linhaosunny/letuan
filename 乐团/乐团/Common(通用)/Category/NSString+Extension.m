//
//  NSString+Extension.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)stringWithDot:(NSString *) string andSubAfterDotString:(NSUInteger) count{
    NSUInteger dotLocation = [string rangeOfString:@"."].location;
    if (dotLocation != NSNotFound) {
        // 超过count位小数
        if (string.length - dotLocation > (count + 1)) {
            return  [string substringToIndex:dotLocation + (count + 1)];
        }
    }
    
    return string;
}
@end
