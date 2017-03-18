//
//  LTDeitalView.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDeitalView.h"
#import "LTNavigationView.h"
#import "LTDetailBodyView.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface LTDeitalView ()<LTNavigationViewDelegate,LTDetailBodyViewDelegate>
@property (nonatomic, weak) LTNavigationView *navigationView;
@property (nonatomic, weak) LTDetailBodyView *bodyView;
@end

@implementation LTDeitalView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupDetailView];
    }
    return self;
}
- (void)setupDetailView{
    // > 导航条
    LTNavigationView *navigationView = [[LTNavigationView alloc] init];
    [navigationView setDelegate:self];
    [self addSubview:navigationView];
    self.navigationView = navigationView;
    
    // > 主题显示bodyView
    LTDetailBodyView *bodyView = [[LTDetailBodyView alloc] init];
    [bodyView setDelegate:self];
    [self addSubview:bodyView];
    self.bodyView = bodyView;
    
    
}

- (void)layoutSubviews{
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    
    
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.bottom.equalTo(self).offset(-15);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyView.mas_bottom);
    }];
}

- (void)detailViewImageWithURLString:(NSString *) url{
    [self.bodyView iconViewImageWithURLString:url];

}

- (void)detailViewTitleWithText:(NSString *) text{
    [self.bodyView titleWithText: text];

}

- (void)detailViewDetailTitleWithText:(NSString *) text{
    [self.bodyView detailTitleWithText: text];

}

- (void)detailViewCurrentPriceLabelWithText:(NSString *) text{
    [self.bodyView currentPriceLabelWithText: text];

}

- (void)detailViewListPriceLabelWithText:(NSString *) text{
    [self.bodyView listPriceLabelWithText: text];

}

- (void)detailViewBackAnyTimeSupport:(BOOL) support{
    [self.bodyView backAnyTimeSupport:support];

}

- (void)detailViewExpiredSupport:(BOOL) support{
    [self.bodyView expiredSupport:support];

}

- (void)detailViewPurchaseCountWithText:(NSString *) text{
    [self.bodyView purchaseCountWithText:text];

}

- (void)detailViewEndTimeWithText:(NSString *) text{
    [self.bodyView endTimeWithText:text];

}

- (void)detailViewCollectButtonSetSelected:(BOOL) isSelect{
    [self.bodyView collectButtonSetSelected:(BOOL) isSelect];

}
#pragma mark - <LTNavigationViewDelegate>
- (void)navigationView:(LTNavigationView *)view didClickLeftButton:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(deitalView:didClickNavigationLeftButton:)]){
        [self.delegate deitalView:self didClickNavigationLeftButton:button];
    }
}
#pragma mark - <LTDetailBodyViewDelegate>
- (void)detailBodyView:(LTDetailBodyView *)view didClickBuyButton:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(deitalView:didClickBuyButton:)]){
        [self.delegate deitalView:self didClickBuyButton:button];
    }
}

- (void)detailBodyView:(LTDetailBodyView *)view didClickCollectButton:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(deitalView:didClickCollectButton:)]){
        [self.delegate deitalView:self didClickCollectButton:button];
    }
}

- (void)detailBodyView:(LTDetailBodyView *)view didClickShareButton:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(deitalView:didClickShareButton:)]){
        [self.delegate deitalView:self didClickShareButton:button];
    }
}

@end
