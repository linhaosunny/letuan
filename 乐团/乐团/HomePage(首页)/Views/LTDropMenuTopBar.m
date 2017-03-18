//
//  LTDropMenuTopBar.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDropMenuTopBar.h"
#import "Masonry.h"
#import "CommonDefine.h"

@interface LTDropMenuTopBar ()
@property (nonatomic, weak) UIButton  *toolButton;
@property (nonatomic, weak) UIImageView  *rightView;
@end

@implementation LTDropMenuTopBar

- (void)setupDropMenuTopBarWithTitle:(NSString *)title andImageIcon:(NSString *) icon andSelectedImageIcon:(NSString *) selectedIcon andRightIcon:(NSString *) rightIcon andTarget:(nullable id)target action:(SEL)action{
    UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [toolButton setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateHighlighted];
    
    [toolButton setTitle:title forState:UIControlStateNormal];
    [toolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [toolButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [toolButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    
    [toolButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [toolButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:toolButton];
    self.toolButton = toolButton;
    
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:rightIcon]];
    [self addSubview:rightView];
    self.rightView = rightView;
    
    // > 自动布局
    [self setupSubItemsConstraints];
}


- (void)setupSubItemsConstraints{
    
    weak_self weakSelf = self;
    // > 按钮
    [self.toolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    // > 右边视图
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.rightView.mas_height);
        
    }];
}

+ (instancetype)dropMenuTopBarWithTitle:(NSString *)title andImageIcon:(NSString *) icon andSelectedImageIcon:(NSString *) selectedIcon andRightIcon:(NSString *) rightIcon andTarget:(nullable id)target action:(SEL)action{
    LTDropMenuTopBar *bar = [[self alloc] init];
    [bar setupDropMenuTopBarWithTitle:title andImageIcon:icon andSelectedImageIcon:selectedIcon andRightIcon:rightIcon andTarget:target action:action];
    return bar;
}

@end
