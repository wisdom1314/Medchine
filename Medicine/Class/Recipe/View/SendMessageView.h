//
//  SendMessageView.h
//  Medicine
//
//  Created by 张智慧 on 2025/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cacelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textF;

@end

NS_ASSUME_NONNULL_END
