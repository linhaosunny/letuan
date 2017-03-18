//
//  LTDeitalView.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTDeitalView;

@protocol LTDeitalViewDelegate <NSObject>

@optional
- (void)deitalView:(LTDeitalView *)view didClickNavigationLeftButton:(UIButton *)button;
- (void)deitalView:(LTDeitalView *)view didClickBuyButton:(UIButton *)button;
- (void)deitalView:(LTDeitalView *)view didClickCollectButton:(UIButton *)button;
- (void)deitalView:(LTDeitalView *)view didClickShareButton:(UIButton *)button;
@end

@interface LTDeitalView : UIView

@property (nonatomic, weak) id<LTDeitalViewDelegate> delegate;
@property (nonatomic, assign) CGFloat viewHeight;

- (void)detailViewImageWithURLString:(NSString *) url;
- (void)detailViewTitleWithText:(NSString *) text;
- (void)detailViewDetailTitleWithText:(NSString *) text;
- (void)detailViewCurrentPriceLabelWithText:(NSString *) text;
- (void)detailViewListPriceLabelWithText:(NSString *) text;
- (void)detailViewBackAnyTimeSupport:(BOOL) support;
- (void)detailViewExpiredSupport:(BOOL) support;
- (void)detailViewPurchaseCountWithText:(NSString *) text;
- (void)detailViewEndTimeWithText:(NSString *) text;
- (void)detailViewCollectButtonSetSelected:(BOOL) isSelect;
@end
