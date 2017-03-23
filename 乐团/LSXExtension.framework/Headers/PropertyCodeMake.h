//
//  PropertyCodeMake.h
//  LSXExtension
//
//  Created by 李莎鑫 on 2017/3/22.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PropertyCodeMake : NSObject

// > 将plist文件生成代码中的模型文件
+ (void)propertyCodeMakeWithPlist:(NSString *)name andDataKey:(NSString *) dataKey andModelName:(NSString *) model andOutFilePath:(NSString *) outPath;

// > 将字典数组转成模型文件
+ (void)propertyCodeMakeWithDictionaryArray:(NSArray *)array andModelName:(NSString *) modelName andOutFilePath:(NSString *) outPath;

// > 将字典转成模型文件
+ (void)propertyCodeMakeWithDictionary:(NSDictionary *)dictionary andModelName:(NSString *) modelName andOutFilePath:(NSString *) outPath;
@end
