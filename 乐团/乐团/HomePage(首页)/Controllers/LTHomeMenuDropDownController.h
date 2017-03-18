//
//  LTHomeMenuDropDownController.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTHomeMenuDropDownController;

@protocol  LTHomeMenuDropDownControllerDelegate <NSObject>

@optional
- (void)homeMenuDropDownController:(LTHomeMenuDropDownController *) controller didTouchRightTableViewWithSpaceArea:(UITableView *) rightView;

@end

@interface LTHomeMenuDropDownController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *leftView;
@property (nonatomic, weak) UITableView *rightView;
@property (nonatomic, weak) id<LTHomeMenuDropDownControllerDelegate> delegate;

- (void)touchTableViewWithSpaceArea;
@end
