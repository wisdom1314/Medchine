//
//  UIView+Extension.h
//  MammonDrive
//
//  Created by 张智慧 on 2019/5/15.
//  Copyright © 2019 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
/// x坐标属性
@property (nonatomic, assign)CGFloat x;
/// y坐标
@property (nonatomic, assign)CGFloat y;
/// 宽度
@property (nonatomic, assign)CGFloat width;
/// 高度
@property (nonatomic, assign)CGFloat height;
/// 大小
@property (nonatomic, assign)CGSize size;
/// 位置
@property (nonatomic, assign)CGPoint origin;
/// 中心点x
@property (nonatomic, assign)CGFloat centerX;
/// 中心点y
@property (nonatomic, assign)CGFloat centerY;

@property (assign, nonatomic) CGFloat lx_x;
@property (assign, nonatomic) CGFloat lx_y;
@property (assign, nonatomic) CGFloat lx_width;
@property (assign, nonatomic) CGFloat lx_height;

@property (assign, nonatomic) CGFloat lx_left;
@property (assign, nonatomic) CGFloat lx_top;
@property (assign, nonatomic) CGFloat lx_right;
@property (assign, nonatomic) CGFloat lx_bottom;

@property (assign, nonatomic) CGSize lx_size;

@end

NS_ASSUME_NONNULL_END
