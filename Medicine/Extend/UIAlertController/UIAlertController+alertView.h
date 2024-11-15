//
//  UIAlertController+alertView.h
//  EasyLive
//
//  Created by He on 2018/4/25.
//  Copyright © 2018年 wisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (alertView)

//UIAlertController
+ (void)showUIAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message  withSureBtnTitle:(NSString *)sureBtnTitle withCancleTitle:(NSString *)cancleBtnTitle withCancleBtnClick:(void(^)(UIAlertAction *action))cancleBtnClick withSureBtnClick:(void(^)(UIAlertAction *action))sureBtnClick;

//快速提示框
+ (void)showAlertViewWithMessage:(NSString *)message;

@end
