//
//  PrescriptionTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PrescriptionTableViewCell : UITableViewCell
+ (CGFloat)getCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, strong) RecipeDailyItemModel *model;
@property (weak, nonatomic) IBOutlet UILabel *dateStr;
@end

NS_ASSUME_NONNULL_END
