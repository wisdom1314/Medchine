//
//  HistoryDoctorOrderCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryDoctorOrderCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath;
@property (nonatomic, strong) RecipeOrderItemModel *model;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@end

NS_ASSUME_NONNULL_END
