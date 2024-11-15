//
//  RecipeDetailTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeDetailTableViewCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith: (RecipeOrderItemModel *)model detailModelWith:(RecipeOrderDetailModel *)detaiModel;
@property (nonatomic, strong) RecipeOrderItemModel *model;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) RecipeOrderDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
