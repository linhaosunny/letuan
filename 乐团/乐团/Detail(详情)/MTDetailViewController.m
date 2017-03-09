//
//  MTDetailViewController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/24.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTDetailViewController.h"
#import "MutableScrollView.h"
#import "MTDeitalView.h"
#import "MTDealModel.h"
#import "MTRestrictionsModel.h"
#import "Masonry.h"
#import "CommonDefine.h"
#import "ProgressHUD.h"
#import "MTHttpTool.h"
#import "MJExtension.h"
#import "MTDealTool.h"
#import "UIView+Extension.h"

@interface MTDetailViewController ()<UIWebViewDelegate,MTDeitalViewDelegate>
@property (nonatomic, weak) MutableScrollView *scrollView;
@property (nonatomic, weak) MTDeitalView *topView;
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@end

@implementation MTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:MTGlobalBlackgroudColor];
    // > 设置详情页
    [self setupDetailView];
    
    // > 发送请求获取更详细的订单数据
    [self loadDetailSingleDeal];
    
    // > 添加浏览记录
    if([MTDealTool isRecentDeal:self.deal]){
        // > 移除旧的记录
        [MTDealTool removeRecentDeal:self.deal];
    }
    // > 新增
    [MTDealTool addRecentDeal:self.deal];
}


- (void)setupDetailView{
    MutableScrollView *scrollView = [[MutableScrollView alloc] init];
    [scrollView setBackgroundColor:MTGlobalBlackgroudColor];
    [scrollView setScrollEnabled:YES];
    [scrollView setCanCancelContentTouches:YES];
    [scrollView setDelaysContentTouches:NO];
    [scrollView setUserInteractionEnabled:YES];
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    MTDeitalView *topView = [[MTDeitalView alloc] init];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [topView setDelegate:self];
    
    [self.scrollView addSubview:topView];
    self.topView = topView;
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setBackgroundColor:[UIColor whiteColor]];
    [webView setDelegate:self];
    [webView setHidden:YES];
    
    webView.scrollView.bounces = NO;
    [webView.scrollView setScrollEnabled:NO];
    webView.userInteractionEnabled = YES;
    [webView sizeToFit];
    
    [self.scrollView addSubview: webView];
    self.webView = webView;
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [activityView setHidesWhenStopped:YES];
    
    [self.view addSubview:activityView];
    self.activityView = activityView;
    
    // > 自动布局
    [self setupSubViewsConstraints];
    
}

- (void)setupSubViewsConstraints{
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // > 上面view布局
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.scrollView);
        make.width.equalTo(self.view.mas_width);
//        make.height.equalTo(self.view.mas_height);
    }];
    
    // > 下面view布局
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.topView);
    }];
    
   [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(self.webView.mas_bottom);
   }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.webView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

/** 只支持竖屏 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // > 判断是否入口的html
    if([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]){
        NSString *deal_h5_url = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",[self.deal.deal_id substringFromIndex: [self.deal.deal_id rangeOfString:@"-"].location + 1]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:deal_h5_url]]];
    }else{
         // > 获取html所有的html节点
        NSMutableString *js = [NSMutableString string];
        
        // > 删除header节点
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        
        // > 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 删除footer节点
        [js appendString:@"var footer = document.getElementsByTagName('footer')[0];"];
        [js appendString:@"footer.parentNode.removeChild(footer);"];
        
        [webView stringByEvaluatingJavaScriptFromString:js];

        // > 显示网页
        [self.activityView stopAnimating];
        [webView setHidden:NO];
        
        //获取页面高度（像素）
        NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.clientHeight"];
        float clientheight = [clientheight_str floatValue];
        
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(clientheight);
        }];
        
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.webView.mas_bottom);
        }];
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    DebugLog(@"deal_id:%@,deal_h5:%@",self.deal.deal_id,request.URL);
    return YES;
}

- (void)loadDetailSingleDeal{

    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    params[@"deal_id"] = self.deal.deal_id;
    
    weak_self weakSelf = self;
    // > 发送网络请求
    [[MTHttpTool sharedHttpTool] httpToolRequestWithURL:@"v1/deal/get_single_deal" params:params successWithResult:^(DPRequest *request,id result) {
        MTDealModel *deal = [MTDealModel objectWithKeyValues:[result[@"deals"] firstObject]];
        weakSelf.deal.restrictions = deal.restrictions;
        
        [weakSelf.topView detailViewImageWithURLString:weakSelf.deal.image_url];
        [weakSelf.topView detailViewTitleWithText:weakSelf.deal.title];
        [weakSelf.topView detailViewDetailTitleWithText:weakSelf.deal.description_inform];
        [weakSelf.topView detailViewCurrentPriceLabelWithText:[NSString stringWithFormat:@"¥%@",weakSelf.deal.current_price]];
        [weakSelf.topView detailViewListPriceLabelWithText:[NSString stringWithFormat:@" 门店价 ¥%@",weakSelf.deal.list_price]];
        [weakSelf.topView detailViewBackAnyTimeSupport:weakSelf.deal.restrictions.is_refundable];
        
        
        [weakSelf.topView detailViewExpiredSupport:weakSelf.deal.restrictions.is_refundable];
        [weakSelf.topView detailViewPurchaseCountWithText:[NSString stringWithFormat:@"已售出%d",weakSelf.deal.purchase_count]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *deadLine = [formatter dateFromString:[NSString stringWithFormat:@"%@ 23:59",weakSelf.deal.purchase_deadline]];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date] toDate:deadLine options:0];
        if(components.day > 365){
            [weakSelf.topView detailViewEndTimeWithText:@"一年内不会过期"];
        }else{
            [weakSelf.topView detailViewEndTimeWithText:[NSString stringWithFormat:@"%ld天%ld小时%ld分钟",components.day,components.hour,components.minute]];
        }
        // > 设置收藏
        [weakSelf.topView detailViewCollectButtonSetSelected:[MTDealTool isCollectDeal:weakSelf.deal]];
        
        // > 设置webView
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.deal. deal_h5_url]]];
        
    
    } failWithError:^(DPRequest *request,NSError *error) {
        // > 提醒网络
        [MBProgressHUD showError:@"网络繁忙，请稍后再试！" toView:self.view];
    }];
    
}

#pragma mark - <MTDeitalViewDelegate>
- (void)deitalView:(MTDeitalView *)view didClickNavigationLeftButton:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deitalView:(MTDeitalView *)view didClickBuyButton:(UIButton *)button{
    
}

/** 添加与移除收藏  */
- (void)deitalView:(MTDeitalView *)view didClickCollectButton:(UIButton *)button{
    
    if(!button.isSelected){
        [MTDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功！" toView:self.view];
    }else{
        [MTDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功！" toView:self.view];
    }
    
    // > 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:MTCollectChangeNotification object:nil userInfo:@{MTCollectSelect:[NSString stringWithFormat:@"%@",!button.isSelected?@"YES":@"NO"],MTCollectValue:self.deal}];
}

- (void)deitalView:(MTDeitalView *)view didClickShareButton:(UIButton *)button{
    
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    DebugLog(@".......");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
