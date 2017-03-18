//
//  LTSearchBar.h
//  乐团
//
//  Created by 李莎鑫 on 2017/3/18.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LTSearchTextFieldRightButtonDefault = 0,
    LTSearchTextFieldRightButtonCustomer = 1,
}LTSearchTextFieldRightButtonIconType;

typedef enum{
    LTSearchTextFieldDefault = 0,
    LTSearchTextFieldBorderColorGray = 1,
    LTSearchTextFieldBorderColorDarkGreen = 2,
    LTSearchTextFieldBorderColorDarkRed   = 3,
    LTSearchTextFieldCustomer = 4,
}LTSearchTextFieldType;

@interface LTSearchBar : UISearchBar

- (void)searchBarCustomerTextFieldWithBorderColor:(UIColor *) color andTextFieldStyle:(LTSearchTextFieldType) type;

- (void)searchBarCancelButtonWithName:(NSString *) name;
- (void)searchBarTextFieldCursorWithColor:(UIColor *)color;
- (void)searchBarTextFieldRightButtonNormalImageWithName:(NSString *)normalName andHighledImageName:(NSString *) hightledName andButtonStyle:(LTSearchTextFieldRightButtonIconType) type andPlaceHolder:(NSString *) placeText;
@end
