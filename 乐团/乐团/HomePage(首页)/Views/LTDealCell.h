//
//  LTDealCell.h
//  乐团
//
//  Created by 李莎鑫 on 2017/2/20.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTDealModel,LTDealCell;

@protocol LTDealCellDelegate <NSObject>

@optional
- (void)dealCellDidChangedChecking:(LTDealCell *) cell andWithDealModel:(LTDealModel *) model;

@end

@interface LTDealCell : UICollectionViewCell

@property (nonatomic, strong) LTDealModel *deal;
@property (nonatomic, weak) id<LTDealCellDelegate> delegate;

+ (LTDealCell *)dealCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *) indexPath;

@end
