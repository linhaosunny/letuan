//
//  LTCollectViewController.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/26.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTCollectViewController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "LTDetailViewController.h"
#import "LTDealCell.h"
#import "LTDealModel.h"
#import "MJRefresh.h"
#import "CommonDefine.h"
#import "Masonry.h"
#import "LTDealTool.h"

@interface LTCollectViewController () <LTDealCellDelegate>
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, weak) UIImageView *noDealsView;
@property (nonatomic, weak) UIBarButtonItem *edit;
@property (nonatomic, weak) UIBarButtonItem *close;
@property (nonatomic, weak) UIBarButtonItem *allSelect;
@property (nonatomic, weak) UIBarButtonItem *allUnSelect;
@property (nonatomic, weak) UIBarButtonItem *delete;

@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL allCheck;
@end

@implementation LTCollectViewController

static NSString * const reuseIdentifier = @"collect";

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
    [self.collectionView setBackgroundColor:LTGlobalBlackgroudColor];
    [self setTitle:@"收藏的团购"];
    
    // > 设置导航栏
    UIBarButtonItem *close = [UIBarButtonItem itemWithTarget:self action:@selector(closeCollectView:) image:@"icon_back" highImage:@"icon_back_highlighted"];
//    close.customView.width = LTNavigationRightBarButtonItemWidth;
    self.navigationItem.leftBarButtonItems = @[close];
    self.close = close;
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editCollectView:)];
    self.navigationItem.rightBarButtonItem = edit;
    self.edit = edit;
    
    // > 添加背景图片
    UIImageView *noDealsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
    //    noDealsView.hidden = YES;
    [self.view addSubview:noDealsView];
    self.noDealsView = noDealsView;
    [self.noDealsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    
    // > 竖直方向允许拉伸
    [self.collectionView setAlwaysBounceVertical:YES];
    
    // > 注册cell
    [self.collectionView registerClass:[LTDealCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // > 添加代理
    [self.collectionView setDelegate:self];
    // Do any additional setup after loading the view.
    
    // > 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectChanged:) name:LTCollectChangeNotification object:nil];
    
    // > 上拉刷新数据
    [self.collectionView addFooterWithTarget:self action:@selector(loadDealsFromDataBase)];
    
    // > 添加数据
    [self loadDealsFromDataBase];
    
   
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LTCollectChangeNotification object:nil];
}

- (void)collectChanged:(NSNotification *) notification{
    
    if([notification.userInfo[LTCollectSelect] isEqualToString:@"YES"]){
        [self.deals addObject:notification.userInfo[LTCollectValue]];
    }else{
        [self.deals removeObject:notification.userInfo[LTCollectValue]];
    }
    
    [self.collectionView reloadData];
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

- (void)closeCollectView:(UIButton *) button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editCollectView:(UIBarButtonItem *) item{
    
    if([item.title isEqualToString:@"编辑"]){
        item.title =@"完成";
        
        [self setTitle:nil];
        
        UIBarButtonItem *allSelect = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(allSelectCollectView:)];
        self.allSelect = allSelect;
        
        UIBarButtonItem *allUnSelect = [[UIBarButtonItem alloc] initWithTitle:@"全不选" style:UIBarButtonItemStyleDone target:self action:@selector(allUnSelectCollectView:)];
        self.allUnSelect = allUnSelect;
        
        UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteCollectView:)];
        delete.enabled = NO;
        self.delete = delete;
        
        self.navigationItem.leftBarButtonItems = @[self.close, allSelect,allUnSelect,delete];
        
        // > 让修改模型进入编辑状态
        for(LTDealModel *deal in self.deals){
            deal.editing = YES;
        }
        
    }else{
        item.title =@"编辑";
        [self setTitle:@"收藏的团购"];
        
        self.navigationItem.leftBarButtonItems = @[self.close];
        
        // > 让修改模型退出编辑状态
        for(LTDealModel *deal in self.deals){
            deal.editing = NO;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)loadDealsFromDataBase{
    // > 页码增加
    self.currentPage ++;
    
    // > 新增数据
    [self.deals addObjectsFromArray:[LTDealTool collectDealsWithNumofPage:LTDataBaseDealPerPageNum withPage:self.currentPage]];
    
    
    for(LTDealModel *deal in self.deals){
        // > 设置编辑状态
        if([self.edit.title isEqualToString:@"编辑"]){
            deal.editing = NO;
        }else{
            deal.editing = YES;
        }
        
        // > 设置全选
        if(self.allCheck){
            deal.checking = YES;
        }else{
            deal.checking = NO;
        }
        
    }
    
    // > 刷新表格
    [self.collectionView reloadData];
    
    // > 停止刷新
    [self.collectionView footerEndRefreshing];
    
}

- (void)allSelectCollectView:(UIBarButtonItem *) item{
    DebugLog(@"all select");
     if(![self.edit.title isEqualToString:@"编辑"]){
        self.allCheck = YES;
        
        // > 让修改模型退出编辑状态
        for(LTDealModel *deal in self.deals){
            deal.checking = YES;
        }
     }
    // > 设置删除按钮
    [self.delete setEnabled:YES];
    // > 刷新表格
    [self.collectionView reloadData];
}

- (void)allUnSelectCollectView:(UIBarButtonItem *) item{
   if(![self.edit.title isEqualToString:@"编辑"]){
        self.allCheck = NO;
        
        // > 让修改模型退出编辑状态
        for(LTDealModel *deal in self.deals){
            deal.checking = NO;
        }
   }
    // > 设置删除按钮
    [self.delete setEnabled:NO];
    
   // > 刷新表格
   [self.collectionView reloadData];
}

- (void)deleteCollectView:(UIBarButtonItem *) item{
   
    NSMutableArray *checks = [NSMutableArray array];
    // > 数据在遍历的时候不允许增删数据元素
    
    for(LTDealModel *deal in self.deals){
        if(deal.isChecking){
            [LTDealTool removeCollectDeal:deal];
            [checks addObject:deal];
        }
    }
    
   // > 删除本地数据
   [self.deals removeObjectsInArray:checks];
   
   // > 删除状态改变
   [self.delete setEnabled:NO];
   // > 刷新表格
   [self.collectionView reloadData];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    
    // > 编辑按钮状态
    
    self.edit.enabled = self.deals.count;
    // > 刷新控件隐藏
    self.collectionView.footerHidden = (self.deals.count == [LTDealTool collectDealsCount]);
    // > 显示是否有数据
    self.noDealsView.hidden = self.deals.count;
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTDealCell *cell = (LTDealCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setDeal:self.deals[indexPath.item]];
    [cell setDelegate:self];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DebugLog(@"--------------");
    
    LTDetailViewController * controller = [[LTDetailViewController alloc] init];
    controller.deal = self.deals[indexPath.item];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - <LTDealCellDelegate>

- (void)dealCellDidChangedChecking:(LTDealCell *)cell andWithDealModel:(LTDealModel *)model{
    // > 修改模型
    model.checking = !model.checking;
    
    BOOL hasChecking = NO;
    for(LTDealModel *deal in self.deals){
        if(deal.isChecking){
            hasChecking = YES;
            break;
        }
    }
    
    // > 设置删除按钮
    [self.delete setEnabled:hasChecking];
}

@end
