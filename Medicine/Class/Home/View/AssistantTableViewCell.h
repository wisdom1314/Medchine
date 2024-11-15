//
//  AssistantTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/13.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AssistantTableViewCell : UITableViewCell
+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model;
@property (weak, nonatomic) IBOutlet UIButton *chooseLevelBtn;
@property (weak, nonatomic) IBOutlet UIButton *chosseAreaBtn;
@property (nonatomic, strong) PromoteUserModel *model;
@property (weak, nonatomic) IBOutlet UIButton *idcardImgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *idcardImgBtn2;

@end

NS_ASSUME_NONNULL_END
