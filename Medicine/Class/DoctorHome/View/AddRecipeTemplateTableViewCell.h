//
//  AddRecipeTemplateTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddRecipeTemplateTableViewCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath typeWith:(NSString *)type;
@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryBtn;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath typeWith:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
