//
//  TradingTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
+ (CGFloat)getCellHeightWith:(TransLogModel *)logModel;

@property (nonatomic, strong) TransLogModel *model;
@end

NS_ASSUME_NONNULL_END
