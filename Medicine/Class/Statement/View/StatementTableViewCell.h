//
//  StatementTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import <UIKit/UIKit.h>
#import "StatementModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatementTableViewCell : UITableViewCell

@property (nonatomic, strong) ReportDrugModel *model;

@end

NS_ASSUME_NONNULL_END
