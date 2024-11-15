//
//  RecipeCustomAlertView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipeCustomAlertView : UIView
- (void)show;
@property (nonatomic, strong) RACSubject *commitSubject;
@end

NS_ASSUME_NONNULL_END
