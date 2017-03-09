//
//  MTHttpTool.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTHttpTool.h"
#import "DPRequest+MTExtension.h"
#import "DPAPI.h"


@interface MTHttpTool ()<DPRequestDelegate>

@property (nonatomic, strong)  DPAPI * api;

@end

@implementation MTHttpTool

// 声明一个全局对象
static id _instance;

// 实现创建单例对象的类方法
+ (instancetype)sharedHttpTool{
    
    static dispatch_once_t onceToken;
    
    /**
     dispatch_once  一次性执行
     它是安全的，系统已经自动帮我们加了锁，所以在多个线程抢夺同一资源的时候，也是安全的
     */
    
    dispatch_once(&onceToken, ^{
        
        // 这里也会调用到 allocWithZone 方法
        _instance = [[self alloc] init];
        ((MTHttpTool *)_instance).api = [[DPAPI alloc] init];
    });
    return _instance;
}

#warning 一般单例直接share，但是写上 copy 和 alloc 更加严谨
// 利用alloc 创建对象也要返回单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
#warning 这里必须调用父类的方法，把空间传给父类，让父类进行空间的分配，若还用[[self allic] init] 则会产生死循环
        _instance = [super allocWithZone:zone];
       
    });
    
    return _instance;
}

// 遵守NSCopying 协议,ios7 以后不遵守也可以
- (id)copyWithZone:(NSZone *)zone {
    
    // 这里直接返回对象，因为既然是赋值，说明已经通过上面两种方式之一开始创建了
    return _instance;
}


- (DPRequest *)httpToolRequestWithURL:(NSString *) url params:(NSMutableDictionary *) params successWithResult:(void (^)(DPRequest *request,id result)) success_block failWithError:(void (^)(DPRequest *request,NSError * error)) fail_block{
  
    DPRequest * request = [self.api requestWithURL:url params:params delegate:self];
    request.success_block = success_block;
    request.fail_block = fail_block;
    return request;
}

#pragma mark - <DPRequestDelegate>
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    if(request.success_block){
        request.success_block(request,result);
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    if(request.fail_block){
        request.fail_block(request,error);
    }
}
@end
