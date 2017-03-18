//
//  LTCityChangeController.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTCityChangeController.h"
#import "UIBarButtonItem+Extension.h"
#import "LTCitySearhResultController.h"
#import "UIView+Extension.h"
#import "LTCityGroupsModel.h"
#import "MJExtension.h"
#import "CommonDefine.h"
#import "Masonry.h"

@interface LTCityChangeController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *cover;
@property (nonatomic, weak) LTCitySearhResultController *searchResult;


@property (nonatomic, strong) NSArray *cityGroups;

@end

static NSString * const ID = @"city";

@implementation LTCityChangeController



- (NSArray *)cityGroups{
    if(!_cityGroups){
        _cityGroups = [LTCityGroupsModel objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

- (LTCitySearhResultController *)searchResult{
    if(!_searchResult){
        LTCitySearhResultController *searchResult = [[LTCitySearhResultController alloc] init];
        [self addChildViewController:searchResult];
        _searchResult = searchResult;
    }
    return _searchResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // > 设置导航栏
    [self setupCityChangeNavigationItems];
    
    // > 设置控制器View
    [self setupCityChange];
}

- (void)setupCityChangeNavigationItems{
    self.title = @"切换城市";
    
    UIBarButtonItem *close = [UIBarButtonItem itemWithTarget:self action:@selector(closeChangeCity:) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    close.customView.width = LTNavigationRightBarButtonItemWidth;
    
    self.navigationItem.leftBarButtonItem = close;
}

/** 关闭导航栏控制器*/
- (void)closeChangeCity:(UIButton *) button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCityChange{
    // > 搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setPlaceholder:@"请输入城市名或者拼音"];
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    // > 设置代理
    [searchBar setDelegate:self];
    [searchBar setTintColor:LTColor(32, 192, 180)];
    [self.view addSubview: searchBar];
    
    self.searchBar = searchBar;
    
    // > 表格
    UITableView *tableView = [[UITableView alloc] init];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    // > 索引标题颜色
    [tableView setSectionIndexColor:[UIColor grayColor]];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // > 遮盖
    UIView *cover = [[UIView alloc] init];
    
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    
    // > 添加手势点击遮盖退出编辑状态
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)]];

    [self.view addSubview:cover];
    self.cover = cover;
    
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
       weak_self weakSelf = self;
    // > 搜索栏
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    // > 表格
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(weakSelf.searchBar.mas_bottom).offset(10);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    // > 遮盖布局
    [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView.mas_top);
        make.bottom.equalTo(weakSelf.tableView.mas_bottom);
        make.left.equalTo(weakSelf.tableView.mas_left);
        make.right.equalTo(weakSelf.tableView.mas_right);
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LTCityGroupsModel *cityModel = self.cityGroups[section];
    return cityModel.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
        
    LTCityGroupsModel *model = self.cityGroups[indexPath.section];
    cell.textLabel.text = model.cities[indexPath.row];
    
    return cell;
}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LTCityGroupsModel *model = self.cityGroups[indexPath.section];

    // > 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LTCityChangedNotification object:nil userInfo:@{ LTSelectedCity:model.cities[indexPath.row],LTSelectedRegion:@"全部地区",LTSelectedSubRegion:@"全部",LTNotificationExit:@"NO",LTNotificationInit:@"YES"}];
    
    // > 退出控制器
    [self closeChangeCity:nil];
}

/** 分组标题 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    LTCityGroupsModel *model = self.cityGroups[section];
    return model.title;
}

/** 索引标题 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSMutableArray *titles = [NSMutableArray array];
//    
//    for(LTCityGroupsModel *model in self.cityGroups){
//        [titles addObject:model.title];
//    }
    
    return [self.cityGroups valueForKeyPath:@"title"];
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    // > 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // > 显示遮盖
    self.cover.alpha = 0.5;

    // > 修改搜索框颜色
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    // > 显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];

    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // > 打开导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // > 隐藏遮盖
    self.cover.alpha = 0.0;
    
    // > 修改搜索框颜色
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    // > 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
}

/** 取消按钮 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setText:nil];
    [self.searchResult.view removeFromSuperview];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length){
        
        // > 添加搜索结果
        
        // > 禁止遮盖响应
        self.cover.alpha = 0.0;
        [self.view addSubview:self.searchResult.view];
        
        weak_self weakSelf = self;
        [self.searchResult.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.cover.mas_left);
            make.top.equalTo(weakSelf.cover.mas_top);
            make.width.equalTo(weakSelf.cover.mas_width);
            make.height.equalTo(weakSelf.cover.mas_height);
        }];
        
        // > 更新数据源
        self.searchResult.searchText = searchText;
        
    }else{
        self.cover.alpha = 0.5;
        [self.searchResult.view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
