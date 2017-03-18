//
//  LTHomeViewController.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/17.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTHomeViewController.h"
#import "LTNavigationController.h"
#import "LTSearchViewController.h"
#import "LTCollectViewController.h"
#import "LTHistoryViewController.h"
#import "LTMapViewController.h"
#import "LTGategoryMenuDropDownController.h"
#import "LTDistrictMenuDropDownController.h"
#import "LTSortDropMenuController.h"
#import "UIBarButtonItem+Extension.h"
#import "LTNavigationTopMenu.h"
#import "UIView+Extension.h"
#import "CommonDefine.h"
#import "AwesomeMenu.h"
#import "Masonry.h"


@interface LTHomeViewController ()<LTNavigationTopMenuDelegate,UIPopoverPresentationControllerDelegate,AwesomeMenuDelegate>
@property (nonatomic, weak)UIButton *selectedButton;
@property (nonatomic, weak) UIViewController *oldPopover;

@property (nonatomic, weak) LTNavigationTopMenu *menuCategory;
@property (nonatomic, weak) LTNavigationTopMenu *menuDistrict;
@property (nonatomic, weak) LTNavigationTopMenu *menuSort;

@end

@implementation LTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations

    
    // > 设置导航栏
    [self setNavgationbarItems];

    
    // > 设置悬浮工具栏
    [self setupAwesomeMenu];

    // > 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:LTCityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortChanged:) name:LTSortChangedNotification object:nil];
    
    // > 跟新显示界面
    [self prepareDataForDropMenu];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LTCityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LTSortChangedNotification object:nil];
    


}

#pragma mark - 解决两个控制器不同时监听分别监听通知的问题
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(catergoryChanged:) name:LTCagtegoryChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LTCagtegoryChangedNotification object:nil];
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
            LTNavigationController *controller = [[LTNavigationController alloc] initWithRootViewController:[[LTCollectViewController alloc] init]];
            [self presentViewController:controller animated:YES completion:nil];
        }break;
        case 2:{
            LTNavigationController *controller = [[LTNavigationController alloc] initWithRootViewController:[[LTHistoryViewController alloc] init]];
            [self presentViewController:controller animated:YES completion:nil];
        }break;
        default:
            break;
    }

}

#pragma mark - 通知相关
- (void)cityChanged:(NSNotification *) notification{
    // > 如果当前城市不包含改动后的城市
    

//    self.menuDistrict.titleText = [NSString stringWithFormat:@"%@-%@",notification.userInfo[LTSelectedCity],notification.userInfo[LTSelectedRegion]];

//    self.menuDistrict.detailTitleText = notification.userInfo[LTSelectedSubRegion];
   
    if([notification.userInfo[LTNotificationExit] isEqualToString:@"YES"]){
        // > 清空
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        
    }
    
    LTNetWorkParamsModel *data =[LTNetWorkParamsModel sharedParamsModel];
    data.keyword = nil;
    data.region = nil;
    
    // > 发送网络请求数据
    if(![data.city isEqualToString:notification.userInfo[LTSelectedCity]] || [notification.userInfo[LTNotificationExit] isEqualToString:@"YES"]){
         data.city = notification.userInfo[LTSelectedCity];
        if(![(NSString *)notification.userInfo[LTSelectedRegion] containsString:@"全部"]){
            if([(NSString *)notification.userInfo[LTSelectedSubRegion] containsString:@"全部"]){
                data.region = notification.userInfo[LTSelectedRegion];
            }else{
                data.region = notification.userInfo[LTSelectedSubRegion];
            }
        }
        
        // > 加载网络数据
        [self loadDealsFromNetWork:data];
    }
    
}

- (void)sortChanged:(NSNotification *) notification{
    
    // > 更新标题
//    self.menuSort.detailTitleText = notification.userInfo[LTSortSelected];
    
    LTNetWorkParamsModel *data =[LTNetWorkParamsModel sharedParamsModel];
    data.keyword = nil;
    
    if([notification.userInfo[LTNotificationExit] isEqualToString:@"YES"]){
        // > 清空
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        
        // > 发送网络请求数据
        data.sort = [notification.userInfo[LTSortVaule] intValue];
        [self loadDealsFromNetWork:data];
    }
    
}

- (void)catergoryChanged:(NSNotification *) notification{
    
    // > 更新图标
    self.menuCategory.icon = notification.userInfo[LTIconCategorySelected];
    self.menuCategory.selectedIcon = notification.userInfo[LTIconHLCategorySelected];
    
    NSLog(@"icon: %@,hightlight icon: %@",notification.userInfo[LTIconCategorySelected],notification.userInfo[LTIconHLCategorySelected]);
    
    // > 更新标题
//    self.menuCategory.titleText = notification.userInfo[LTMainCagtegorySelected];
//    self.menuCategory.detailTitleText = notification.userInfo[LTSubCagtegorySelected];

    LTNetWorkParamsModel *data =[LTNetWorkParamsModel sharedParamsModel];
    data.keyword = nil;
    
    if([notification.userInfo[LTNotificationExit] isEqualToString:@"YES"]){
        // > 清空
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        
        // > 发送网络请求数据
        if(![(NSString *)notification.userInfo[LTMainCagtegorySelected] containsString:@"全部"]){
            if([(NSString *)notification.userInfo[LTSubCagtegorySelected] containsString:@"全部"]){
                data.category = notification.userInfo[LTMainCagtegorySelected];
            }else{
                data.category = notification.userInfo[LTSubCagtegorySelected];
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
//    map.customView.width = LTNavigationRightBarButtonItemWidth;
    
    UIBarButtonItem *search = [UIBarButtonItem itemWithTarget:self action:@selector(searchDeals) image:@"icon_search" highImage:@"icon_search_highlighted"];
//    search.customView.width = LTNavigationRightBarButtonItemWidth;
    
    self.navigationItem.rightBarButtonItems = @[map,search];
    
    // > 左边按钮
    UIBarButtonItem *logo = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_letuan_logo" highImage:@"icon_letuan_logo"];
    
    // > 2.1 分类
    LTNavigationTopMenu *menuCategory= [LTNavigationTopMenu navigationTopMenuWithTitle:@"全部" andDetailTitle:@"全部分类" andImageIcon:@"icon_category_-1" andSelectedImageIcon:@"icon_category_highlighted_-1"];
    menuCategory.size = CGSizeMake(40, 35);
    menuCategory.delegate = self;
    menuCategory.dropMenuClass = [LTGategoryMenuDropDownController class];
    UIBarButtonItem *category = [[UIBarButtonItem alloc] initWithCustomView:menuCategory];
    self.menuCategory = menuCategory;
    
    // > 2.2 地区
    LTNavigationTopMenu *menuDistrict= [LTNavigationTopMenu navigationTopMenuWithTitle:@"广州-天河区" andDetailTitle:@"全部" andImageIcon:@"icon_district" andSelectedImageIcon:@"icon_district_highlighted"];
    menuDistrict.size = CGSizeMake(40, 35);
    menuDistrict.delegate = self;
    menuDistrict.dropMenuClass = [LTDistrictMenuDropDownController class];
    UIBarButtonItem *district = [[UIBarButtonItem alloc] initWithCustomView:menuDistrict];
    self.menuDistrict = menuDistrict;
    
    // > 2.3 排序
    LTNavigationTopMenu *menuSort= [LTNavigationTopMenu navigationTopMenuWithTitle:@"排序" andDetailTitle:@"人气最高" andImageIcon:@"icon_sort" andSelectedImageIcon:@"icon_sort_highlighted"];
    menuSort.size = CGSizeMake(40, 35);
    menuSort.delegate = self;
    menuSort.dropMenuClass = [LTSortDropMenuController class];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithCustomView:menuSort];
    self.menuSort = menuSort;
    
    self.navigationItem.leftBarButtonItems = @[logo,category,district,sort];
}

#pragma mark - <Navigation item click>

- (void)mapClick{
    LTNavigationController *controller = [[LTNavigationController alloc] initWithRootViewController:[[LTMapViewController alloc] init]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)searchDeals{
    LTNavigationController *controller = [[LTNavigationController alloc] initWithRootViewController:[[LTSearchViewController alloc] init]];
    
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark <LTNavigationTopMenuDelegate>

- (void)navigationTopMenu:(LTNavigationTopMenu *)menu didClickedWithButton:(UIButton *)button{
    
    if(![self.selectedButton isEqual:button]){
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
        
        UIViewController *popover = [[menu.dropMenuClass alloc] init];
        
        if([popover isKindOfClass:[LTSortDropMenuController class]]){
            // > 弹出控制器的尺寸
            popover.preferredContentSize = CGSizeMake(120, 330);
        }else if([popover isKindOfClass:[LTDistrictMenuDropDownController class]])
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
            if([item.customView isKindOfClass:[LTNavigationTopMenu class]]){
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
  [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city,LTSelectedRegion:region,LTSelectedSubRegion:subregion,LTNotificationExit:@"NO",LTNotificationInit:@"YES"}];
    
    // > 排序
    NSString *sortName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sortName"];
    
    if(!sortName.length){
       sortName = @"默认排序";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LTSortChangedNotification object:nil userInfo:@{ LTSortSelected : sortName,LTNotificationExit :@"NO"}];
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
