//
//  BaseViewController.h
//  SimiBao
//
//  Created by 张智慧 on 2020/8/3.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, copy) NSString *navTitle;

- (void)initialize;

- (void)rightViewShowWithImg:(nullable NSString *)img titleWith:(nullable NSString *)titleStr actionWith:(SEL)action;

- (void)leftViewShowWithImg:(nullable NSString *)img titleWith:(nullable NSString *)titleStr actionWith:(SEL)action;

- (void)rightFrontWithImg:(NSString *)img actionWith:(SEL)action afterImgWith:(NSString *)afterImg afterActionWith:(SEL)afterAction;

@property (nonatomic, strong) UIView *nodataView;

@property (nonatomic, strong) UIButton *afterBtn;

@property (nonatomic, strong) UIButton *rightBtn;

- (void)setNavTitleImage;


@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, strong) UIButton *reloadBtn;




@end

NS_ASSUME_NONNULL_END
