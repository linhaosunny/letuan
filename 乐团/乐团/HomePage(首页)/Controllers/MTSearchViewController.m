//
//  MTSearchViewController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/22.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "UIImage+ResizeImage.h"
#import "CommonDefine.h"
#import "Masonry.h"

@interface MTSearchViewController ()<UISearchBarDelegate>

@end

@implementation MTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // > 设置导航栏
    [self setupNavigationItems];
}

- (void)setupNavigationItems{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.size = CGSizeMake(260, 30);
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    [searchBar setPlaceholder:@"请输入关键词"];
    [searchBar setDelegate:self];
    [searchBar setTintColor:MTColor(38, 158, 90)];
    [titleView addSubview:searchBar];

    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    
}

- (void)back:(UIButton *) button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UISearchBarDelegate>
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    MTNetWorkParamsModel *data =[MTNetWorkParamsModel sharedParamsModel];
    data.keyword = searchBar.text;
    
    [self loadDealsFromNetWork:data];
    [searchBar endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
