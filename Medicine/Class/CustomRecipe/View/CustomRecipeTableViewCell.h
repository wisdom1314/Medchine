//
//  CustomRecipeTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomRecipeTableViewCell : UITableViewCell
+ (CGFloat)getCellHeight;
@property (nonatomic, strong) RecipeOrderItemModel *model;
@property (weak, nonatomic) IBOutlet UIButton *payStatusBtn;
@end

NS_ASSUME_NONNULL_END
