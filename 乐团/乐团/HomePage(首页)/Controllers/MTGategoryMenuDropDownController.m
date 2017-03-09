//
//  MTGategoryMenuDropDownController.m
//  美团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "MTGategoryMenuDropDownController.h"
#import "MTDropMenuMainCell.h"
#import "MTDropMenuSubCell.h"
#import "MTCategoryModel.h"
#import "CommonDefine.h"

@interface MTGategoryMenuDropDownController ()

@property (nonatomic, weak) UITableViewCell *leftSelectedCell;
@property (nonatomic, strong) NSArray *categorys;

@end

@implementation MTGategoryMenuDropDownController

- (NSArray *)categorys{
    if(!_categorys){
        _categorys = [MTCategoryModel categorys];
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
        
         MTCategoryModel *model = self.categorys[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        
        return model.subcategories.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = nil;
    
    // > 主表cell加载
    if([tableView isEqual:self.leftView]){
        cell = [MTDropMenuMainCell dropMenuMainCell:tableView];
        
        MTCategoryModel *model = self.categorys[indexPath.row];
        
        cell.textLabel.text = model.name;
        cell.imageView.image = [UIImage imageNamed:model.small_icon];
        // > 显示有子分类
        if(model.subcategories.count){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell = [MTDropMenuSubCell dropMenuSubCell:tableView];
        
        MTCategoryModel *model = self.categorys[[self.leftView indexPathForCell:self.leftSelectedCell].row];
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
        MTCategoryModel *model = self.categorys[indexPath.row];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSIndexPath *oldIndexPath = [tableView indexPathForCell:self.leftSelectedCell];
        
        // > 切换选中的图片
        self.leftSelectedCell.imageView.image = [UIImage imageNamed:((MTCategoryModel *)self.categorys[oldIndexPath.row]).small_icon];
        cell.imageView.image = [UIImage imageNamed:model.small_highlighted_icon];
        self.leftSelectedCell = cell;
        
        // > 如果没有子类发送通知
        if(!model.subcategories.count){
            // > 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:MTCagtegoryChangedNotification object:nil userInfo:@{MTMainCagtegorySelected:model.name,MTSubCagtegorySelected:((MTCategoryModel *)self.categorys[indexPath.section]).name,MTIconCategorySelected:model.icon,MTIconHLCategorySelected:model.highlighted_icon,MTNotificationExit:@"YES"}];
            
            // > 退出
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        // > 显示子分类
        [self.rightView reloadData];
    }else{
        
        MTCategoryModel *model = self.categorys[[self.leftView indexPathForCell:self.leftSelectedCell].row];
        
        // > 发送选中分类通知
        if(model.subcategories.count){
            [[NSNotificationCenter defaultCenter] postNotificationName:MTCagtegoryChangedNotification object:nil userInfo:@{MTMainCagtegorySelected:model.name,MTSubCagtegorySelected:model.subcategories[indexPath.row],MTIconCategorySelected:model.icon,MTIconHLCategorySelected:model.highlighted_icon,MTNotificationExit:@"YES"}];
            
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
