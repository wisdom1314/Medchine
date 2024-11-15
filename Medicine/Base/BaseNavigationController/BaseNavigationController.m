//
//  BaseNavigationController.m
//  ALAMHCustomer
//
//  Created by 张智慧 on 2019/6/17.
//  Copyright © 2019 张智慧. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance  = [UINavigationBarAppearance new];
        appearance.backgroundColor = MainColor;
        appearance.shadowColor = MainColor;
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: COLOR_FFFFFF, NSFontAttributeName: [UIFont boldSystemFontOfSize:16]};
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        [UINavigationBar appearance].standardAppearance = appearance;
    }
    [self.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationBar.barTintColor = MainColor ;
    self.navigationBar.tintColor = COLOR_FFFFFF;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_FFFFFF,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.translucent = NO;

    
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
