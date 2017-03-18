//
//  LTDropMenuTopBar.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTDropMenuTopBar : UIView

+ (instancetype)dropMenuTopBarWithTitle:(NSString *)title andImageIcon:(NSString *) icon andSelectedImageIcon:(NSString *) selectedIcon andRightIcon:(NSString *) rightIcon andTarget:(nullable id)target action:(SEL)action;
@end
