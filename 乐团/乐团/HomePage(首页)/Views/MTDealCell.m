//
//  MTDealCell.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTDealCell.h"
#import "MTDealModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "CommonDefine.h"


@interface MTDealCell ()

// > 背景图片
@property (nonatomic, weak) UIImageView *backgroudImage;

// > 新单
@property (nonatomic, weak) UIImageView *newsDeal;

// > 图片
@property (nonatomic, weak) UIImageView *picture;

// > 标题
@property (nonatomic, weak) UILabel *title;

// > 描述
@property (nonatomic, weak) UILabel *description_inform;

// > 当前标价
@property (nonatomic, weak) UILabel *current_price;

// > 原始标价
@property (nonatomic, weak) UILabel *list_price;

// > 购买人数
@property (nonatomic, weak) UILabel *purchase_count;

// > 按钮遮盖
@property (nonatomic, weak) UIButton *cellButton;

// > 选中View
@property (nonatomic, weak) UIImageView *selectView;

@end



@implementation MTDealCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupDealCell];
    }
    return self;
}

- (void)setupDealCell{
    // > 背景图片
    UIImageView *backgroudImage = [[UIImageView alloc] init];
    [backgroudImage setUserInteractionEnabled:YES];
    [backgroudImage setImage:[UIImage imageNamed:@"bg_dealcell"]];
    [self addSubview:backgroudImage];
    self.backgroudImage = backgroudImage;
    
    // > 图片
    UIImageView *picture = [[UIImageView alloc] init];
    [picture setUserInteractionEnabled:YES];
    [self addSubview:picture];
    self.picture = picture;
    
    // > 新单
    UIImageView *newsDeal = [[UIImageView alloc] init];
    [newsDeal setImage:[UIImage imageNamed:@"ic_deal_new"]];
    [newsDeal setUserInteractionEnabled:YES];
    [self addSubview:newsDeal];
    self.newsDeal = newsDeal;
    
    // > 标题
    UILabel *title = [[UILabel alloc] init];
    [self addSubview:title];
    self.title = title;
    
    // > 描述
    UILabel *description_inform = [[UILabel alloc] init];
    [description_inform setTextColor:[UIColor grayColor]];
    [description_inform setFont:[UIFont systemFontOfSize:14.0]];
    [description_inform setNumberOfLines:0];

    [self addSubview:description_inform];
    self.description_inform = description_inform;
    
    // > 当前标价
    UILabel *current_price = [[UILabel alloc] init];
    [current_price setTextColor:[UIColor orangeColor]];
    [current_price setFont:[UIFont systemFontOfSize:18.0]];
    [self addSubview:current_price];
    self.current_price = current_price;
    
    // > 原始标价
    UILabel *list_price = [[UILabel alloc] init];
    [list_price setTextColor:[UIColor grayColor]];
    [list_price setFont:[UIFont systemFontOfSize:13.0]];
    
    [self addSubview:list_price];
    self.list_price = list_price;
    
    // > 购买人数
    UILabel *purchase_count = [[UILabel alloc] init];
    [purchase_count setTextColor:[UIColor grayColor]];
    [purchase_count setFont:[UIFont systemFontOfSize:13.0]];
    [purchase_count setTextAlignment:NSTextAlignmentRight];
    [self addSubview:purchase_count];
    self.purchase_count = purchase_count;
    
#warning 注意：如果collectionView添加全局按钮则会拦截collectionView的didselecteditems代理方法 ,所以默认设置隐藏
    // > 按钮
    UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cellButton addTarget:self action:@selector(cellDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cellButton setBackgroundColor:[UIColor whiteColor]];
    [cellButton setAlpha:0.7];
    [cellButton setHidden:YES];
    [cellButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cellButton];
    self.cellButton = cellButton;
    
    // > 选中view
    UIImageView *selectView = [[UIImageView alloc] init];
    [selectView setImage:[UIImage imageNamed:@"ic_choosed"]];
    //  > 可以通过在cover上加允许用户交互的view显示详情
//    [selectView setUserInteractionEnabled:YES];
    [selectView setHidden:YES];
    [self addSubview:selectView];
    self.selectView = selectView;
    // > 自动布局
    [self setupSubViewsConstraints];
 
}

- (void)cellDidSelected:(UIButton *) button{
    DebugLog(@"cell 选中");
}

- (void)setupSubViewsConstraints{
    // > 背景图
    [self.backgroudImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
    }];

     // > 图片
    [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(self.mas_width).multipliedBy(9.0/16);
    }];
    
    // > 新单
    [self.newsDeal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backgroudImage);
        make.size.mas_equalTo(CGSizeMake(38, 24));
    }];
    
    // > 标题
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.picture.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    
    // > 当前标价
    [self.current_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    // > 原始标价
    [self.list_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.current_price.mas_bottom);
        make.left.equalTo(self.current_price.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    // > 购买人数
    [self.purchase_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.list_price.mas_right);
        make.bottom.equalTo(self.list_price.mas_bottom);
        make.height.equalTo(self.list_price);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    // > 描述
    [self.description_inform mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.current_price.mas_left);
        make.right.equalTo(self.purchase_count.mas_right);
        make.top.equalTo(self.title.mas_bottom).offset(0);
        make.bottom.equalTo(self.current_price.mas_top).offset(-10);
    }];
    
    // > 按钮
    [self.cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
    }];
    
    // > 选中view
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
}

- (void)setDeal:(MTDealModel *)deal{
    _deal = deal;
    
    // > 图片
    [self.picture sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    // > 标题
    [self.title setText:deal.title];
    
    // > 描述
    [self.description_inform setText:deal.description_inform];
    
    // > 当前价格
    [self.current_price setText:[NSString stringWithDot:[NSString stringWithFormat:@"¥%@",deal.current_price] andSubAfterDotString:2]];
    
    // > 原始价格
    [self.list_price setText:[NSString stringWithDot:[NSString stringWithFormat:@"¥%@",deal.list_price] andSubAfterDotString:2]];
    
    //从这里开始就是设置富文本的属性
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.list_price.text];
    
    // > 下面开始是设置线条的风格：
    /** 第一个参数addAttribute:是设置要中线（删除线）还是下划线。
     // > NSStrikethroughStyleAttributeName：这种是从文本中间穿过，也就是删除线。
     // > NSUnderlineStyleAttributeName：这种是下划线。
    
     // > 第二个参数value：是设置线条的风格：虚线，实现，点线......
     // > 第二参数需要同时设置Pattern和style才能让线条显示。
    
     // > 第三个参数range:是设置线条的长度，切记，不能超过字符串的长度，否则会报错。
     */
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)  range:NSMakeRange(0, self.list_price.text.length)];
    
    // > 下列是设置线条的颜色
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, self.list_price.text.length)];
    
    [self.list_price setAttributedText:attri];
    
    // > 购买人数
    [self.purchase_count  setText:[NSString stringWithFormat:@"已售出%d",deal.purchase_count]];
    
    // > 发布日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    if([deal.publish_date isEqualToString:[formatter stringFromDate:[NSDate date]]]){
        [self.newsDeal setHidden:NO];
    }else{
        [self.newsDeal setHidden:YES];
    }
    
    // > 设置编辑状态
    [self.cellButton setHidden:!deal.editing];
    
    // > 设置是否被选中
    [self.selectView setHidden:!deal.isChecking];
    
//    DebugLog(@"发布日期：%@",deal.publish_date);
    
}

- (void)cellButtonClick:(UIButton *) button{
    // > 更新显示
    self.selectView.hidden = !self.selectView.isHidden;
    
    if([self.delegate respondsToSelector:@selector(dealCellDidChangedChecking:andWithDealModel:)]){
        [self.delegate dealCellDidChangedChecking:self andWithDealModel:self.deal];
    }
}

@end
