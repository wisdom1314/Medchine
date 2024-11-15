//
//  UIAlertController+alertView.m
//  EasyLive
//
//  Created by He on 2018/4/25.
//  Copyright © 2018年 wisdom. All rights reserved.
//

#import "UIAlertController+alertView.h"

#import "UIViewController+BackAction.h"

@implementation UIAlertController (alertView)


//UIAlertController
+ (void)showUIAlertControllerWithTitle:(NSString *)title withMessage:(NSString *)message withSureBtnTitle:(NSString *)sureBtnTitle withCancleTitle:(NSString *)cancleBtnTitle withCancleBtnClick:(void(^)(UIAlertAction *action))cancleBtnClick withSureBtnClick:(void(^)(UIAlertAction *action))sureBtnClick
{
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    if (cancleBtnTitle)
    {
        //添加取消到UIAlertController中
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancleBtnTitle style:UIAlertActionStyleDefault handler:cancleBtnClick];
        [alertController addAction:cancelAction];
    }
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:sureBtnTitle style:UIAlertActionStyleDefault handler:sureBtnClick];
    [alertController addAction:OKAction];

    UIViewController *vc = [UIViewController currentViewController];
    [vc presentViewController:alertController animated:YES completion:nil];
}

//快速提示框
+ (void)showAlertViewWithMessage:(NSString *)message
{
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    
    UIViewController *vc = [UIViewController currentViewController];
    [vc presentViewController:alertController animated:YES completion:nil];
}

@end
