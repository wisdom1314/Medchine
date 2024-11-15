//
//  AddMedichineCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddMedichineCell : UITableViewCell
+ (CGFloat)getCellHeight;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) DrugItemModel *model;
@end

NS_ASSUME_NONNULL_END
