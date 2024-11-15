//
//  UIView+Border.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/25.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)addTopBorderWithColor:(UIColor *)color width:(CGFloat)width {
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, width);
    topBorder.backgroundColor = color.CGColor;
    [self.layer addSublayer:topBorder];
}

- (void)addBottomBorderWithColor:(UIColor *)color width:(CGFloat)width {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - width, self.frame.size.width, width);
    bottomBorder.backgroundColor = color.CGColor;
    [self.layer addSublayer:bottomBorder];
}


@end
