//
//  PatientTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/19.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseAreaBtn;
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath;

@property (nonatomic, strong) RecipeModel *regionItemModel;

- (void)setRegionItemModel:(RecipeModel *)regionItemModel indexPathWith:(NSIndexPath *)indexPath;

- (void)setMyRegionItemModel:(RecipeModel *)regionItemModel indexPathWith:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
