//
//  UIView+Border.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Border)
- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat)width;
- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
