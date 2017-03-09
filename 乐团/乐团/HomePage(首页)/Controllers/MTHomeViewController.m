//
//  MTHomeViewController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTNavigationController.h"
#import "MTSearchViewController.h"
#import "MTCollectViewController.h"
#import "MTHistoryViewController.h"
#import "MTMapViewController.h"
#import "MTGategoryMenuDropDownController.h"
#import "MTDistrictMenuDropDownController.h"
#import "MTSortDropMenuController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTNavigationTopMenu.h"
#import "UIView+Extension.h"
#import "CommonDefine.h"
#import "AwesomeMenu.h"
#import "Masonry.h"


@interface MTHomeViewController ()<MTNavigationTopMenuDelegate,UIPopoverPresentationControllerDelegate,AwesomeMenuDelegate>
@property (nonatomic, weak)UIButton *selectedButton;
@property (nonatomic, weak) UIViewController *oldPopover;

@property (nonatomic, weak) MTNavigationTopMenu *menuCategory;
@property (nonatomic, weak) MTNavigationTopMenu *menuDistrict;
@property (nonatomic, weak) MTNavigationTopMenu *menuSort;

@end

@implementation MTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations

    
    // > 设置导航栏
    [self setNavgationbarItems];

    
    // > 设置悬浮工具栏
    [self setupAwesomeMenu];

    // > 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:MTCityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortChanged:) name:MTSortChangedNotification object:nil];
    
    // > 跟新显示界面
    [self prepareDataForDropMenu];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTCityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTSortChangedNotification object:nil];
    


}

#pragma mark - 解决两个控制器不同时监听分别监听通知的问题
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catergoryChanged:) name:MTCagtegoryChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTCagtegoryChangedNotification object:nil];
}

- (void)setupAwesomeMenu{
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenuItem *Item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    AwesomeMenuItem *Item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *Item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    AwesomeMenuItem *Item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:@[Item0,Item1,Item2,Item3]];
    menu.menuWholeAngle = M_PI_2;
    menu.rotateAddButton = NO;
    menu.startPoint = CGPointMake(50,150);
    menu.delegate = self;
    menu.alpha = 0.3;
    [self.view addSubview:menu];
    
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}

#pragma mark - <AwesomeMenuDelegate>
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    menu.alpha = 1.0;
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.3;
}
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    // > 更改mainMenu图标
    [self awesomeMenuWillAnimateClose:menu];
    
    // > 切换控制器
    switch (idx) {
        case 1:
        {
            MTNavigationController *controller = [[MTNavigationController alloc] initWithRootViewController:[[MTCollectViewController alloc] init]];
            [self presentViewController:controller animated:YES completion:nil];
        }break;
        case 2:{
            MTNavigationController *controller = [[MTNavigationController alloc] initWithRootViewController:[[MTHistoryViewController alloc] init]];
            [self presentViewController:controller animated:YES completion:nil];
        }break;
        default:
            break;
    }

}

#pragma mark - 通知相关
- (void)cityChanged:(NSNotification *) notification{
    // > 如果当前城市不包含改动后的城市
    

//    self.menuDistrict.titleText = [NSString stringWithFormat:@"%@-%@",notification.userInfo[MTSelectedCity],notification.userInfo[MTSelectedRegion]];

//    self.menuDistrict.detailTitleText = notification.userInfo[MTSelectedSubRegion];
   
    if([notification.userInfo[MTNotificationExit] isEqualToString:@"YES"]){
        // > 清空
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        
    }
    
    MTNetWorkParamsModel *data =[MTNetWorkParamsModel sharedParamsModel];
    data.keyword = nil;
    data.region = nil;
    
    // > 发送网络请求数据
    if(![data.city isEqualToString:notification.userInfo[MTSelectedCity]] || [notification.userInfo[MTNotificationExit] isEqualToString:@"YES"]){
         data.city = notification.userInfo[MTSelectedCity];
        if(![(NSString *)notification.userInfo[MTSelectedRegion] containsString:@"全部"]){
            if([(NSString *)notification.userInfo[MTSelectedSubRegion] containsString:@"全部"]){
                data.region = notification.userInfo[MTSelectedRegion];
            }else{
                data.region = notification.userInfo[MTSelectedSubRegion];
            }
        }
        
        // > 加载网络数据
        [self loadDealsFromNetWork:data];
    }
    
}

- (void)sortChanged:(NSNotification *) notification{
    
    // > 更新标题
//    self.menuSort.detailTitleText = notification.userInfo[MTSortSelected];
    
    MTNetWorkParamsModel *data =[MTNetWorkParamsModel sharedParamsModel];
    data.keyword = nil;
    
    if([notification.userInfo[MTNotificationExit] isEqualToString:@"YES"]){
        // > 清空
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        
        // > 发送网络请求数据
        data.sort = [notification.userInfo[MTSortVaule] intValue];
        [self loadDealsFromNetWork:data];
    }
    
}

- (void)catergoryChanged:(NSNotification *) notification{
    
    // > 更新图标
    self.menuCategory.icon = notification.userInfo[MTIconCategorySelected];
    self.menuCategory.selectedIcon = notification.userInfo[MTIconHLCategorySelected];
    
    NSLog(@"icon: %@,hightlight icon: %@",notification.userInfo[MTIconCategorySelected],notification.userInfo[MTIconHLCategorySelected]);
    
    // > 更新标题
//    self.menuCategory.titleText = notification.userInfo[MTMainCagtegorySelected];
//    self.menuCategory.detailTitleText = notification.userInfo[MTSubCagtegorySelected];

    MTNetWorkParamsModel *data =[MTNetWorkParamsModel sharedParamsModel];
    data.keyword = nil;
    
    if([notification.userInfo[MTNotificationExit] isEqualToString:@"YES"]){
        // > 清空
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        
        // > 发送网络请求数据
        if(![(NSString *)notification.userInfo[MTMainCagtegorySelected] containsString:@"全部"]){
            if([(NSString *)notification.userInfo[MTSubCagtegorySelected] containsString:@"全部"]){
                data.category = notification.userInfo[MTMainCagtegorySelected];
            }else{
                data.category = notification.userInfo[MTSubCagtegorySelected];
            }
        }else{
                data.category = nil;
        }

        // > 加载数据
        [self loadDealsFromNetWork:data];
    }
    
}


#pragma mark - 导航栏相关
- (void)setNavgationbarItems{
    
    // > 右边按钮
    UIBarButtonItem *map = [UIBarButtonItem itemWithTarget:self action:@selector(mapClick) image:@"icon_map" highImage:@"icon_map_highlighted"];
//    map.customView.width = MTNavigationRightBarButtonItemWidth;
    
    UIBarButtonItem *search = [UIBarButtonItem itemWithTarget:self action:@selector(searchDeals) image:@"icon_search" highImage:@"icon_search_highlighted"];
//    search.customView.width = MTNavigationRightBarButtonItemWidth;
    
    self.navigationItem.rightBarButtonItems = @[map,search];
    
    // > 左边按钮
    UIBarButtonItem *logo = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_letuan_logo" highImage:@"icon_letuan_logo"];
    
    // > 2.1 分类
    MTNavigationTopMenu *menuCategory= [MTNavigationTopMenu navigationTopMenuWithTitle:@"全部" andDetailTitle:@"全部分类" andImageIcon:@"icon_category_-1" andSelectedImageIcon:@"icon_category_highlighted_-1"];
    menuCategory.size = CGSizeMake(40, 35);
    menuCategory.delegate = self;
    menuCategory.dropMenuClass = [MTGategoryMenuDropDownController class];
    UIBarButtonItem *category = [[UIBarButtonItem alloc] initWithCustomView:menuCategory];
    self.menuCategory = menuCategory;
    
    // > 2.2 地区
    MTNavigationTopMenu *menuDistrict= [MTNavigationTopMenu navigationTopMenuWithTitle:@"广州-天河区" andDetailTitle:@"全部" andImageIcon:@"icon_district" andSelectedImageIcon:@"icon_district_highlighted"];
    menuDistrict.size = CGSizeMake(40, 35);
    menuDistrict.delegate = self;
    menuDistrict.dropMenuClass = [MTDistrictMenuDropDownController class];
    UIBarButtonItem *district = [[UIBarButtonItem alloc] initWithCustomView:menuDistrict];
    self.menuDistrict = menuDistrict;
    
    // > 2.3 排序
    MTNavigationTopMenu *menuSort= [MTNavigationTopMenu navigationTopMenuWithTitle:@"排序" andDetailTitle:@"人气最高" andImageIcon:@"icon_sort" andSelectedImageIcon:@"icon_sort_highlighted"];
    menuSort.size = CGSizeMake(40, 35);
    menuSort.delegate = self;
    menuSort.dropMenuClass = [MTSortDropMenuController class];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithCustomView:menuSort];
    self.menuSort = menuSort;
    
    self.navigationItem.leftBarButtonItems = @[logo,category,district,sort];
}

#pragma mark - <Navigation item click>

- (void)mapClick{
    MTNavigationController *controller = [[MTNavigationController alloc] initWithRootViewController:[[MTMapViewController alloc] init]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)searchDeals{
    MTNavigationController *controller = [[MTNavigationController alloc] initWithRootViewController:[[MTSearchViewController alloc] init]];
    
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark <MTNavigationTopMenuDelegate>

- (void)navigationTopMenu:(MTNavigationTopMenu *)menu didClickedWithButton:(UIButton *)button{
    
    if(![self.selectedButton isEqual:button]){
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
        
        UIViewController *popover = [[menu.dropMenuClass alloc] init];
        
        if([popover isKindOfClass:[MTSortDropMenuController class]]){
            // > 弹出控制器的尺寸
            popover.preferredContentSize = CGSizeMake(120, 330);
        }else if([popover isKindOfClass:[MTDistrictMenuDropDownController class]])
            // > 弹出控制器的尺寸
            popover.preferredContentSize = CGSizeMake(240, 400);
        else{
            // > 弹出控制器的尺寸
            popover.preferredContentSize = CGSizeMake(280, 400);
        }
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
        
        // > 过滤popover点击
        NSMutableArray *array = [NSMutableArray array];
        for(UIBarButtonItem *item in self.navigationItem.leftBarButtonItems){
            if([item.customView isKindOfClass:[MTNavigationTopMenu class]]){
                [array addObject:item.customView];
            }
        }
        popover.popoverPresentationController.passthroughViews = array;
        
        // > dismis旧的界面
        [self.oldPopover dismissViewControllerAnimated:NO completion:nil];
        
        popover.popoverPresentationController.delegate = self;
        
        
        [self presentViewController:popover animated:YES completion:nil];
        self.oldPopover = popover;
        

    
        
    }
}


- (void)prepareDataForDropMenu{

    // > 地区

  NSString *city = @"广州";
  NSString *region = @"天河区";
  NSString *subregion = @"珠江新城";

    
    // > 初始化选择
  [[NSNotificationCenter defaultCenter] postNotificationName:MTCityChangedNotification object:nil userInfo:@{ MTSelectedCity:city,MTSelectedRegion:region,MTSelectedSubRegion:subregion,MTNotificationExit:@"NO",MTNotificationInit:@"YES"}];
    
    // > 排序
    NSString *sortName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sortName"];
    
    if(!sortName.length){
       sortName = @"默认排序";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTSortChangedNotification object:nil userInfo:@{ MTSortSelected : sortName,MTNotificationExit :@"NO"}];
}

#pragma mark - <UIPopoverPresentationControllerDelegate>

// > 实现代理方法iPhone上也可以以pop的显示方式显示控制器了.
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller{
    // > 返回UIModalPresentationNone为不匹配
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    // > 清空
    self.selectedButton.selected = NO;
    self.selectedButton = nil;
    return YES;
}


@end
