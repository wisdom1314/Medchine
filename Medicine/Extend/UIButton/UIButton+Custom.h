//
//  UIButton+Custom.h
//  SimiBao
//
//  Created by 张智慧 on 2020/8/5.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Custom)

+ (UIButton *)bottomBtnWithY:(CGFloat)Y
                   titleWith:(NSString *)title;

+ (UIButton *)btnWithFrame:(CGRect)frame
               normalImage:(UIImage * _Nullable)imgNor
               normalTitle:(NSString *)strNorTitle
          normalTitleColor:(UIColor *)colorNor
              andTitleFont:(UIFont *)font;

+ (UIButton *)btnWithFrame:(CGRect)frame
               normalImage:(UIImage *)imgNor
             selectedImage:(UIImage *)imgSelected
               normalTitle:(NSString *)strNorTitle
          normalTitleColor:(UIColor *)colorNor
              andTitleFont:(UIFont *)font;

+ (UIButton *)btnWithFrame:(CGRect)frame
               normalImage:(UIImage *)imgNor
             selectedImage:(UIImage *)imgSelected
               normalTitle:(NSString *)strNorTitle
             selectedTitle:(NSString *)strSelectedTitle
          normalTitleColor:(UIColor *)colorNor
             selectedColor:(UIColor *)colorSelect
           BackgroundColor:(UIColor *)colorBackground
              andTitleFont:(UIFont *)font;


+ (UIButton *)btnWithFrame:(CGRect)frame
               normalImage:(UIImage *)imgNor
             selectedImage:(UIImage *)imgSelected
     normalBackgroundImage:(UIImage *)imgNorBg
   selectedBackgroundImage:(UIImage *)imgselectedBg
               normalTitle:(NSString *)strNorTitle
             selectedTitle:(NSString *)strSelectedTitle
          normalTitleColor:(UIColor *)colorNor
             selectedColor:(UIColor *)colorSelect
           BackgroundColor:(UIColor *)colorBackground
              andTitleFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
