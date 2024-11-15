//
//  TYTabPagerBarLayout+FixFontSize.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import "TYTabPagerBarLayout+FixFontSize.h"

#import "TYTabPagerBar.h"


@implementation TYTabPagerBarLayout (FixFontSize)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledTYTabPagerBarLayoutTransitionFromCell];
    });
}

+ (void)swizzledTYTabPagerBarLayoutTransitionFromCell {
    SEL originSelector = @selector(transitionFromCell:toCell:animate:);
    SEL swizzledSelector = @selector(hook_TYTabPagerBarLayout_transitionFromCell:toCell:animate:);
    Method originMethod = class_getInstanceMethod([self class], originSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    BOOL success = class_addMethod([self class], originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod([self class], swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}

- (void)hook_TYTabPagerBarLayout_transitionFromCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> *)toCell animate:(BOOL)animate {
    if (self.pagerTabBar.countOfItems == 0) {
       return;
    }
    __weak typeof(self) weakSelf = self;
    void (^animateBlock)(void) = ^{
        if (fromCell) {
            fromCell.titleLabel.font = weakSelf.normalTextFont;
            fromCell.titleLabel.textColor = weakSelf.normalTextColor;
            fromCell.transform = CGAffineTransformMakeScale(weakSelf.selectFontScale, weakSelf.selectFontScale);
        }
        if (toCell) {
            toCell.titleLabel.font = weakSelf.selectedTextFont ? weakSelf.selectedTextFont : weakSelf.normalTextFont;
            toCell.titleLabel.textColor = weakSelf.selectedTextColor ? weakSelf.selectedTextColor : weakSelf.normalTextColor;
            toCell.transform = CGAffineTransformIdentity;
        }
    };
    if (animate) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            animateBlock();
        }];
    }else{
        animateBlock();
    }
}

@end
