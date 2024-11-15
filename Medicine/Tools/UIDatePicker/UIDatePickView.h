//
//  UIDatePickView.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDatePickView : UIView
@property (nonatomic, strong) RACSubject *commitSubject;

@property (nonatomic, copy) NSString *currentDateStr;
@end

NS_ASSUME_NONNULL_END
