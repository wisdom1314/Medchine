//
//  ExcipientHeaderView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/25.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExcipientHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *zbBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (nonatomic, strong) RecipeModel *model;

@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
