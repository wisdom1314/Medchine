//
//  UIViewController+BackAction.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/28.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "UIViewController+BackAction.h"

#import "BaseNavigationController.h"

#import "BaseTabBarController.h"

#import <objc/runtime.h>

static void *PKey = &PKey;
static void *PParamBlockKey = &PParamBlockKey;

@implementation UIViewController (BackAction)

+(void)load {
    swizzleMethod([self class], @selector(viewDidAppear:), @selector(ac_viewDidAppear));
}
- (void)ac_viewDidAppear{
    

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:nil];
    
    
    [self ac_viewDidAppear];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    // the method doesn't exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



- (id)param{
    return objc_getAssociatedObject(self, &PKey);
}

- (void)setParam:(id)param{
    objc_setAssociatedObject(self, &PKey, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BackBlockWithParam)backBlockWithParam{
    return objc_getAssociatedObject(self, &PParamBlockKey);
}

- (void)setBackBlockWithParam:(BackBlockWithParam)backBlockWithParam{
    objc_setAssociatedObject(self, &PParamBlockKey, backBlockWithParam, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (void)pushVC:(NSString *)vcName animated:(BOOL)animated {
    [self pushVC:vcName param:nil animated:animated];
}

- (void)pushVC:(NSString *)vcName param:(id)param animated:(BOOL)animated {
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    UIViewController *vc = [class new];
    vc.param = param;
    [self.navigationController pushViewController:vc animated:animated];
}


- (void)pushVC:(NSString *)vcName param:(nullable id)param backBlock:(void(^)(NSDictionary *dic))backBlock animated:(BOOL)animated {
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class不存在");
    UIViewController *vc = [class new];
    vc.param = param;
    if (backBlock) {
        vc.backBlockWithParam = backBlock;
    }
    [self.navigationController pushViewController:vc animated:animated];
}



/// 获取栈中最后一个vc
+ (UIViewController *)currentViewController {
    UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController ;
    return [self currentViewControllerFrom:rootVC];
}


+ (UIViewController *)currentViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[BaseNavigationController class]]) {
        BaseNavigationController *nav = (BaseNavigationController *)viewController;
        UIViewController *v = [nav.viewControllers lastObject];
        return [self currentViewControllerFrom:v];
    }else if([viewController isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController *tabVC = (BaseTabBarController *)viewController;
        return [self currentViewControllerFrom:[tabVC.viewControllers objectAtIndex:tabVC.selectedIndex]];
    }else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }else {
        return viewController;
    }
}
@end


@interface BaseNavigationController (ShouldPopOnBackButton)

@end


@implementation BaseNavigationController (ShouldPopOnBackButton)





- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(shouldBack)]) {
        [vc shouldBack];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    return NO;
}

@end
