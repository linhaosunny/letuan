//
//  MTDealCell.h
//  美团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDealModel,MTDealCell;

@protocol MTDealCellDelegate <NSObject>

@optional
- (void)dealCellDidChangedChecking:(MTDealCell *) cell andWithDealModel:(MTDealModel *) model;

@end

@interface MTDealCell : UICollectionViewCell

@property (nonatomic, strong) MTDealModel *deal;
@property (nonatomic, weak) id<MTDealCellDelegate> delegate;

+ (MTDealCell *)dealCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *) indexPath;

@end
