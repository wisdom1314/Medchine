//
//  UIView+Extension.m
//  MammonDrive
//
//  Created by 张智慧 on 2019/5/15.
//  Copyright © 2019 张智慧. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

//x属性的get,set
- (void)setX:(CGFloat)x
{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

//centerX属性的get,set
- (void)setCenterX:(CGFloat)centerX
{    CGPoint center=self.center;center.x=centerX;
    self.center=center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

//centerY属性的get,set
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

//y属性的get,set
- (void)setY:(CGFloat)y
{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

//width属性的get,set
- (void)setWidth:(CGFloat)width
{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

//height属性的get,set
- (void)setHeight:(CGFloat)height
{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

//size属性的get,set
- (void)setSize:(CGSize)size
{
    CGRect frame=self.frame;
    frame.size.width=size.width;
    frame.size.height=size.height;
    self.frame=frame;
}

- (CGSize)size
{
    return self.frame.size;
}

//origin属性的get,set,用于设置坐标
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame=self.frame;
    frame.origin.x=origin.x;
    frame.origin.y=origin.y;
    self.frame=frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(void)setLx_x:(CGFloat)lx_x{
        CGFloat y = self.frame.origin.y;
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        self.frame = CGRectMake(lx_x, y, width, height);
}

-(CGFloat)lx_x{
    return self.frame.origin.x;
}

-(void)setLx_y:(CGFloat)lx_y{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, lx_y, width, height);
}

-(CGFloat)lx_y{
    return self.frame.origin.y;
}

-(void)setLx_width:(CGFloat)lx_width{
    CGRect frame = self.frame;
    frame.size.width = lx_width;
    self.frame = frame;
}

-(CGFloat)lx_width{
    return self.frame.size.width;
}

-(void)setLx_height:(CGFloat)lx_height{
    CGRect frame = self.frame;
    frame.size.height = lx_height;
    self.frame = frame;
}

-(CGFloat)lx_height{
    return self.frame.size.height;
}


-(void)setLx_left:(CGFloat)lx_left{
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(lx_left, y, width, height);
}
-(CGFloat)lx_left{
    return self.frame.origin.x;
}


-(void)setLx_top:(CGFloat)lx_top{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, lx_top, width, height);
}
-(CGFloat)lx_top{
    return self.frame.origin.y;
}
-(void)setLx_right:(CGFloat)lx_right{
    CGRect frame = self.frame;
    frame.origin.x = lx_right - frame.size.width;
    self.frame = frame;
}
-(CGFloat)lx_right{
    return self.frame.origin.x + self.frame.size.width;
}
-(void)setLx_bottom:(CGFloat)lx_bottom{
    CGRect frame = self.frame;
    frame.origin.y = lx_bottom - frame.size.height;
    self.frame = frame;
}
-(CGFloat)lx_bottom{
     return self.frame.origin.y + self.frame.size.height;
}

-(CGSize)lx_size {
    return self.frame.size;
}

- (void)setLx_size:(CGSize)lx_size {
    CGRect frame = self.frame;
    frame.size = lx_size;
    self.frame = frame;
}

@end
