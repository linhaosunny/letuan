//
//  LTSearchBar.m
//  乐团
//
//  Created by 李莎鑫 on 2017/3/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTSearchBar.h"

@implementation LTSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSearchBar];
    }
    return self;
}

- (void)setupSearchBar{
    [self setBackgroundColor:[UIColor clearColor]];
    [self sizeToFit];
    
    //删除默认灰色背景
    [self.subviews[0].subviews[0] removeFromSuperview];
}

/** 修改样式*/
- (void)searchBarCustomerTextFieldWithBorderColor:(UIColor *) color andTextFieldStyle:(LTSearchTextFieldType) type{
    
    UITextField *searchField = [self valueForKey:@"searchField"];
    
    if(type == LTSearchTextFieldDefault){
        return;
    }
    
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        if(type == LTSearchTextFieldBorderColorDarkRed){
            searchField.layer.borderColor = [UIColor colorWithRed:247/255.0 green:75/255.0 blue:31/255.0 alpha:1].CGColor;
        }else if(type == LTSearchTextFieldBorderColorDarkGreen){
            searchField.layer.borderColor = [UIColor colorWithRed:31/255.0 green:185/255.0 blue:34/255.0 alpha:1.0].CGColor;
        }else if(type == LTSearchTextFieldBorderColorGray){
            searchField.layer.borderColor = [UIColor grayColor].CGColor;
        }else{
            searchField.layer.borderColor = color.CGColor;
        }
        
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
    }
}

/** 修改取消按钮*/
- (void)searchBarCancelButtonWithName:(NSString *) name{
    UIButton *cancelButton = [self valueForKey:@"cancelButton"];
    [cancelButton setTitle:name forState:UIControlStateNormal];
}

/** 搜索框光标颜色*/
- (void)searchBarTextFieldCursorWithColor:(UIColor *)color{
    [self setTintColor:color];
}

/** 自定义右边搜索栏*/

- (void)searchBarTextFieldRightButtonNormalImageWithName:(NSString *)normalName andHighledImageName:(NSString *) hightledName andButtonStyle:(LTSearchTextFieldRightButtonIconType) type andPlaceHolder:(NSString *) placeText{
    
    
    if(type == LTSearchTextFieldRightButtonDefault){
        return;
    }
    //添加右边图标
    if(normalName){
        [self setShowsBookmarkButton:YES];
    }
    
    // 默认字符
    [self setPlaceholder:placeText];
    
    [self setImage:[UIImage imageNamed:normalName] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:hightledName] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
    
}
@end
