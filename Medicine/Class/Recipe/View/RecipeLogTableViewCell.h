//
//  RecipeLogTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeLogTableViewCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(ExpressItemModel *)model;

+ (CGFloat)getCellHeightWithModel:(RecipeLogItemModel *)model;

@property (nonatomic, strong) RecipeLogItemModel *model;
@property (nonatomic, strong) ExpressItemModel *expressModel;
@end

NS_ASSUME_NONNULL_END
