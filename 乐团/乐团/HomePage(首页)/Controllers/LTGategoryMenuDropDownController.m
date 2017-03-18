//
//  LTGategoryMenuDropDownController.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTGategoryMenuDropDownController.h"
#import "LTDropMenuMainCell.h"
#import "LTDropMenuSubCell.h"
#import "LTCategoryModel.h"
#import "CommonDefine.h"

@interface LTGategoryMenuDropDownController ()

@property (nonatomic, weak) UITableViewCell *leftSelectedCell;
@property (nonatomic, strong) NSArray *categorys;

@end

@implementation LTGategoryMenuDropDownController

- (NSArray *)categorys{
    if(!_categorys){
        _categorys = [LTCategoryModel categorys];
    }
    return _categorys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // > 设置数据源与代理方法
    [self.leftView setDelegate:self];
    [self.leftView setDataSource:self];
    [self.rightView setDataSource:self];
    [self.rightView setDelegate:self];
    
    [self.leftView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.leftView]){
        return self.categorys.count;
    }else {
        
         LTCategoryModel *model = self.categorys[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        
        return model.subcategories.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = nil;
    
    // > 主表cell加载
    if([tableView isEqual:self.leftView]){
        cell = [LTDropMenuMainCell dropMenuMainCell:tableView];
        
        LTCategoryModel *model = self.categorys[indexPath.row];
        
        cell.textLabel.text = model.name;
        cell.imageView.image = [UIImage imageNamed:model.small_icon];
        // > 显示有子分类
        if(model.subcategories.count){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell = [LTDropMenuSubCell dropMenuSubCell:tableView];
        
        LTCategoryModel *model = self.categorys[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        if(model.subcategories.count){
            cell.textLabel.text = model.subcategories[indexPath.row];
        }
    }
    
    return cell;
}
#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isEqual:self.leftView]){
        LTCategoryModel *model = self.categorys[indexPath.row];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSIndexPath *oldIndexPath = [tableView indexPathForCell:self.leftSelectedCell];
        
        // > 切换选中的图片
        self.leftSelectedCell.imageView.image = [UIImage imageNamed:((LTCategoryModel *)self.categorys[oldIndexPath.row]).small_icon];
        cell.imageView.image = [UIImage imageNamed:model.small_highlighted_icon];
        self.leftSelectedCell = cell;
        
        // > 如果没有子类发送通知
        if(!model.subcategories.count){
            // > 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:LTCagtegoryChangedNotification object:nil userInfo:@{LTMainCagtegorySelected:model.name,LTSubCagtegorySelected:((LTCategoryModel *)self.categorys[indexPath.section]).name,LTIconCategorySelected:model.icon,LTIconHLCategorySelected:model.highlighted_icon,LTNotificationExit:@"YES"}];
            
            // > 退出
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        // > 显示子分类
        [self.rightView reloadData];
    }else{
        
        LTCategoryModel *model = self.categorys[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        
        // > 发送选中分类通知
        if(model.subcategories.count){
            [[NSNotificationCenter defaultCenter] postNotificationName:LTCagtegoryChangedNotification object:nil userInfo:@{LTMainCagtegorySelected:model.name,LTSubCagtegorySelected:model.subcategories[indexPath.row],LTIconCategorySelected:model.icon,LTIconHLCategorySelected:model.highlighted_icon,LTNotificationExit:@"YES"}];
            
            // > 退出
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
