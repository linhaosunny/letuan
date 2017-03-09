//
//  MTNavigationView.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTNavigationView;

@protocol MTNavigationViewDelegate <NSObject>

@optional
- (void)navigationView:(MTNavigationView *) view didClickLeftButton:(UIButton *) button;

@end

@interface MTNavigationView : UIView
@property (nonatomic, weak) id<MTNavigationViewDelegate> delegate;

@end
