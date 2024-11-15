//
//  RecipeSampleView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipeSampleView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (nonatomic, strong) RecipesampleSymptomsModel *model;
@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
