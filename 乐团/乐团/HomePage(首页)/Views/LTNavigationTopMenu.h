//
//  LTNavigationTopMenu.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTNavigationTopMenu;

@protocol LTNavigationTopMenuDelegate <NSObject>

@optional

- (void)navigationTopMenu:(LTNavigationTopMenu *) menu didClickedWithButton:(UIButton *) button;

@end

@interface LTNavigationTopMenu : UIView

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *detailTitleText;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *selectedIcon;

@property (nonatomic, weak) id<LTNavigationTopMenuDelegate> delegate;
@property (nonatomic,assign) Class dropMenuClass;

+ (instancetype)navigationTopMenuWithTitle:(NSString *)title andDetailTitle:(NSString *) detailTitle andImageIcon:(NSString *) icon andSelectedImageIcon:(NSString *) selectedIcon;
@end
