//
//  MTSortDropMenuController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTSortDropMenuController.h"
#import "MTSortsModel.h"
#import "Masonry.h"
#import "CommonDefine.h"

@interface MTSortDropMenuController ()

@property (nonatomic, weak) UIImageView *backgroudImage;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, strong) NSArray *results;
@end

@implementation MTSortDropMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // > 设置排序界面
    [self setupSortDropMenu:[MTSortsModel sorts]];
    
    // > 监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortChanged:) name:MTSortChangedNotification object:nil];
    
}

- (void)dealloc{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MTSortChangedNotification object:nil];
}

- (void)sortChanged:(NSNotification *) notification{
     if([notification.userInfo[MTNotificationExit] isEqualToString:@"NO"]){
         // > 谓词搜索
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label contains %@ ",notification.userInfo[MTSortSelected]];
         
         self.results = [[MTSortsModel sorts] filteredArrayUsingPredicate:predicate];
        
         // > 设置初始排序选中的按钮
         MTSortsModel *model = [self.results firstObject];
         
         if(model.value){
             self.selectedButton = (UIButton *)self.backgroudImage.subviews[model.value - 1];
         }else{
            self.selectedButton = (UIButton *)self.backgroudImage.subviews[model.value];
         }
         [self.selectedButton setSelected:YES];
     }
}

- (void)setupSortDropMenu:(NSArray *) sorts{
    // > 背景图片
    UIImageView *backgroudImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
    // > 允许用户交互
    [backgroudImage setUserInteractionEnabled:YES];
    [self.view addSubview:backgroudImage];
    self.backgroudImage = backgroudImage;
    
    // > 排序按钮
    for(NSInteger i = 0;i  < sorts.count; i++){
        UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
        
        MTSortsModel *model = sorts[i];
        [button setTitle:model.label forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTag:model.value];
        
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backgroudImage addSubview:button];
    }

    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    // > 自动布局
    [self setupSubViewsConstraints];
}

- (void)setupSubViewsConstraints{
    
    weak_self weakSelf = self;
    // > 布局背景图片
    [self.backgroudImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(weakSelf.view.mas_height);
    }];
    
    // > 布局按钮
    // > 布局宽高
    [self.backgroudImage.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backgroudImage.mas_left).offset(10);
        make.right.equalTo(weakSelf.backgroudImage.mas_right).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    // > 布局位置
    for(int index = 0; index < self.backgroudImage.subviews.count ; index++){
        [self.backgroudImage.subviews[index] mas_updateConstraints:^(MASConstraintMaker *make) {
            if(index){
                make.top.equalTo(weakSelf.backgroudImage.subviews[index - 1].mas_bottom).offset(10);
            }else{
                make.top.equalTo(weakSelf.backgroudImage.mas_top).offset(10);
            }
        }];
    }
}


- (void)sortClick:(UIButton *) button{
    
    // > 按钮选中
    if(![self.selectedButton isEqual:button]){
        self.selectedButton.selected = NO;
        button.selected = YES;
        self.selectedButton = button;
        
        // > 本地存储
        NSString *sortName = button.titleLabel.text;
        [[NSUserDefaults standardUserDefaults] setObject:sortName forKey:@"sortName"];
        
        // > 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:MTSortChangedNotification object:nil userInfo:@{MTSortSelected:button.titleLabel.text,MTSortVaule:@(button.tag),MTNotificationExit:@"YES"}];
        
        // > 退出
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
