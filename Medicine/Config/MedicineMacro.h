//
//  MedicineMacro.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#ifndef MedicineMacro_h
#define MedicineMacro_h



/// 宏定义
#define WIDE   [UIScreen mainScreen].bounds.size.width
#define WIDES   ([UIScreen mainScreen].bounds.size.width/375)
#define HIGHT  [UIScreen mainScreen].bounds.size.height

//判断iPHoneXr
//#define Device_Is_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPHoneX、iPHoneXs
//#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
//#define Device_Is_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
//
////判断iPhoneXs Max
//#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
//
//#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)


// 判断是否是 iPhone X 系列及之后的全面屏设备
#define IS_IPhoneX_All \
({\
    BOOL isPhoneX = NO;\
    if (@available(iOS 11.0, *)) {\
        UIWindow *keyWindow = [[UIApplication sharedApplication] delegate].window;\
        isPhoneX = keyWindow.safeAreaInsets.bottom > 0.0;\
    }\
    (isPhoneX);\
})

// 判断是否是全面屏模式
#define XH_FULLSCREEN (IS_IPhoneX_All)

// 去除前后空格
#define DeleteWhitespace(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

// 导航栏高度，使用动态计算
#define NAV_H \
({\
    CGFloat navHeight = 44; /* 默认导航栏高度 */ \
    if (@available(iOS 11.0, *)) { \
        navHeight += UIApplication.sharedApplication.keyWindow.safeAreaInsets.top; \
    } else { \
        navHeight += 20; /* 非全面屏设备状态栏高度 */ \
    } \
    navHeight; \
})



/// 去除前后空格
#define DeleteWhitespace(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

//#define NAV_H               (IS_IPhoneX_All? 88 : 64)
#define FNAV_H              (IS_IPhoneX_All? -88 : -64)
#define NSTATUS_H           (IS_IPhoneX_All? 44 : 20)
#define TAB_H               (IS_IPhoneX_All? 83 : 49)
#define Indicator_H         (IS_IPhoneX_All? 34 : 0)

#define WeakSelf(type) autoreleasepool{} __weak __typeof__(type) weakSelf = type;
#define StrongSelf(type) autoreleasepool{} __strong __typeof__(type) strongSelf = type;


#define PrivacyURL @"https://zhyf.jingpai.com/static/resource/app_privacy.html"

#define DESKey @"qbi21kyZQOfwUTl6kSDCEUx25"

#endif /* MedicineMacro_h */
