//
//  UIAreaPickView.h
//  SSRead
//
//  Created by 张智慧 on 2021/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAreaPickView : UIView

@property (nonatomic, strong) RACSubject *commitSubject;

@end

NS_ASSUME_NONNULL_END
