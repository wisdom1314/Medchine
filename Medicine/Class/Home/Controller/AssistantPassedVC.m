//
//  AssistantPassedVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/14.
//

#import "AssistantPassedVC.h"
#import "AssistantHeaderView.h"
#import "HomeModel.h"

#import <TYTabPagerBar.h>
#import <TYPagerController.h>
#import "TYTabPagerBarLayout+FixFontSize.h"
#import "AssistantViewController.h"
#import "DoctorViewController.h"

@interface AssistantPassedVC ()
<TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
TYPagerControllerDataSource,
TYPagerControllerDelegate>
@property (nonatomic, strong) AssistantHeaderView *headerView;
@property (nonatomic, strong) PromoteUserModel *userModel;
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@end

@implementation AssistantPassedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleImage];
    [self.view addSubview:self.headerView];

    [self requestUserDetail];
    
    self.datas = @[@"推广医助",@"邀请医生"];
   
    
    [[self.headerView.callBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if(self.userModel.phonenumber.length>0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.userModel.phonenumber]]];
        }
    }];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)addTabPageBar {
    self.tabBar = [[TYTabPagerBar alloc]init];
    self.tabBar.backgroundColor = COLOR_F8F5EF;
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.normalTextColor = COLOR_562306;
    self.tabBar.layout.selectedTextColor = COLOR_562306;
    self.tabBar.layout.progressColor = MainColor;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
    self.tabBar.layout.selectedTextFont = [UIFont boldSystemFontOfSize:15];;
    self.tabBar.layout.progressWidth  = 50;
    self.tabBar.layout.cellSpacing = 0;
    self.tabBar.layout.cellEdging = 5;
    self.tabBar.progressView.layer.cornerRadius = 2;
    self.tabBar.progressView.layer.masksToBounds = YES;
    self.tabBar.layout.adjustContentCellsCenter = YES;
    self.tabBar.dataSource = self;
    self.tabBar.delegate = self;
    [self.tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:self.tabBar];
}


- (void)addPagerController {
    self.pagerController = [[TYPagerController alloc]init];
    self.pagerController.layout.prefetchItemCount = 1;
    self.pagerController.scrollView.bounces = NO;
    self.pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    self.pagerController.dataSource = self;
    self.pagerController.delegate = self;
    [self addChildViewController:self.pagerController];
    [self.view addSubview:self.pagerController.view];
}


- (void)reloadData {
    [self.tabBar reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.headerView.frame = CGRectMake(0, 0, WIDE, 240);
    self.tabBar.frame = CGRectMake(0, 240, WIDE, 50);
    self.pagerController.view.frame = CGRectMake(0, 290, WIDE, HIGHT - NAV_H - 290);
}



#pragma mark -- TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

#pragma mark -- TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return floor(WIDE/2.0 - 10);
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pagerController scrollToControllerAtIndex:index animate:YES];
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.datas[index];
    return cell;
}

#pragma mark -- TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.datas.count;
}


- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0)
    {
        AssistantViewController *assistantVC =  [[AssistantViewController alloc]init];
        assistantVC.param = @{@"promoteUserId": self.userModel.userId};
        return assistantVC;
    }else {
        DoctorViewController *doctorVC = [[DoctorViewController alloc]init];
        doctorVC.param = @{@"promoteUserId": self.userModel.userId};
        return doctorVC;
    }
    
}


#pragma mark -- TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}



- (void)requestInviateCount {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"includeSon"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [dic setValue:self.userModel.userId forKey:@"promoteUserId"];
    [[RequestManager shareInstance]requestWithMethod:GET url:PromoteInviteCountURL dict:dic hasHeader:YES finished:^(id request) {
        self.headerView.inviateNumLab.text = [NSString stringWithFormat:@"%@", request[@"data"]];
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestAgentCount {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"includeSon"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [dic setValue:self.userModel.userId forKey:@"promoteUserId"];
    [[RequestManager shareInstance]requestWithMethod:GET url:PromoteAgentCountURL dict:dic hasHeader:YES finished:^(id request) {
        self.headerView.tgNumLab.text = [NSString stringWithFormat:@"%@", request[@"data"]];
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestUserDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:[NSString stringWithFormat:@"%@/%@",PromoteAgentDetail, self.param[@"userId"]] dict:dic hasHeader:YES finished:^(id request) {
        self.userModel = [PromoteUserModel mj_objectWithKeyValues:request[@"data"]];
        self.headerView.model = self.userModel;
        
        [self addTabPageBar];
        [self addPagerController];
        [self reloadData];
        [self requestInviateCount];
        [self requestAgentCount];
    } failed:^(NSError *error) {
        
    }];
}

- (AssistantHeaderView *)headerView {
    if(!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"AssistantHeaderView" owner:self options:nil].lastObject;
       
    }
    return _headerView;
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
