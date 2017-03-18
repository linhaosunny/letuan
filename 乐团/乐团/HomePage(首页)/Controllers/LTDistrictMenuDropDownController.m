//
//  LTDistrictMenuDropDownController.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDistrictMenuDropDownController.h"
#import "LTNavigationController.h"
#import "LTCityChangeController.h"
#import "LTCitiesModel.h"
#import "LTRegionModel.h"
#import "LTDropMenuTopBar.h"
#import "LTDropMenuMainCell.h"
#import "LTDropMenuSubCell.h"
#import "UIView+Extension.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "CommonDefine.h"


@interface LTDistrictMenuDropDownController ()<LTHomeMenuDropDownControllerDelegate>

@property (nonatomic, weak) LTDropMenuTopBar *topView;
@property (nonatomic, weak) UITableViewCell *leftSelectedCell;
@property (nonatomic, strong) NSArray *city;

@property (nonatomic, strong) NSArray *categorys;
@end

@implementation LTDistrictMenuDropDownController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // > 设置顶部工具条
    [self setupDropMenuTopView];
    
    // > 设置数据源与代理方法
    [self.leftView setDelegate:self];
    [self.leftView setDataSource:self];
    [self.rightView setDataSource:self];
    [self.rightView setDelegate:self];
    
    // > 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:LTCityChangedNotification object:nil];
    // > 设置代理
    self.delegate = self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LTCityChangedNotification object:nil];
}

- (void)cityChanged:(NSNotification *) notification{

    if([notification.userInfo[LTNotificationExit] isEqualToString:@"NO"]){
        // > 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ ",notification.userInfo[LTSelectedCity]];
        
        self.city = [[LTCitiesModel cities] filteredArrayUsingPredicate:predicate];
        
        // > 更新数据源
        if([(NSString *)notification.userInfo[LTSelectedRegion] containsString:@"全部"]||[notification.userInfo[LTNotificationExit] isEqualToString:@"YES"]){
            [self.leftView reloadData];
        }
    }else {
        // > 退出
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupDropMenuTopView{
    LTDropMenuTopBar *topView = [LTDropMenuTopBar dropMenuTopBarWithTitle:@"切换城市" andImageIcon:@"btn_changeCity" andSelectedImageIcon:@"btn_changeCity_selected" andRightIcon:@"icon_cell_rightArrow" andTarget:self action:@selector(changeCity:)];

    [self.view addSubview:topView];
    self.topView = topView;
}

/** 切换城市，model 一个带导航栏的控制器*/
- (void)changeCity:(UIButton *) button{
    LTNavigationController *controller = [[LTNavigationController alloc] initWithRootViewController:[[LTCityChangeController alloc] init]];
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:controller animated:YES completion:nil];
}

/** 重写父类该布局方法*/
- (void)setupSubViewsConstraints{
    
       weak_self weakSelf = self;
    // > 顶部工具条布局
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.view.mas_top);
        make.width.mas_equalTo(44);
    }];
    
/** 重新布局父类控件*/
    // > 左边布局
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(weakSelf.view.width*0.5);
    }];
    
    // > 右边布局
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftView.mas_right);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}
#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.leftView]){
        LTCitiesModel *model = self.city[section];
        return model.regions.count;
    }else {
        LTCitiesModel *city = self.city[section];
        
        LTRegionModel *model = city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        
        return model.subregions.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = nil;
    
    // > 主表cell加载
    if([tableView isEqual:self.leftView]){
        cell = [LTDropMenuMainCell dropMenuMainCell:tableView];
        
        LTCitiesModel *model = self.city[indexPath.section];
        
        if([model.regions[indexPath.row] isKindOfClass:[LTRegionModel class]]){
            LTRegionModel *region = model.regions[indexPath.row];
            cell.textLabel.text = region.name;
            
            if(region.subregions.count){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            cell.textLabel.text = model.regions[indexPath.row];
        }
        
    }else{
        cell = [LTDropMenuSubCell dropMenuSubCell:tableView];
        
         LTCitiesModel *city = self.city[indexPath.section];
        
        LTRegionModel *model = city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        
        if(model.subregions.count){
            cell.textLabel.text = model.subregions[indexPath.row];
        }
      
    }
    
    return cell;
}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:self.leftView]){

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
        
        // > 判断子地区是否存在
        LTCitiesModel *city = self.city[indexPath.section];
        
        if([city.regions[[self.leftView indexPathForCell:cell].row] isKindOfClass:[LTRegionModel class]]){
            
            LTRegionModel *model = city.regions[[self.leftView indexPathForCell:cell].row];
            
            if(!model.subregions.count){
                // > 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city.name,LTSelectedRegion:model.name,LTSelectedSubRegion:((LTRegionModel *)city.regions[0]).name,LTNotificationExit:@"YES"}];
            }else{
//                // > 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city.name,LTSelectedRegion:model.name,LTSelectedSubRegion:((LTRegionModel *)city.regions[0]).name,LTNotificationExit:@"NO",LTNotificationInit:@"NO"}];
            }
            
        }else{
            // > 发送通知
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city.name,LTSelectedRegion:city.regions[[self.leftView indexPathForCell:cell].row],LTSelectedSubRegion:((LTRegionModel *)city.regions[0]).name,LTNotificationExit:@"YES"}];

        }
        
         self.leftSelectedCell = cell;
        
        // > 显示子分类
        [self.rightView reloadData];
    }else{
        
        LTCitiesModel *city = self.city[indexPath.section];
        
         if([city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row] isKindOfClass:[LTRegionModel class]]){
             
             LTRegionModel *model = city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row];
             
             if(model.subregions.count){
                // > 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city.name,LTSelectedRegion:model.name,LTSelectedSubRegion:model.subregions[indexPath.row],LTNotificationExit:@"YES"}];
                
             }
         }
    }
}

#pragma mark - <LTHomeMenuDropDownControllerDelegate>

- (void)homeMenuDropDownController:(LTHomeMenuDropDownController *)controller didTouchRightTableViewWithSpaceArea:(UITableView *)rightView{
    // > 点击右边空白区域退出
    DebugLog(@"点击右边空白区域退出");
    
    LTCitiesModel *city = [self.city lastObject];
   
    // > 解决下拉菜单为选中城市点击右边crash的问题
    if(city == nil) return;
    
    if(self.leftSelectedCell){
        LTRegionModel *model = city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row] ;
        // > 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city.name,LTSelectedRegion:model.name,LTSelectedSubRegion:((LTRegionModel *)city.regions[0]).name,LTNotificationExit:@"YES"}];
    }else{
        
        // > 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:city.name,LTSelectedRegion:@"全部地区",LTSelectedSubRegion:@"全部",LTNotificationExit:@"YES"}];
    }
}

/** 分组标题 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([tableView isEqual:self.leftView]){
        LTCitiesModel *model = self.city[section];
        return model.name;
    }else{
        LTCitiesModel *city = self.city[section];
        
        if([city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row] isKindOfClass:[LTRegionModel class]]){
            LTRegionModel *model = city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row];
            return model.name;
        }else{
            return city.regions[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
