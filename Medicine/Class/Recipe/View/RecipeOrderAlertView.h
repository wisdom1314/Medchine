//
//  RecipeOrderAlertView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipeOrderAlertView : UIView

- (void)show;

@property (nonatomic, copy) NSArray *doctorArray;

@property (nonatomic, copy) NSArray *paymentArray;

@property (nonatomic, strong) RACSubject *commitSubject;
@end

NS_ASSUME_NONNULL_END
