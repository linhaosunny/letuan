//
//  MTNavigationTopMenu.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTNavigationTopMenu.h"
#import "CommonDefine.h"
#import "Masonry.h"

@interface MTNavigationTopMenu ()
@property (nonatomic, weak) UIView    *splitLine;
@property (nonatomic, weak) UIButton  *menuButton;
//@property (nonatomic, weak) UILabel   *title;
//@property (nonatomic, weak) UILabel   *detailTitle;
@end

@implementation MTNavigationTopMenu

- (void)setupTopMenuWithTitle:(NSString *)titleName andDetailTitle:(NSString *) detailTitleName andImageIcon:(NSString *) icon andSelectedImageIcon:(NSString *) selectedIcon{
    // > 分割线
    UIView *splitLine = [[UIView alloc] init];
    splitLine.backgroundColor = MTColorAlpha(0, 0, 0, 0.2);
    [self addSubview:splitLine];
    self.splitLine = splitLine;
    
//    // > 标题
//    UILabel *title = [[UILabel alloc] init];
//    [title setFont:[UIFont systemFontOfSize:12.0]];
//    [title setText:titleName];
//    [self addSubview:title];
//    self.title = title;
//    
//    // > 副标题
//    UILabel *detailTitle = [[UILabel alloc] init];
//    [detailTitle setFont:[UIFont systemFontOfSize:15.0]];
//    [detailTitle setText:detailTitleName];
//    [self addSubview: detailTitle];
//    self.detailTitle = detailTitle;
    
    // > 全局按钮
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    
    [menuButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [menuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
   
    [self addSubview:menuButton];
    self.menuButton = menuButton;
    // > 自动布局
    [self setupSubItemsConstraints];
}


- (void)setupSubItemsConstraints{
    weak_self weakSelf = self;
    // > 分割线
    [self.splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.left.equalTo(weakSelf.mas_left).mas_offset(5);
        make.top.equalTo(weakSelf.mas_top).mas_offset(5);
        make.bottom.equalTo(weakSelf.mas_bottom).mas_offset(-5);
    }];
    
//    // 标题
//    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.mas_top);
//        make.right.equalTo(weakSelf.mas_right).mas_offset(-5);
//        make.left.equalTo(weakSelf.mas_left).mas_offset(50);
//        make.width.mas_equalTo(16);
//    }];
//    
//    // 副标题
//    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.mas_bottom);
//        make.right.equalTo(weakSelf.mas_right).mas_offset(-5);
//        make.left.equalTo(weakSelf.mas_left).mas_offset(50);
//        make.width.mas_equalTo(20);
//    }];
    
    // 全局按钮
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right);
        make.left.equalTo(weakSelf.mas_left);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    

}

- (void)menuButtonClick:(UIButton *) button{
    
    if([self.delegate respondsToSelector:@selector(navigationTopMenu:didClickedWithButton:)]){
        [self.delegate navigationTopMenu:self didClickedWithButton:button];
    }
}

#pragma mark - 设置方法
//- (NSString *)titleText{
//    return self.title.text;
//}
//
//- (NSString *)detailTitleText{
//    return self.detailTitle.text;
//}
//
//- (void)setTitleText:(NSString *)titleText{
//    self.title.text = [titleText copy];
//}
//
//- (void)setDetailTitleText:(NSString *)detailTitleText{
//    self.detailTitle.text = [detailTitleText copy];
//}

- (void)setIcon:(NSString *)icon{
    [self.menuButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
}

- (void)setSelectedIcon:(NSString *)selectedIcon{
    [self.menuButton setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
}

+ (instancetype)navigationTopMenuWithTitle:(NSString *)title andDetailTitle:(NSString *) detailTitle andImageIcon:(NSString *) icon andSelectedImageIcon:(NSString *) selectedIcon{
    
     MTNavigationTopMenu *menu = [[self alloc] init];
    [menu setupTopMenuWithTitle:title andDetailTitle:detailTitle andImageIcon:icon andSelectedImageIcon:selectedIcon];
    return menu;
}
@end
