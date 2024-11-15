//
//  BaseTabBarController.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/9.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"


#import "DoctorHomeViewController.h"
#import "RecipeViewController.h"
#import "StatementViewController.h"
#import "MineViewController.h"


#import "HomeViewController.h"
#import "CustomRecipeViewController.h"


@interface BaseTabBarController ()
<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setBarTintColor:COLOR_FFFFFF];//tabBar背景颜色
    self.tabBar.tintColor = MainColor;//tabBar字体颜色
    self.tabBar.shadowImage = [[UIImage alloc]init];
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance * appearance = [UITabBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.backgroundColor = COLOR_FFFFFF;
        appearance.shadowColor = COLOR_FFFFFF;
        appearance.backgroundImage =[self zt_imageWithPureColor:[UIColor whiteColor]];
        UITabBarItemAppearance *itemAppearance = [UITabBarItemAppearance new];
        [itemAppearance.normal setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_ECD8BC}];
        [itemAppearance.selected setTitleTextAttributes:@{NSForegroundColorAttributeName: MainColor}];
        appearance.stackedLayoutAppearance = itemAppearance;
        self.tabBar.standardAppearance = appearance;
        self.tabBar.scrollEdgeAppearance = appearance;
    }
    self.delegate = self;
    
    
    // Do any additional setup after loading the view.
}

- (UIImage *)zt_imageWithPureColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3, 3), NO, [UIScreen mainScreen].scale);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 3, 3)];
    [color setFill];
    [p fill];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

- (void)setIsCustom:(BOOL)isCustom {
    _isCustom = isCustom;
    if(isCustom) {
        [self addCustomChildViewControllers];
    }else {
        [self addChildViewControllers];
    }
}


- (void)addChildViewControllers {
    DoctorHomeViewController *homeVC = [[DoctorHomeViewController alloc]init];
    [self addChildViewController:homeVC  title: @"首页" imageName:@"tab_home_deselect" selectedImageName:@"tab_home_select"];
    
    RecipeViewController *recipeVC = [[RecipeViewController alloc]init];
    [self addChildViewController:recipeVC title: @"处方订单"  imageName:@"tab_order_deselect" selectedImageName:@"tab_order_select"];
    
    StatementViewController *statementVC = [[StatementViewController alloc]init];
    [self addChildViewController:statementVC title: @"报表统计"  imageName:@"tab_group_deselect" selectedImageName:@"tab_group_select"];
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self addChildViewController:mineVC title: @"我的"  imageName:@"tab_mine_deselect" selectedImageName:@"tab_mine_select"];
}

- (void)addCustomChildViewControllers {
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [self addChildViewController:homeVC  title: @"首页" imageName:@"tab_home_deselect" selectedImageName:@"tab_home_select"];
    
    CustomRecipeViewController *recipeVC = [[CustomRecipeViewController alloc]init];
    [self addChildViewController:recipeVC title: @"处方订单"  imageName:@"tab_order_deselect" selectedImageName:@"tab_order_select"];

    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self addChildViewController:mineVC title: @"我的"  imageName:@"tab_mine_deselect" selectedImageName:@"tab_mine_select"];
}

- (void)addChildViewController:(UIViewController *)childVC title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName {
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:childVC];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    [nav.tabBarItem setTitleTextAttributes: @{NSForegroundColorAttributeName:COLOR_ECD8BC} forState:UIControlStateNormal];
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
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
