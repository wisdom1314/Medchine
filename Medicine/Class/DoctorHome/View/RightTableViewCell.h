//
//  RightTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RightTableViewCell : UITableViewCell


+ (CGFloat)getCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property (nonatomic, strong) RecipesampleSymptomsModel *model;

@end

NS_ASSUME_NONNULL_END
