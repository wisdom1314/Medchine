//
//  RefuseView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefuseView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) RACSubject *subject;

@end

NS_ASSUME_NONNULL_END
