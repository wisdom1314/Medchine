//
//  BaseViewController.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/3.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView *navView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_F8F5EF;
    [self initialize];
    // Do any additional setup after loading the view.
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    UILabel *titleLab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navView.width, self.navView.height)];
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = navTitle;
    titleLab.textColor = COLOR_FFFFFF;
    [self.navView addSubview:titleLab];
    self.navigationItem.titleView = self.navView;
    //    self.navigationItem.title = navTitle;
}

- (void)setNavTitleImage {
    
    UIImageView *centerImgView = [ClassMethod createImgViewFrameWith:CGRectMake(60, 0, 80, 40) imageNamed:@"icon_logo"];
    centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.navView addSubview:centerImgView];
    
    self.navigationItem.titleView = self.navView;
}


- (void)initialize {
    
}

- (void)rightViewShowWithImg:(nullable NSString *)img titleWith:(nullable NSString *)titleStr actionWith:(SEL)action {
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.rightBtn = button;
}

- (void)leftViewShowWithImg:(nullable NSString *)img titleWith:(nullable NSString *)titleStr actionWith:(SEL)action {
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)rightFrontWithImg:(NSString *)img actionWith:(SEL)action afterImgWith:(NSString *)afterImg afterActionWith:(SEL)afterAction{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*35, 0, 35, 44)];
        [button setImage:[UIImage imageNamed:i==0?img:afterImg] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:i==0?action:afterAction forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 1) {
            self.afterBtn = button;
        }
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [arr addObject:btnItem];
        
        
    }
    self.navigationItem.rightBarButtonItems = arr.copy;
}

- (UIView *)nodataView {
    if(!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDE, self.view.height)];
        
        UIImageView *nodataImgView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDE - 251)/2, NAV_H + 100, 251, 191)];
        nodataImgView.image = [UIImage imageNamed:@"nodata"];
        nodataImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_nodataView addSubview:nodataImgView];
        
        UILabel *lab = [ClassMethod createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(nodataImgView.frame)+10, _nodataView.width, 20) Font:14 Text:@"暂无数据"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = COLOR_C8975E;
        [_nodataView addSubview:lab];
        
        
        [self.view addSubview:_nodataView];
    }
    return _nodataView;
}


- (void)reloadRequestData {
    
}


- (UIView *)errorView {
    if(!_errorView) {
        _errorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDE, self.view.height)];
        
        UIImageView *nodataImgView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDE - 251)/2, NAV_H + 100, 251, 191)];
        nodataImgView.image = [UIImage imageNamed:@"nodata"];
        nodataImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_errorView addSubview:nodataImgView];
        
        UILabel *lab = [ClassMethod createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(nodataImgView.frame)+10, _nodataView.width, 20) Font:14 Text:@"网络似乎有问题，检查一下吧"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = COLOR_333333;
        [_errorView addSubview:lab];
        
        
        self.reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIDE- 120)/2, CGRectGetMaxY(lab.frame)+ 20, 120, 40)];
        self.reloadBtn.backgroundColor = MainColor;
        self.reloadBtn.layer.cornerRadius = 4.0f;
        [self.reloadBtn setTitle:@"重新连接" forState:UIControlStateNormal];
        self.reloadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        @weakify(self);
        [[self.reloadBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self reloadRequestData];
        }];
        [_errorView addSubview:self.reloadBtn];
        
        [self.view addSubview:_errorView];
    }
    return _errorView;
}

- (UIView *)navView {
    if(!_navView) {
        _navView = [ClassMethod createViewFrameWith:CGRectMake(0, 0, 200, 44) backColorWith:MainColor];
        UIImageView *logImgView = [ClassMethod createImgViewFrameWith:CGRectMake(50, 10, 100, 30) imageNamed:@"top_title_bg"];
        [_navView addSubview:logImgView];
    }
    return _navView;
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
