//
//  UIImage+ResizeImage.h
//  QQ聊天
//
//  Created by 李莎鑫 on 2016/11/20.
//  Copyright © 2016年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImage)

+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)scaleWithImageName:(NSString *)name toScale:(CGFloat) scale;
+ (UIImage *)sizeWithImageName:(NSString *)name toSize:(CGSize) size;
+ (UIImage *)sizeWithImage:(UIImage *)normal toSize:(CGSize) size;
+ (UIImage *)scaleWithImage:(UIImage *) normal toSize:(CGSize) size;
@end
