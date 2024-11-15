//
//  AppDelegate+Service.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "AppDelegate+Service.h"
#import "LoginViewController.h"
#import "BaseTabBarController.h"

typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转

} AnimationType;


@implementation AppDelegate (Service)

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
 

- (void)goLogin {
    [self transitionWithType:@"oglFlip" WithSubtype:kCATransitionFromLeft ForView:[ZZProgress getCurrentWindow]];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
    [MedicineManager sharedInfo].isLogined = NO;
    [MedicineManager sharedInfo].token = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"pushId"];

    BaseNavigationController *nvc = [[BaseNavigationController alloc]initWithRootViewController:[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil]];
    self.window.rootViewController = nvc;
}

- (void)goMain {
    [self transitionWithType:@"oglFlip" WithSubtype:kCATransitionFromRight ForView:[ZZProgress getCurrentWindow]];
    BaseTabBarController *tabBarVC = [[BaseTabBarController alloc]init];
    tabBarVC.isCustom = NO;
    self.window.rootViewController = tabBarVC;
}

- (void)goCustomMain {
    [self transitionWithType:@"oglFlip" WithSubtype:kCATransitionFromRight ForView:[ZZProgress getCurrentWindow]];
    BaseTabBarController *tabBarVC = [[BaseTabBarController alloc]init];
    tabBarVC.isCustom = YES;
    self.window.rootViewController = tabBarVC;
}

- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.7;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}


@end
