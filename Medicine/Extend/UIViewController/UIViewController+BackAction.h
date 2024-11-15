//
//  UIViewController+BackAction.h
//  SimiBao
//
//  Created by 张智慧 on 2020/8/28.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BackButtonHookProtocol <NSObject>

@optional
/// 重写下面的方法以拦截导航栏返回按钮点击事件
- (void)shouldBack;

@end



typedef void(^BackBlockWithParam)(NSDictionary *dic);

@interface UIViewController (BackAction) <BackButtonHookProtocol>
@property (nonatomic, strong) id param;
@property (nonatomic, copy) BackBlockWithParam backBlockWithParam;

- (void)pushVC:(NSString *)vcName animated:(BOOL)animated;
- (void)pushVC:(NSString *)vcName param:(id)param animated:(BOOL)animated;
- (void)pushVC:(NSString *)vcName param:(nullable id)param backBlock:(void(^)(NSDictionary *dic))backBlock animated:(BOOL)animated;

+ (UIViewController *)currentViewController;
+ (UIViewController *)currentViewControllerFrom:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
