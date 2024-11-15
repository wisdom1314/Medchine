//
//  MemberInfoTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/12.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MemberInfoTableViewCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(PromoteUserBaseModel *)model;
@property (nonatomic, strong) PromoteUserBaseModel *model;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

NS_ASSUME_NONNULL_END
