//
//  AddDoctorOrderTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddDoctorOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
+ (CGFloat)getCellHeightWith:(AttentionItemModel *)model;
@property (nonatomic, strong) AttentionItemModel *model;
@end

NS_ASSUME_NONNULL_END
