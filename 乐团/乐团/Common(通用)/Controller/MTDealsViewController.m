//
//  MTDealsViewController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTDealsViewController.h"
#import "MTNetWorkRequestModel.h"
#import "MTDetailViewController.h"
#import "MTHttpTool.h"
#import "MTDealModel.h"
#import "MJExtension.h"
#import "MTDealCell.h"
#import "MJRefresh.h"
#import "CommonDefine.h"
#import "UIView+Extension.h"
#import "ProgressHUD.h"
#import "Masonry.h"

@interface MTDealsViewController ()
@property (nonatomic, weak) UIImageView *noDealsView;
@property (nonatomic, weak) MTNetWorkParamsModel *data;

@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, strong) MTNetWorkRequestModel *request;

@end

@implementation MTDealsViewController

static NSString * const reuseIdentifier = @"dealCell";

- (MTNetWorkRequestModel *)request{
    if(!_request){
        _request = [[MTNetWorkRequestModel alloc] init];
    }
    
    return _request;
}


- (NSMutableArray *)deals{
    if(!_deals){
        _deals = [NSMutableArray array];
    }
    
    return _deals;
}

/** 流水布局*/
- (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(300, 300);
    // > 调整竖直方向的间距
    layout.minimumLineSpacing = 20;
    
    // > 调整上，下，左，右边距
    if([UIView ScreenSizeIsLandscape:[[UIScreen mainScreen] bounds].size]){
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    }else{
        layout.sectionInset = UIEdgeInsetsMake(30, 60, 30, 60);
    }
    
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // > 设置背景色
    [self.collectionView setBackgroundColor:MTGlobalBlackgroudColor];
    
    // > 添加背景图片
    UIImageView *noDealsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
//    noDealsView.hidden = YES;
    [self.view addSubview:noDealsView];
    self.noDealsView = noDealsView;
    [self.noDealsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    // > 竖直方向允许拉伸
    [self.collectionView setAlwaysBounceVertical:YES];
    
    // > 注册cell
    [self.collectionView registerClass:[MTDealCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // > 上拉与下拉刷新数据
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDealsFromNetWork)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadUpdateDealsFromNetWork)];
    
    // > 添加代理
    [self.collectionView setDelegate:self];
}

/** 监听屏幕旋转 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if([UIView ScreenSizeIsLandscape:size]){
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    }else{
        layout.sectionInset = UIEdgeInsetsMake(30, 60, 30, 60);
    }
}


#pragma mark - 获取网络数据
- (void)loadDealsFromNetWork:(MTNetWorkParamsModel *) data{
    self.data = data;
    [self.collectionView headerBeginRefreshing];
}

- (void)loadMoreDealsFromNetWork{
    if(self.request.page < self.request.total_page){
        self.request.page ++;
    }
    [self loadNetworkServersNewData:self.data withClearUpdate:NO];
}

- (void)loadUpdateDealsFromNetWork{
    
    // > 重新加载所有订单
    self.request.page = 0;
    self.request.limit = (int)self.deals.count;
    [self loadNetworkServersNewData:self.data withClearUpdate:YES];
}

- (void)loadNetworkServersNewData:(MTNetWorkParamsModel *) data withClearUpdate:(BOOL) clear{
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    params[@"city"] = data.city;
    
    if(!data.keyword){
        if(data.region){
            params[@"region"] = data.region;
        }
        
        if(data.category){
            params[@"category"] = data.category;
        }
        
        if(data.sort){
            params[@"sort"] = @(data.sort);
        }
    }else{
        params[@"keyword"] = data.keyword;
    }
    
    if(self.request.page){
        params[@"page"] = @(self.request.page);
    }else{
        self.request.page = 1;
    }
    
    // > 从服务器预读取deal数量
    if(self.request.limit){
        params[@"limit"] = @(self.request.limit);
        self.request.request_num = self.request.limit;
    }else{
        if(self.request.total_num < 6 && self.request.total_num > 0){
            params[@"limit"] = @(self.request.total_num);
            self.request.request_num = self.request.total_num;
        }else{
            params[@"limit"] = @(6);
            self.request.request_num = 6;
        }
    }
    // > 判断是否清除缓存
    self.request.clearData = clear;
    
    
//    DebugLog(@"请求参数：%@",params);
    weak_self weakSelf = self;
    
    [[MTHttpTool sharedHttpTool] httpToolRequestWithURL:@"v1/deal/find_deals" params:params successWithResult:^(DPRequest *request,id result) {
        DebugLog(@"返回NetWork数据：%@",result);
        
        // > 如果需要更新数据
        if(weakSelf.request.clearData){
            [weakSelf.deals removeAllObjects];
        }
        
    
        // > 读取网络数据
        if(result[@"deals"]){
            NSArray *deals = [MTDealModel objectArrayWithKeyValuesArray:result[@"deals"]];
            
            // > 计算总页码
            weakSelf.request.total_num = [result[@"total_count"] intValue];
            if(result[@"total_count"]&&weakSelf.request.total_num){
                if([result[@"total_count"] intValue]%weakSelf.request.request_num == 0){
                    weakSelf.request.total_page = [result[@"total_count"] intValue]/weakSelf.request.request_num;
                }else{
                    weakSelf.request.total_page = [result[@"total_count"] intValue]/weakSelf.request.request_num + 1;
                }
            }
            
            // > 新增数据
            [weakSelf.deals addObjectsFromArray:deals];
            
            // > 刷新请求后恢复默认请求量
            if(weakSelf.request.limit){
                weakSelf.request.limit = 0;
            }
            
            // > 刷新表格
            [weakSelf.collectionView reloadData];
        }
        
        // > 结束上拉刷新
        [weakSelf.collectionView footerEndRefreshing];
        [weakSelf.collectionView headerEndRefreshing];
        
        // > 结束上拉刷新
        weakSelf.collectionView.footerHidden = [result[@"total_count"] intValue] == weakSelf.deals.count;
    } failWithError:^(DPRequest *request,NSError *error) {
         DebugLog(@"加载数据失败,error:%@",error);
    
        // > 加载失败处理
        if(weakSelf.request.page > 1){
            weakSelf.request.page --;
        }
        
        if([((NSString *)error.userInfo[@"errorMessage"]) containsString:@"请求参数值无效"]){
            // > 如果需要更新数据
            if(weakSelf.request.clearData){
                [weakSelf.deals removeAllObjects];
            }
            
            // > 显示是否有数据
            weakSelf.noDealsView.hidden = weakSelf.deals.count;
            
            // > 刷新表格
            [self.collectionView reloadData];
        }else{
            // > 提醒网络
            [MBProgressHUD showError:@"网络繁忙，请稍后再试！" toView:weakSelf.view];
        }
        
        // > 停止刷新控件
        [weakSelf.collectionView footerEndRefreshing];
        [weakSelf.collectionView headerEndRefreshing];
    }];
    

    
    [[MTHttpTool sharedHttpTool] httpToolRequestWithURL:@"v1/metadata/get_categories_with_deals" params:nil successWithResult:^(DPRequest *request,id result) {
        DebugLog(@"返回Categroy数据：%@",result);
    } failWithError:^(DPRequest *request,NSError *error) {
        DebugLog(@"加载Categroy数据失败,error:%@",error);
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    // > 显示是否有数据
    self.noDealsView.hidden = self.deals.count;
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealCell *cell = (MTDealCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setDeal:self.deals[indexPath.item]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DebugLog(@"--------------");
    
    MTDetailViewController * controller = [[MTDetailViewController alloc] init];
    controller.deal = self.deals[indexPath.item];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
