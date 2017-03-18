//
//  LTNavigationView.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTNavigationView.h"
#import "Masonry.h"

@interface LTNavigationView ()
@property (nonatomic, weak) UIImageView * backImage;
@property (nonatomic, weak) UIButton * leftButton;
@property (nonatomic, weak) UILabel * titleLable;
@end

@implementation LTNavigationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupNavigationView];
    }
    return self;
}

- (void)setupNavigationView{
    // > 背景图
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_navigationBar_normal"]];
    [backImage setUserInteractionEnabled:YES];
    [self addSubview:backImage];
    self.backImage = backImage;
    
    // > 左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"icon_back_highlighted"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    self.leftButton = leftButton;
    
    // > 中间的title
    UILabel *titleLable = [[UILabel alloc] init];
    [titleLable setText:@"团购详情"];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLable];
    self.titleLable = titleLable;
    
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self.leftButton);
    }];
}

- (void)leftButtonClick:(UIButton *) button{
    if([self.delegate respondsToSelector:@selector(navigationView:didClickLeftButton:)]){
        [self.delegate navigationView:self didClickLeftButton:button];
    }
}

@end
