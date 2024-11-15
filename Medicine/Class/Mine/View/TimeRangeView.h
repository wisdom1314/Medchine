//
//  TimeRangeView.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeRangeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UITextField *beginTextF;
@property (weak, nonatomic) IBOutlet UITextField *endTextF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
