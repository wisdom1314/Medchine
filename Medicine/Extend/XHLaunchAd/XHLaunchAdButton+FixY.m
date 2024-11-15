//
//  XHLaunchAdButton+FixY.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/14.
//

#import "XHLaunchAdButton+FixY.h"

@implementation XHLaunchAdButton (FixY)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // 获取原始的 `initWithSkipType:` 方法
        SEL originalSelector = @selector(initWithSkipType:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        
        // 获取我们要替换的 `swizzled_initWithSkipType:` 方法
        SEL swizzledSelector = @selector(swizzled_initWithSkipType:);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 交换两个方法的实现
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (instancetype)swizzled_initWithSkipType:(SkipType)skipType {
    XHLaunchAdButton *button = [self swizzled_initWithSkipType:skipType];
    button.frame = CGRectMake(WIDE - 80, NSTATUS_H, 70, 35);
    return button;
}

@end
