//
//  MTDetailBodyView.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDetailBodyView;

@protocol MTDetailBodyViewDelegate <NSObject>

@optional

- (void)detailBodyView:(MTDetailBodyView *) view didClickBuyButton:(UIButton *) button;
- (void)detailBodyView:(MTDetailBodyView *) view didClickCollectButton:(UIButton *) button;
- (void)detailBodyView:(MTDetailBodyView *) view didClickShareButton:(UIButton *) button;
@end


@interface MTDetailBodyView : UIView

@property (nonatomic, weak) id<MTDetailBodyViewDelegate> delegate;

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
