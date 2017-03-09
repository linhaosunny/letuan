//
//  MTHomeMenuDropDownController.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTHomeMenuDropDownController;

@protocol  MTHomeMenuDropDownControllerDelegate <NSObject>

@optional
- (void)homeMenuDropDownController:(MTHomeMenuDropDownController *) controller didTouchRightTableViewWithSpaceArea:(UITableView *) rightView;

@end

@interface MTHomeMenuDropDownController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *leftView;
@property (nonatomic, weak) UITableView *rightView;
@property (nonatomic, weak) id<MTHomeMenuDropDownControllerDelegate> delegate;

- (void)touchTableViewWithSpaceArea;
@end
