//
//  AccessoryTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/25.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AccessoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addMedchineBtn;
@property (weak, nonatomic) IBOutlet UITextField *numtextF;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIView *dealViiew;


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath dataArrayWith:(NSArray *)excipentArr;

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath dataArrayWith:(NSArray *)excipentArr;



- (void)setModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
