//
//  MedchineReduceHeaderView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/5.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedchineReduceHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *falseBtn;
@property (weak, nonatomic) IBOutlet UIButton *trueBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;

@property (nonatomic, strong) RecipeModel *model;

@property (nonatomic, assign) BOOL hide;

@end

NS_ASSUME_NONNULL_END
