//
//  LTDetailBodyView.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDetailBodyView.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "Masonry.h"
#import "CommonDefine.h"

@interface LTDetailBodyView ()
@property (nonatomic, weak) UIImageView * iconView;
@property (nonatomic, weak) UILabel * title;
@property (nonatomic, weak) UILabel * detailTitle;
@property (nonatomic, weak) UILabel * current_price;
@property (nonatomic, weak) UILabel * list_price;
@property (nonatomic, weak) UIButton * buy_button;
@property (nonatomic, weak) UIButton * share_button;
@property (nonatomic, weak) UIButton * collect_button;
@property (nonatomic, weak) UIView   * spliteLine;
@property (nonatomic, weak) UIButton * backAnyTimeButton;
@property (nonatomic, weak) UIButton * expiredButton;
@property (nonatomic, weak) UIButton * endTimeButton;
@property (nonatomic, weak) UIButton * purchaseCount;
@end

@implementation LTDetailBodyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupDetailBodyView];
    }
    return self;
}
- (void)setupDetailBodyView{
    // > 图片
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setUserInteractionEnabled:YES];
    [self addSubview:iconView];
    self.iconView = iconView;
    
    // > 标题
    UILabel * title = [[UILabel alloc] init];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    
    [title setNumberOfLines:0];
    [self addSubview:title];
    self.title = title;
    
    // > 副标题
    UILabel * detailTitle = [[UILabel alloc] init];
    [detailTitle setNumberOfLines:0];
    [detailTitle setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:detailTitle];
    self.detailTitle = detailTitle;
    
    // > 当前价格
    UILabel * current_price = [[UILabel alloc] init];
    [current_price setTextColor:[UIColor orangeColor]];
    [current_price setFont:[UIFont systemFontOfSize:20.0]];
    [self addSubview:current_price];
    self.current_price = current_price;
    
    // > 门店价格
    UILabel * list_price = [[UILabel alloc] init];
    [list_price setFont:[UIFont systemFontOfSize:13.0]];
    [list_price setTextColor:[UIColor grayColor]];
    [self addSubview:list_price];
    self.list_price = list_price;
    
    // > 立即抢购
    UIButton * buy_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [buy_button setBackgroundImage:[UIImage imageNamed:@"bg_deal_purchaseButton"] forState:UIControlStateNormal];
    [buy_button setBackgroundImage:[UIImage imageNamed:@"bg_deal_purchaseButton_highlighted"] forState:UIControlStateHighlighted];
    [buy_button setTitle:@"立即抢购" forState:UIControlStateNormal];
    [buy_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buy_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [buy_button addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buy_button];
    self.buy_button = buy_button;
    
    // > 收藏
    UIButton * collect_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [collect_button setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    [collect_button setImage:[UIImage imageNamed:@"icon_collect_highlighted"] forState:UIControlStateSelected];
    [collect_button setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [collect_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [collect_button addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collect_button];
    self.collect_button = collect_button;
    // > 分享
    UIButton * share_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [share_button setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [share_button setImage:[UIImage imageNamed:@"icon_share_highlighted"] forState:UIControlStateHighlighted];
    [share_button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
 
    [share_button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [share_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self addSubview:share_button];
    self.share_button = share_button;
    
    // > 分割线
    UIView   * spliteLine = [[UIView alloc] init];
    [spliteLine setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:spliteLine];
    self.spliteLine = spliteLine;
    
    // > 随时退
    UIButton * backAnyTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backAnyTimeButton setImage:[UIImage imageNamed:@"icon_order_unrefundable"] forState:UIControlStateNormal];
    [backAnyTimeButton setImage:[UIImage imageNamed:@"icon_order_refundable"] forState:UIControlStateSelected];
    [backAnyTimeButton setUserInteractionEnabled:NO];
    [backAnyTimeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backAnyTimeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [backAnyTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [backAnyTimeButton setTitle:@"支持随时退" forState:UIControlStateNormal];
    [backAnyTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backAnyTimeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:backAnyTimeButton];
    self.backAnyTimeButton = backAnyTimeButton;
    
    // > 过期退
    UIButton * expiredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [expiredButton setImage:[UIImage imageNamed:@"icon_order_unrefundable"] forState:UIControlStateNormal];
    [expiredButton setImage:[UIImage imageNamed:@"icon_order_refundable"] forState:UIControlStateSelected];
    [expiredButton setUserInteractionEnabled:NO];
    [expiredButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [expiredButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [expiredButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [expiredButton setTitle:@"支持过期退" forState:UIControlStateNormal];
    [expiredButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [expiredButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:expiredButton];
    self.expiredButton = expiredButton;
    
    // > 结束时间
    UIButton * endTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endTimeButton setImage:[UIImage imageNamed:@"icon_deal_timer"] forState:UIControlStateNormal];
    [endTimeButton setUserInteractionEnabled:NO];
   
    [endTimeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [endTimeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [endTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [endTimeButton setTitle:@"6天15小时5分" forState:UIControlStateNormal];
    [endTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [endTimeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    
    [self addSubview:endTimeButton];
    self.endTimeButton = endTimeButton;
    
    // > 购买数量
    UIButton * purchaseCount = [UIButton buttonWithType:UIButtonTypeCustom];
    [purchaseCount setImage:[UIImage imageNamed:@"icon_deal_soldNumber"] forState:UIControlStateNormal];
    [purchaseCount setUserInteractionEnabled:NO];
    
    [purchaseCount setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [purchaseCount setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [purchaseCount setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [purchaseCount setTitle:@"已售出0" forState:UIControlStateNormal];
    [purchaseCount setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [purchaseCount.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:purchaseCount];
    self.purchaseCount = purchaseCount;
    
    // >自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(self.mas_width).multipliedBy(0.6);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(10);
    }];
    
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.title.mas_bottom).offset(10);
    }];
    
    [self.current_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.detailTitle.mas_bottom).offset(10);
    }];
    
    [self.list_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.current_price.mas_right);
        make.bottom.equalTo(self.current_price.mas_bottom);
        make.right.equalTo(self);
    }];
    
    [self.buy_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.list_price.mas_bottom).offset(15);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(40);
    }];
    
    [self.collect_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buy_button.mas_right);
        make.centerY.equalTo(self.buy_button.mas_centerY);
        make.width.equalTo(self.buy_button).multipliedBy(0.5);
        make.height.equalTo(self.buy_button);
    }];
    
    [self.share_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collect_button.mas_right);
        make.top.width.height.equalTo(self.collect_button);
    }];
    
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.buy_button.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.backAnyTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spliteLine.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(40);
    }];
    
    [self.expiredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backAnyTimeButton.mas_bottom);
        make.left.width.height.equalTo(self.backAnyTimeButton);
    }];
    
    [self.endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backAnyTimeButton.mas_right);
        make.top.width.height.equalTo(self.backAnyTimeButton);
    }];
    
    [self.purchaseCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endTimeButton.mas_bottom);
        make.left.width.height.equalTo(self.endTimeButton);
    }];
#warning 在父view上没有指定view大小时，在布局子view的时候指定默认view的约束
    // >
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.purchaseCount.mas_bottom).offset(10);
    }];
}

- (void)iconViewImageWithURLString:(NSString *) url{
    // > 图片
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
}

- (void)titleWithText:(NSString *) text{
    [self.title setText:text];
}

- (void)detailTitleWithText:(NSString *) text{
    [self.detailTitle setText:text];
}

- (void)currentPriceLabelWithText:(NSString *) text{
       [self.current_price setText:[NSString stringWithDot: text andSubAfterDotString:2]];
}

- (void)listPriceLabelWithText:(NSString *) text{
    [self.list_price setText:[NSString stringWithDot:text andSubAfterDotString:2]];
    
    //从这里开始就是设置富文本的属性
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.list_price.text];
    
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)  range:NSMakeRange(0, self.list_price.text.length)];
    
    // > 下列是设置线条的颜色
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, self.list_price.text.length)];
    
    [self.list_price setAttributedText:attri];
}

- (void)collectButtonSetSelected:(BOOL) isSelect{
    [self.collect_button setSelected:isSelect];
}

- (void)backAnyTimeSupport:(BOOL) support{
    [self.backAnyTimeButton setSelected:support];
}

- (void)expiredSupport:(BOOL) support{
    [self.expiredButton setSelected:support];
}

- (void)endTimeWithText:(NSString *) text{
    [self.endTimeButton setTitle:text forState:UIControlStateNormal];
}

- (void)purchaseCountWithText:(NSString *) text{
    [self.purchaseCount setTitle:text forState:UIControlStateNormal];
}

- (void)buyNow:(UIButton *) button{
    if([self.delegate respondsToSelector:@selector(detailBodyView:didClickBuyButton:)]){
        [self.delegate detailBodyView:self didClickBuyButton:button];
    }
}

- (void)collect:(UIButton *) button{
    
    if([self.delegate respondsToSelector:@selector(detailBodyView:didClickCollectButton:)]){
        [self.delegate detailBodyView:self didClickCollectButton:button];
    }
    
    button.selected = !button.isSelected;
}

- (void)share:(UIButton *) button{
    if([self.delegate respondsToSelector:@selector(detailBodyView:didClickShareButton:)]){
        [self.delegate detailBodyView:self didClickShareButton:button];
    }
}
@end
