//
//  MTMapViewController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MTDealModel.h"
#import "MTCategoryModel.h"
#import "MTBusinessesModel.h"
#import "MTAnnotationModel.h"
#import "MTNavigationTopMenu.h"
#import "MTGategoryMenuDropDownController.h"
#import "MTHttpTool.h"

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "MJExtension.h"
#import "CommonDefine.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MTMapViewController ()<MKMapViewDelegate,MTNavigationTopMenuDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic, weak) MKMapView * mapView;
@property (nonatomic, weak) UIButton  * location;
@property (nonatomic, weak) MTNavigationTopMenu *menuCategory;
// > 位置管理者
@property (nonatomic, strong) CLLocationManager *locationManager;

// > 地理编码
@property (nonatomic , strong) CLGeocoder * Gcoder;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *category;


@property (nonatomic, weak)  DPRequest * lastRequest;

@end

@implementation MTMapViewController
static NSString * const reuseIdentifier = @"mapAnnotation";
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
        // > 8.0特性版本适配
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            // > 请求允许在前后台都能获取用户位置的授权
            [_locationManager requestAlwaysAuthorization];
            
            // > 9.0处于前台授权状态，默认是不可以后台获取用户位置
            if([[UIDevice currentDevice].systemVersion floatValue] >=9.0)
            {
                // > 需要打开Xcode -> Targets -> Capabilities 中的Background Modes并勾选其中的Location updates选项
//                _locationManager.allowsBackgroundLocationUpdates = YES;
            }
        }
    }
    return _locationManager;
}

- (CLGeocoder *)Gcoder{
    if(!_Gcoder){
        _Gcoder = [[CLGeocoder alloc] init];
    }
    return _Gcoder;
}



#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    //> 设置map view
    [self setupMapView];
    
    // Do any additional setup after loading the view.
}

- (void)setupMapView{
    // > 设置背景标题
    [self.view setBackgroundColor:MTGlobalBlackgroudColor];
    [self setTitle:@"地图"];
    
    // > 设置导航栏
    UIBarButtonItem *close = [UIBarButtonItem itemWithTarget:self action:@selector(closeMapView:) image:@"icon_back" highImage:@"icon_back_highlighted"];
//    close.customView.width = MTNavigationRightBarButtonItemWidth;
    
    // > 2.1 分类
    MTNavigationTopMenu *menuCategory= [MTNavigationTopMenu navigationTopMenuWithTitle:@"全部" andDetailTitle:@"全部分类" andImageIcon:@"icon_category_-1" andSelectedImageIcon:@"icon_category_highlighted_-1"];
    menuCategory.size = CGSizeMake(40, 35);
    menuCategory.delegate = self;
    menuCategory.dropMenuClass = [MTGategoryMenuDropDownController class];
    UIBarButtonItem *category = [[UIBarButtonItem alloc] initWithCustomView:menuCategory];
    self.menuCategory = menuCategory;
    
    self.navigationItem.leftBarButtonItems = @[close,category];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catergoryChanged:) name:MTCagtegoryChangedNotification object:nil];
    
    
    // > 设置mapView
    MKMapView * mapView = [[MKMapView alloc] init];
    [mapView setDelegate:self];
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    // > MKMapTypeStandard = 0, // 标准地图
    // > MKMapTypeSatellite, // 卫星云图
    // > MKMapTypeHybrid, // 混合(在卫星云图上加了标准地图的覆盖层)
    // > MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D立体
    // > MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D混合
    // > 设置地图显示样式(必须注意,设置时 注意对应的版本)
    self.mapView.mapType = MKMapTypeStandard;
//    // 显示建筑物
//    self.mapView.showsBuildings = YES;
//    // 指南针
    self.mapView.showsCompass = YES;
//    // 兴趣点
    self.mapView.showsPointsOfInterest = YES;
//    // 比例尺
    self.mapView.showsScale = YES;
//    // 交通
//    self.mapView.showsTraffic = YES;
    
    
// > 开始更新用户位置
    [self.locationManager startUpdatingLocation];;
    
//    // 显示用户位置, 但是地图并不会自动放大到合适比例
//    self.mapView.showsUserLocation = YES;
    
    // > 设置地图跟踪模式
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    // > 定位按钮
    UIButton * location = [UIButton buttonWithType:UIButtonTypeCustom];
    [location setImage:[UIImage imageNamed:@"icon_map_location"] forState:UIControlStateNormal];
    [location setImage:[UIImage imageNamed:@"icon_map_location_highlighted"] forState:UIControlStateHighlighted];
    [location addTarget:self action:@selector(locationToUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:location];
    self.location = location;
    
    
    
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.width.height.mas_equalTo(60);
    }];
}

- (void)closeMapView:(UIButton *) button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationToUser:(UIButton *) button{
    // 移动地图的中心,显示用户的当前位置
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
    // 显示地图的显示区域
    // 控制区域中心
    CLLocationCoordinate2D center = self.mapView.userLocation.location.coordinate;
    
    // 设置区域跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.077919, 0.044529);
    
    // 创建一个区域
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    // 设置地图显示区域
    [self.mapView setRegion:region animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTCagtegoryChangedNotification object:nil];
    
}

- (void)catergoryChanged:(NSNotification *) notification{
    
    // > 更新图标
    self.menuCategory.icon = notification.userInfo[MTIconCategorySelected];
    self.menuCategory.selectedIcon = notification.userInfo[MTIconHLCategorySelected];
    
    NSLog(@"icon: %@,hightlight icon: %@",notification.userInfo[MTIconCategorySelected],notification.userInfo[MTIconHLCategorySelected]);
    
    // > 更新标题
    self.menuCategory.titleText = notification.userInfo[MTMainCagtegorySelected];
    self.menuCategory.detailTitleText = notification.userInfo[MTSubCagtegorySelected];
    
    
    if([notification.userInfo[MTNotificationExit] isEqualToString:@"YES"]){
        if(![(NSString *)notification.userInfo[MTMainCagtegorySelected] containsString:@"全部"]){
            if([(NSString *)notification.userInfo[MTSubCagtegorySelected] containsString:@"全部"]){
                self.category = notification.userInfo[MTMainCagtegorySelected];
            }else{
                self.category = notification.userInfo[MTSubCagtegorySelected];
            }
        }else{
            self.category = nil;
        }
        
    }
    // > 移除原来的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    // > 发送网络请求数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

#pragma mark <MTNavigationTopMenuDelegate>

- (void)navigationTopMenu:(MTNavigationTopMenu *)menu didClickedWithButton:(UIButton *)button{
    
    
        UIViewController *popover = [[menu.dropMenuClass alloc] init];
    
        // > 弹出控制器的尺寸
            popover.preferredContentSize = CGSizeMake(280, 400);
        // > 禁止父控件view拉伸
        popover.view.autoresizingMask = UIViewAutoresizingNone;
        //        popover.view.size = popover.preferredContentSize;
        
        // > 设置弹出的控制器的显示样式
        popover.modalPresentationStyle = UIModalPresentationPopover;
        // > 弹出模式
        popover.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        // > 弹出控制器的箭头指向的view,barButtonItem
        popover.popoverPresentationController.sourceView = menu;
        
        // > 弹出视图的箭头的“尖”的坐标 - 以sourceView的（0，0，0，0）为基准结合sourceRect。系统默认width/2使用。（sender.bounds的位置即：在sender的底部边缘居中）
        popover.popoverPresentationController.sourceRect = menu.bounds;
        
        // > 弹出控制器的箭头指向的barButtonItem
        
        // > 箭头的指向（上，下，左，右）
        popover.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        
        popover.popoverPresentationController.delegate = self;
        
        [self presentViewController:popover animated:YES completion:nil];
    
}




#pragma mark - <MKMapViewDelegate>
/** 获取用户更新的位置 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    DebugLog(@"位置：----------------- %@",userLocation.location);
    
    // 移动地图的中心,显示用户的当前位置
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    // 显示地图的显示区域
    // 控制区域中心
    CLLocationCoordinate2D center = userLocation.location.coordinate;

    // 设置区域跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.077919, 0.044529);

    // 创建一个区域
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    // 设置地图显示区域
    [mapView setRegion:region animated:YES];
    
   
    // > 获取反地理编码
    [self.Gcoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // > 反地理编码失败
        if(error || !placemarks.count) return ;
        
        // > 地标
        CLPlacemark *placemark = [placemarks firstObject];
        
        // > 取得城市 placemark.locality 有时不靠谱（如特殊城市，北京市）
        NSString *city = placemark.locality ? placemark.locality : placemark.addressDictionary[@"state"];
        // > 删除最后一个字“市”
        self.city = [city substringToIndex:city.length - 1];
    }];
    
    
 
    userLocation.title = @"我在这啦";
    userLocation.subtitle = @"点我干吗😷？";
    

}

- (BOOL)region:(MKCoordinateRegion) region contentPoint:(CLLocationCoordinate2D) coordinate{
    CLLocationCoordinate2D lowLocation = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta * 0.5, region.center.longitude - region.span.longitudeDelta * 0.5);
    
    CLLocationCoordinate2D maxLocation = CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta * 0.5, region.center.longitude + region.span.longitudeDelta * 0.5);
    
    if(((coordinate.latitude > lowLocation.latitude)&&(coordinate.latitude < maxLocation.latitude))&&((coordinate.longitude > lowLocation.longitude)&&(coordinate.longitude < maxLocation.longitude))){
        return YES;
    }
    
    return NO;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    if(!self.city) return;
    
    // > 地图改变的时候获取服务器在地图中心点范围内的deal
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];

    params[@"city"] = self.city;
    
    if(self.category.length){
        params[@"category"] = self.category;
    }
    // > 地图中心点的经纬度
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    
    DebugLog(@"请求参数：%@",params);
    
    weak_self weakSelf = self;
    
    self.lastRequest = [[MTHttpTool sharedHttpTool] httpToolRequestWithURL:@"v1/deal/find_deals" params:params successWithResult:^(DPRequest *request,id result) {
        
        if(request != weakSelf.lastRequest) return;
        
          DebugLog(@"返回NetWork数据：%@",result);
        // > 获取deal信息
        if(result[@"deals"]){
            NSArray *deals = [MTDealModel objectArrayWithKeyValuesArray:result[@"deals"]];
            
            for(MTDealModel *deal in deals){
                
                MTCategoryModel *category = [MTCategoryModel categoryWithDeal:deal];
                
                for(MTBusinessesModel *model in deal.businesses){
                    // > 添加大头针
                    MTAnnotationModel *annotaion = [[MTAnnotationModel alloc] init];
                    annotaion.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
                    
                    // > 优化地图功能判断是否在区域内
                    if(![self region:self.mapView.region contentPoint:annotaion.coordinate])
                        continue;
                    
                    annotaion.title = model.name;
                    annotaion.subtitle = [NSString stringWithFormat:@"(城市：%@,ID：%d)",model.city,model.ID];
                    annotaion.image_url = deal.s_image_url;
                    // > 获取分类在地图中的icon
                    if(category){
                        annotaion.icon = category.map_icon;
                        annotaion.icon =@"map";
                    }else{
                        annotaion.icon =@"map";
                    }
                    

                    // > 判断是否重复
                    if([weakSelf.mapView.annotations containsObject:annotaion]) continue;
                    
                    [weakSelf.mapView addAnnotation:annotaion];
                    
                }
            }
        }

    } failWithError:^(DPRequest *request,NSError *error) {
        if(request != weakSelf.lastRequest) return;
        
        DebugLog(@"加载数据失败,error:%@",error);
    }];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(![annotation isKindOfClass:[MTAnnotationModel class]]) return nil;
    
    // > 创建大头针控件
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:reuseIdentifier];
    }
    
    // > 设置模型
    annotationView.annotation = annotation;
    
    // > 设置图片
    annotationView.image = [UIImage imageNamed:((MTAnnotationModel *)annotation).icon];
    annotationView.canShowCallout = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.size = CGSizeMake(100, 80);
    [imageView sd_setImageWithURL:[NSURL URLWithString:((MTAnnotationModel *)annotation).image_url ] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    annotationView.detailCalloutAccessoryView = imageView;
    
    return annotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UIPopoverPresentationControllerDelegate>

// > 实现代理方法iPhone上也可以以pop的显示方式显示控制器了.
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller{
    // > 返回UIModalPresentationNone为不匹配
    return UIModalPresentationNone;
}

@end
