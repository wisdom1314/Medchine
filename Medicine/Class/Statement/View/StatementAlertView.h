//
//  StatementAlertView.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatementAlertView : UIView

- (void)show;

@property (nonatomic, copy) NSArray *doctorArray;

@property (nonatomic, copy) NSArray *paymentArray;

@property (nonatomic, strong) RACSubject *commitSubject;


@end

NS_ASSUME_NONNULL_END
