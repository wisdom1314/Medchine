//
//  AppDelegate+Service.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Service)

+ (AppDelegate *)shareAppDelegate;

- (void)goLogin;

- (void)goMain;

- (void)goCustomMain;

@end

NS_ASSUME_NONNULL_END
