//
//  ComputeTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/25.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComputeTableViewCell : UITableViewCell
+ (CGFloat)getCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *beforeLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *valueLab;

- (void)setModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath;

- (void)setMyModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
