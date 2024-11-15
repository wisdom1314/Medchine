//
//  RecipeButtonView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipeButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *myBtn;

- (void)setBtnSelected: (NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
