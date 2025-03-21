//
//  UserPrivacyView.h
//  Medicine
//
//  Created by 张智慧 on 2024/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserPrivacyView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cacelBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) RACSubject *subject;

@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
