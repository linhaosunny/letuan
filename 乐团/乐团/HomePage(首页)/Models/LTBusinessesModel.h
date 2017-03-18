//
//  LTBusinessesModel.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTBusinessesModel : NSObject
// > 商户名称
@property (nonatomic, copy) NSString * name;
// > 商户id
@property (nonatomic, assign) int ID;
// > 商户所在的城市
@property (nonatomic, copy) NSString * city;
// > 商户地址坐标
@property (nonatomic, assign) float latitude;
// > 商户地址坐标
@property (nonatomic, assign) float longitude;
// > 商户网页链接
@property (nonatomic, copy) NSString * url;
// > 商户移动端链接
@property (nonatomic, copy) NSString * h5_url;
@end
