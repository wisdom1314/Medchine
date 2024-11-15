//
//  MedchineReduceTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/5.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedchineReduceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addMedchineBtn;
@property (weak, nonatomic) IBOutlet UITextField *numtextF;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *secrectExpandBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIView *dealViiew;
@property (weak, nonatomic) IBOutlet UILabel *orginalLab;
@property (weak, nonatomic) IBOutlet UILabel *actualLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalTextWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subWidth;

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath modelWith:(RecipeModel *)model;

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(RecipeModel *)model;


+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(RecipeModel *)model isDetail:(BOOL)isDetail;

@property (nonatomic, strong) DrugItemModel *model;
@property (nonatomic, strong) DrugItemModel *myModel;




@end

NS_ASSUME_NONNULL_END
