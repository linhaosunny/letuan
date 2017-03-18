//
//  LTHttpTool.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DPRequest;

@interface LTHttpTool : NSObject

+ (instancetype)sharedHttpTool;
- (DPRequest *)httpToolRequestWithURL:(NSString *) url params:(NSMutableDictionary *) params successWithResult:(void (^)(DPRequest *request,id result)) success_block failWithError:(void (^)(DPRequest *request,NSError * error)) fail_block;
@end
