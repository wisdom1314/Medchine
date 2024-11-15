//
//  RecipeLastView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/26.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeLastView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cacelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) RecipeModel *model;

@end

NS_ASSUME_NONNULL_END
