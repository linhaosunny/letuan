//
//  MutableScrollView.m
//  春暖花开-电台心情
//
//  Created by 李莎鑫 on 2016/11/17.
//  Copyright © 2016年 李莎鑫. All rights reserved.
//

#import "MutableScrollView.h"

@implementation MutableScrollView

-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if ([view isKindOfClass:[UIButton class]]) {
        
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
    
}

@end
