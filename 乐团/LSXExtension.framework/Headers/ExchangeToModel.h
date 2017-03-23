//
//  ExchangeToModel.h
//  LSXExtension
//
//  Created by 李莎鑫 on 2017/3/22.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeToModel : NSObject

+ (NSArray *)model:(Class) objectClass withPlistFile:(NSString *)name andDataKey:(NSString *) dataKey;
+ (NSArray *)model:(Class) objectClass withDictonaryArray:(NSArray *)array;
@end
