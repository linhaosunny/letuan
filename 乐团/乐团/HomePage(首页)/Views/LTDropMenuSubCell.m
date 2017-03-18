//
//  LTDropMenuSubCell.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDropMenuSubCell.h"

static NSString * const ID = @"sub";
@implementation LTDropMenuSubCell

+ (instancetype)dropMenuSubCell:(UITableView *)tableView{
    LTDropMenuSubCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell){
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    
    return cell;
}

@end
