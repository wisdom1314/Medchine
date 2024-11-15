//
//  UIButton+Custom.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/5.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

+ (UIButton *)bottomBtnWithY:(CGFloat)Y
                   titleWith:(NSString *)title {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(30, Y, WIDE - 60, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = MainColor;
    [btn setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    return btn;
}

+ (UIButton *)btnWithFrame:(CGRect)frame
              normalImage:(UIImage * _Nullable)imgNor
              normalTitle:(NSString *)strNorTitle
         normalTitleColor:(UIColor *)colorNor
             andTitleFont:(UIFont *)font
{
    return  [self btnWithFrame:frame
                   normalImage:imgNor
                 selectedImage:nil
         normalBackgroundImage:nil
       selectedBackgroundImage:nil
                   normalTitle:strNorTitle
                 selectedTitle:nil
              normalTitleColor:colorNor
                 selectedColor:nil
               BackgroundColor:nil
                  andTitleFont:font];
}

+ (UIButton *)btnWithFrame:(CGRect)frame
               normalImage:(UIImage *)imgNor
             selectedImage:(UIImage *)imgSelected
               normalTitle:(NSString *)strNorTitle
          normalTitleColor:(UIColor *)colorNor
              andTitleFont:(UIFont *)font
{
    return  [self btnWithFrame:frame
                   normalImage:imgNor
                 selectedImage:imgSelected
         normalBackgroundImage:nil
       selectedBackgroundImage:nil
                   normalTitle:strNorTitle
                 selectedTitle:nil
              normalTitleColor:colorNor
                 selectedColor:nil
               BackgroundColor:nil
                  andTitleFont:font];
}


+ (UIButton *)btnWithFrame:(CGRect)frame
               normalImage:(UIImage *)imgNor
             selectedImage:(UIImage *)imgSelected
               normalTitle:(NSString *)strNorTitle
             selectedTitle:(NSString *)strSelectedTitle
          normalTitleColor:(UIColor *)colorNor
             selectedColor:(UIColor *)colorSelect
           BackgroundColor:(UIColor *)colorBackground
              andTitleFont:(UIFont *)font
{
    
    return  [self btnWithFrame:frame
                   normalImage:imgNor
                 selectedImage:imgSelected
         normalBackgroundImage:nil
       selectedBackgroundImage:nil
                   normalTitle:strNorTitle
                 selectedTitle:strSelectedTitle
              normalTitleColor:colorNor
                 selectedColor:colorSelect
               BackgroundColor:colorBackground
                  andTitleFont:font];
}


/// 全能的初始化方法
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
              andTitleFont:(UIFont *)font
{
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTemp.frame = frame;
    btnTemp.titleLabel.font = font;
    /// 设置文字
    [btnTemp setTitle:strNorTitle forState:UIControlStateNormal];
    if (strSelectedTitle)
    {
        [btnTemp setTitle:strSelectedTitle forState:UIControlStateSelected];
    }
    
    /// 设置文字颜色
    [btnTemp setTitleColor:colorNor forState:UIControlStateNormal];
    if (colorSelect)
    {
        [btnTemp setTitleColor:colorSelect forState:UIControlStateSelected];
    }
    
    /// 设置背景颜色
    if (colorBackground)
    {
        [btnTemp setBackgroundColor:colorBackground];
    }
    else
    {
        // 默认透明
        [btnTemp setBackgroundColor:[UIColor clearColor]];
    }
    
    /// 设置图片
    if(imgNor) {
        [btnTemp setImage:imgNor forState:UIControlStateNormal];
    }
    
    if (imgSelected)
    {
        [btnTemp setImage:imgSelected forState:UIControlStateSelected];
    }
    
    /// 设置背景图片
    if (imgNorBg)
    {
        [btnTemp setBackgroundImage:imgNorBg forState:UIControlStateNormal];
    }
    if (imgselectedBg)
    {
        [btnTemp setBackgroundImage:imgselectedBg forState:UIControlStateSelected];
    }
     
    return btnTemp;
}

@end
