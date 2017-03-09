//
//  MTDealModel.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTRestrictionsModel,MTBusinessesModel;

@interface MTDealModel : NSObject

// > 团购单ID
@property (nonatomic, copy) NSString * deal_id;
// > 团购标题
@property (nonatomic, copy) NSString * title;
// > 团购描述
@property (nonatomic, copy) NSString * description_inform;
/** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
// > 团购包含商品原价值
@property (nonatomic, strong) NSNumber * list_price;
// > 团购价格
@property (nonatomic, strong) NSNumber * current_price;
// > 团购图片链接，最大图片尺寸450×280
@property (nonatomic, copy) NSString * image_url;
// > 小尺寸团购图片链接，最大图片尺寸160×100
@property (nonatomic, copy) NSString * s_image_url;
// > 团购当前已购买数
@property (nonatomic, assign) int purchase_count;
// > 团购发布上线日期
@property (nonatomic, copy) NSString * publish_date;
// > 团购单的截止购买日期
@property (nonatomic, copy) NSString * purchase_deadline;
// > 团购HTML5页面链接，适用于移动应用和联网车载应用
@property (nonatomic, copy) NSString * deal_h5_url;
// > 团购限制条件
@property (nonatomic, strong) MTRestrictionsModel *restrictions;
// > 商家
@property (nonatomic, strong) NSArray <MTBusinessesModel *> * businesses;
// > 类别
@property (nonatomic, strong) NSArray <NSString *> *categories;

// > 编辑状态
@property (nonatomic, assign, getter=isEditing) BOOL editing;
@property (nonatomic, assign, getter=isChecking) BOOL checking;
@end
