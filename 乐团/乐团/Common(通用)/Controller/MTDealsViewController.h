//
//  MTDealsViewController.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTNetWorkParamsModel.h"

@interface MTDealsViewController : UICollectionViewController


- (void)loadDealsFromNetWork:(MTNetWorkParamsModel *) data ;
@end
