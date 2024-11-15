//
//  AppDelegate.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "AppDelegate.h"
#import "AppDelegate+Service.h"
#import <XHLaunchAd.h>

@interface AppDelegate ()
<XHLaunchAdDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = MainColor;
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
    
    
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    
    imageAdconfiguration.frame = CGRectMake(0, NSTATUS_H, WIDE, HIGHT-NSTATUS_H);
    imageAdconfiguration.imageNameOrURLString = @"launch.jpg";
    imageAdconfiguration.duration = 3;
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
    if([ClassMethod getStringBy:@"token"].length>0) {
        [MedicineManager sharedInfo].token = [ClassMethod getStringBy:@"token"];
        [MedicineManager sharedInfo].isLogined = YES;
        if ([ClassMethod getModelBy:@"customInfo"]) {
            UserInfoModel *model = [ClassMethod getModelBy:@"customInfo"];
            if([model.userType integerValue] != 10 && [model.userType integerValue] != 30) {
                [MedicineManager sharedInfo].customModel = [ClassMethod getModelBy:@"customInfo"];
                [MedicineManager sharedInfo].isCustom = YES;
            }else {
                [MedicineManager sharedInfo].doctorModel = [ClassMethod getModelBy:@"doctorInfo"];
                [MedicineManager sharedInfo].isCustom = NO;
            }
        }else {
            [MedicineManager sharedInfo].doctorModel = [ClassMethod getModelBy:@"doctorInfo"];
            [MedicineManager sharedInfo].isCustom = NO;
        }
       
        [MedicineManager sharedInfo].hospitalModel = [ClassMethod getModelBy:@"hospitalInfo"];
        if([MedicineManager sharedInfo].isCustom) {
            [self goCustomMain];
        }else {
            [self goMain];
        }
        
    }else {
        [self goLogin];
    }
    
    
    return YES;
}


#pragma mark - XHLaunchAd delegate
- (BOOL)xhLaunchAd:(XHLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
    }
    return YES;
}


@end
