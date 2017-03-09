//
//  UIImage+ResizeImage.m
//  QQ聊天
//
//  Created by 李莎鑫 on 2016/11/20.
//  Copyright © 2016年 李莎鑫. All rights reserved.
//

#import "UIImage+ResizeImage.h"

@implementation UIImage (ResizeImage)

//图片从中间拉开
+ (UIImage *)resizeWithImageName:(NSString *)name{
    UIImage *normal = [UIImage imageNamed:name];
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(normal.size.height* 0.5f, normal.size.width*0.5f, normal.size.height * 0.5f , normal.size.width * 0.5f)];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImage:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}



//缩放图片
+ (UIImage *)scaleWithImageName:(NSString *)name toScale:(CGFloat) scale{
    UIImage *normal = [UIImage imageNamed:name];
    CGSize size = CGSizeMake(normal.size.width*scale, normal.size.height*scale);
    UIGraphicsBeginImageContext(size);
    
    [normal drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

//缩放图片
+ (UIImage *)scaleWithImage:(UIImage *)normal toScale:(CGFloat) scale{
    CGSize size = CGSizeMake(normal.size.width*scale, normal.size.height*scale);
    UIGraphicsBeginImageContext(size);
    
    [normal drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

//缩放图片
+ (UIImage *)sizeWithImageName:(NSString *)name toSize:(CGSize) size{
    UIImage *normal = [UIImage imageNamed:name];
    CGSize currentSize = CGSizeMake(size.width, size.height);
    UIGraphicsBeginImageContext(currentSize);
    
    [normal drawInRect:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    UIImage *scaleImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

//缩放图片
+ (UIImage *)sizeWithImage:(UIImage *)normal toSize:(CGSize) size{
    CGSize currentSize = CGSizeMake(size.width, size.height);
    UIGraphicsBeginImageContext(currentSize);
    
    [normal drawInRect:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    UIImage *scaleImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}
@end
