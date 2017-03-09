//
//  DPRequest+MTExtension.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "DPRequest+MTExtension.h"
#import "MUAssosiation.h"

@implementation DPRequest (MTExtension)

- (void)setSuccess_block:(SuccessBlock)success_block{
    [self setAssociatedObject:success_block forKey:@"SuccessBlock" association:NSAssociationCopy isAtomic:NO];
}

-  (SuccessBlock)success_block{
    return [self associatedObjectForKey:@"SuccessBlock"];
}

- (void)setFail_block:(FailBlock)fail_block{
    [self setAssociatedObject:fail_block forKey:@"FailBlock" association:NSAssociationCopy isAtomic:NO];
}

- (FailBlock)fail_block{
    return [self associatedObjectForKey:@"FailBlock"];
}

@end
