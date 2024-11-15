//
//  RecipeTemplateTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecipeTemplateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic, strong) TemplateModel *model;
@property (nonatomic, strong) CategoryModel *categoryModel;
+ (CGFloat)getCellHeight;
@end

NS_ASSUME_NONNULL_END
