//
//  MTNetWorkRequestModel.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/22.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTNetWorkRequestModel : NSObject
// > 每页返回的数据
@property (nonatomic, assign) int limit;
// > 发送的请求的数量
@property (nonatomic, assign) int request_num;
// > 总数量
@property (nonatomic, assign) int total_num;
// > 页码
@property (nonatomic, assign) int page;
// > 总页数
@property (nonatomic, assign) int total_page;

@property (nonatomic, assign) BOOL clearData;
@end
