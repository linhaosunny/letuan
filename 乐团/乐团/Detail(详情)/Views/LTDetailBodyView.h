//
//  LTDetailBodyView.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTDetailBodyView;

@protocol LTDetailBodyViewDelegate <NSObject>

@optional

- (void)detailBodyView:(LTDetailBodyView *) view didClickBuyButton:(UIButton *) button;
- (void)detailBodyView:(LTDetailBodyView *) view didClickCollectButton:(UIButton *) button;
- (void)detailBodyView:(LTDetailBodyView *) view didClickShareButton:(UIButton *) button;
@end


@interface LTDetailBodyView : UIView

@property (nonatomic, weak) id<LTDetailBodyViewDelegate> delegate;

- (void)iconViewImageWithURLString:(NSString *) url;
- (void)titleWithText:(NSString *) text;
- (void)detailTitleWithText:(NSString *) text;
- (void)currentPriceLabelWithText:(NSString *) text;
- (void)listPriceLabelWithText:(NSString *) text;
- (void)backAnyTimeSupport:(BOOL) support;
- (void)expiredSupport:(BOOL) support;
- (void)endTimeWithText:(NSString *) text;
- (void)purchaseCountWithText:(NSString *) text;
- (void)collectButtonSetSelected:(BOOL) isSelect;
@end
