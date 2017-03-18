//
//  LTDealsViewController.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNetWorkParamsModel.h"

@interface LTDealsViewController : UICollectionViewController


- (void)loadDealsFromNetWork:(LTNetWorkParamsModel *) data ;
@end
