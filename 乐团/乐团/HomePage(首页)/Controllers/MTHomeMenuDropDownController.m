//
//  MTHomeMenuDropDownController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTHomeMenuDropDownController.h"
#import "MTCategoryModel.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "CommonDefine.h"

@interface MTHomeMenuDropDownController ()<UIGestureRecognizerDelegate>

@end


@implementation MTHomeMenuDropDownController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupHomeMenuDropDown];
}


- (void)setupHomeMenuDropDown{
    // > 左边的tableView
    UITableView *leftView = [[UITableView alloc] init];
    [leftView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [leftView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]]];
    [self.view addSubview:leftView];
    self.leftView = leftView;
    
    // > 右边的tableView
    UITableView *rightView = [[UITableView alloc] init];
    [rightView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [rightView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchRightTableViewWithSpaceArea)];
    [tap setDelegate:self];
    [rightView addGestureRecognizer:tap];
    
    [self.view addSubview:rightView];
    self.rightView = rightView;
    
}

- (void)touchRightTableViewWithSpaceArea{
    if([self.delegate respondsToSelector:@selector(homeMenuDropDownController:didTouchRightTableViewWithSpaceArea:)]){
        [self.delegate homeMenuDropDownController:self didTouchRightTableViewWithSpaceArea:self.rightView];
    }
}

#pragma mark - <UIGestureRecognizerDelegate> 区分cell点击与空白处点击
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return  NO;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
    
       weak_self weakSelf = self;
    // > 左边布局
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(weakSelf.view.width*0.5);
    }];
    
    
    // > 右边布局
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftView.mas_right);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
