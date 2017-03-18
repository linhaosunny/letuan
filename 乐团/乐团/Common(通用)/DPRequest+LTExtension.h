//
//  DPRequest+LTExtension.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "DPRequest.h"
typedef void(^SuccessBlock)(DPRequest *request,id result);
typedef void(^FailBlock)(DPRequest *request,NSError * error);

@interface DPRequest (LTExtension)
@property (nonatomic, copy) SuccessBlock success_block;
@property (nonatomic, copy) FailBlock fail_block;
@end
