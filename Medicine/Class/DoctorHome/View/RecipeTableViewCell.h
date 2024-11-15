//
//  RecipeTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/19.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

#import "CycleTakePhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *numTextF;
@property (weak, nonatomic) IBOutlet UIButton *addDoctorOrderBtn;
@property (weak, nonatomic) IBOutlet CycleTakePhotoView *takeView;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIButton *doctorOrderBtn;
@property (weak, nonatomic) IBOutlet UITextView *attentionTextView;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextView *symptomTextView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UILabel *imgTopLab;

- (void)setModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath columWith:(NSInteger)colum;


+ (instancetype)getAutoTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath;

- (void)setMyModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
