//
//  PGPickerView+Swizzling.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import "PGPickerView+Swizzling.h"

@implementation PGPickerView (Swizzling)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 获取原始初始化方法
        Method originalInitMethod = class_getInstanceMethod(self, @selector(initWithFrame:));
        Method originalInitCoderMethod = class_getInstanceMethod(self, @selector(initWithCoder:));
        
        // 获取交换的方法
        Method swizzledInitMethod = class_getInstanceMethod(self, @selector(swizzled_initWithFrame:));
        Method swizzledInitCoderMethod = class_getInstanceMethod(self, @selector(swizzled_initWithCoder:));
        
        // 交换方法
        method_exchangeImplementations(originalInitMethod, swizzledInitMethod);
        method_exchangeImplementations(originalInitCoderMethod, swizzledInitCoderMethod);
    });
}

- (instancetype)swizzled_initWithFrame:(CGRect)frame {
    PGPickerView *pickerView = [self swizzled_initWithFrame:frame]; // 调用原始方法
    [pickerView setupDefaultFont]; // 设置默认字体
    return pickerView;
}

- (instancetype)swizzled_initWithCoder:(NSCoder *)aDecoder {
    PGPickerView *pickerView = [self swizzled_initWithCoder:aDecoder]; // 调用原始方法
    [pickerView setupDefaultFont]; // 设置默认字体
    return pickerView;
}

// 设置默认字体
- (void)setupDefaultFont {
    // 检查是否未设置中间文本字体，若是则设置默认值
    if (!self.middleTextFont) {
        self.middleTextFont = [UIFont boldSystemFontOfSize:17]; // 可以根据需求调整
    }
}

@end
