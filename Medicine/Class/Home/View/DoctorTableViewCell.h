//
//  DoctorTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/14.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DoctorTableViewCell : UITableViewCell
+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model;
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model;
@property (weak, nonatomic) IBOutlet UIButton *chooseCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseAreaBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseMedBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardTextF;

@property (weak, nonatomic) IBOutlet UIButton *qmBtn;
@property (weak, nonatomic) IBOutlet UIButton *yyzzBtn;
@property (weak, nonatomic) IBOutlet UIButton *bazBtn;



@property (nonatomic, strong) PromoteUserModel *model;
@end

NS_ASSUME_NONNULL_END
