//
//  LTAnnotationModel.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/28.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LTAnnotationModel : NSObject <MKAnnotation>
// > 地理位置经纬坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
// > 大头针标题
@property (nonatomic, copy) NSString * title;
// > 大头针副标题
@property (nonatomic, copy) NSString * subtitle;
// > 大头针icon
@property (nonatomic, copy) NSString * icon;
// > 图片
@property (nonatomic, copy) NSString * image_url;
@end
