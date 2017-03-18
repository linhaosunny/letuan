//
//  LTNavigationView.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTNavigationView;

@protocol LTNavigationViewDelegate <NSObject>

@optional
- (void)navigationView:(LTNavigationView *) view didClickLeftButton:(UIButton *) button;

@end

@interface LTNavigationView : UIView
@property (nonatomic, weak) id<LTNavigationViewDelegate> delegate;

@end
