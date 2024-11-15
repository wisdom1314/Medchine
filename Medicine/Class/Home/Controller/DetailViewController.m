//
//  DetailViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import "DetailViewController.h"
#import "AssistantViewController.h"
#import "DoctorViewController.h"
#import "PrescriptionViewController.h"

#import <TYTabPagerBar.h>
#import <TYPagerController.h>
#import "TYTabPagerBarLayout+FixFontSize.h"

@interface DetailViewController ()
<TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
TYPagerControllerDataSource,
TYPagerControllerDelegate>
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleImage];
    self.datas = @[@"推广医助",@"邀请医生",@"处方金额"];
    [self addTabPageBar];
    [self addPagerController];
    [self reloadData];
    
//    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    CGFloat navHeight = navBarHeight + statusBarHeight;

    // Do any additional setup after loading the view.
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


- (void)loadDataWith:(NSArray *)modelArray {
    [self addTabPageBar];
    [self addPagerController];
    
    NSMutableArray *datas = [NSMutableArray array];
    [datas addObjectsFromArray:modelArray];
    self.datas = [datas copy];
    [self reloadData];
}

- (void)reloadData {
    [self.tabBar reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tabBar.frame = CGRectMake(0, 0, WIDE, 50);
    self.pagerController.view.frame = CGRectMake(0, 50, WIDE, HIGHT - NAV_H - 50);
}

#pragma mark -- TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

#pragma mark -- TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return floor(WIDE/3.0 - 10);
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
        return assistantVC;
    }else if (index == 1){
        DoctorViewController *doctorVC = [[DoctorViewController alloc]init];
        return doctorVC;
    }else {
        PrescriptionViewController *prescriptionVC = [[PrescriptionViewController alloc]init];
        return prescriptionVC;
    }
    
}


#pragma mark -- TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
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
