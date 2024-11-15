//
//  AddMyRecipeTempateView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddMyRecipeTempateView : UIView
@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
