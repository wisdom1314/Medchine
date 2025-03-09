//
//  RecipeOrderTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecipeOrderTableViewCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith: (RecipeOrderItemModel* )model;
@property (nonatomic, strong) RecipeOrderItemModel *model;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

NS_ASSUME_NONNULL_END
