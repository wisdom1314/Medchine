//
//  RecipeDetailViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import "RecipeDetailViewController.h"
#import <TYTabPagerBar.h>
#import <TYPagerView.h>
#import "RecipeDetailTableViewCell.h"
#import "RecipeLogTableViewCell.h"
#import "HomeModel.h"
#import "NoDataTableViewCell.h"
#import "RecipeHosTableViewCell.h"
#import "CreateRecipeViewController.h"
#import "MyCreateRecipeViewController.h"
#import "ZZBigView.h"

@interface RecipeDetailViewController ()
<
TYPagerViewDataSource,
TYPagerViewDelegate,
TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *tabBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (nonatomic ,strong) NSArray *datas;
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerView *pageView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, copy) NSString *recipe_name;
@property (nonatomic, strong) RecipeOrderDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *expressArr;

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"订单详情";
    self.datas = @[@"处方详情",@"处方日志",@"物流详情"];
    self.currentTag = [[self.param valueForKey:@"type"] integerValue];
    self.recipe_name = [self.param valueForKey:@"recipe_name"];
    self.detailModel = [[RecipeOrderDetailModel alloc]init];
    
    [self addPageTabBar];
    [self addPagerView];
    [self loadData];
    [self requestDetail];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)openClick:(id)sender {
    if(self.currentTag == 0) {
        BOOL found = NO;
        for (BaseViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[CreateRecipeViewController class]]) {
                found = YES;
                CreateRecipeViewController *createRecipeVC = (CreateRecipeViewController *)viewController;
                createRecipeVC.param = @{@"model": self.detailModel.recipeModel, @"isBack": @"1"};
                [self.navigationController popToViewController:createRecipeVC animated:YES];
                break;
            }
        }
        
        if (!found) {

            
            [self pushVC:@"CreateRecipeViewController" param:@{@"model": self.detailModel.recipeModel} animated:YES];
        }
        
    }else {
        BOOL found = NO;
        for (BaseViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MyCreateRecipeViewController class]]) {
                found = YES;
                MyCreateRecipeViewController *createRecipeVC = (MyCreateRecipeViewController *)viewController;
                createRecipeVC.param = @{@"model": self.detailModel.recipeModel, @"isBack": @"1"};
                [self.navigationController popToViewController:createRecipeVC animated:YES];
                break;
            }
        }
        
        if (!found) {

            
            [self pushVC:@"MyCreateRecipeViewController" param:@{@"model": self.detailModel.recipeModel} animated:YES];
        }
        
    }
   
}

- (void)requestDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.recipe_name forKey:@"recipe_name"];
    [[RequestManager shareInstance]requestWithMethod:POST url:self.currentTag == 0? SeeRecipeURL : RecipeHosDetailURL dict:dic hasHeader:YES finished:^(id request) {
        RecipeOrderDetailModel *model = [RecipeOrderDetailModel mj_objectWithKeyValues:request];
        model.recipeModel = [RecipeOrderItemModel mj_objectWithKeyValues:model.recipe];
        for (DrugItemModel *subModel in model.recipedetail) {
            NSDecimalNumber *numDecimal = [NSDecimalNumber decimalNumberWithString: subModel.herb_dose];
            NSString *numString = [NSString stringWithFormat:@"%@", numDecimal];
            subModel.herb_dose = numString;
            
            NSDecimalNumber *numDecimalr = [NSDecimalNumber decimalNumberWithString: subModel.equivalent];
            NSString *numStringr = [NSString stringWithFormat:@"%@", numDecimalr];
            subModel.equivalent = numStringr;
            
            if(subModel.herb_factor.length> 0 &&[subModel.herb_factor floatValue]<1) {
                subModel.granule_name = [NSString stringWithFormat:@"%@[新标准]", subModel.granule_name];
            }
            
        }
        self.detailModel =  model;
        [self.tableView reloadData];
        
        if(self.currentTag == 0) {
            [self requestExpress];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestExpress {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.detailModel.recipeModel.recipe_id forKey:@"recipe_id"];
    [[RequestManager shareInstance]requestWithMethod:GET url:ExpressDetailURL dict:dic hasHeader:YES finished:^(id request) {
        ExpressListModel *model = [ExpressListModel mj_objectWithKeyValues:request[@"data"]];
        self.expressArr = model.logisticsTraceDetails.mutableCopy;
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)addPageTabBar {
    self.tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, 0, WIDE, self.tabBackView.height)];
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
    [self.tabBackView addSubview:self.tabBar];
}

- (void)addPagerView {
    self.pageView = [[TYPagerView alloc]init];
    self.pageView.scrollView.bounces = NO;
    self.pageView.layout.autoMemoryCache = NO;
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    [self.pageView.layout registerClass:[UITableView class] forItemWithReuseIdentifier:@"cellId"];
    [self.detailBackView addSubview:self.pageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageView.frame = CGRectMake(0, 0, WIDE, HIGHT - NAV_H - self.tabBackView.height - 60 - Indicator_H);
}


- (void)reloadData {
    [self.tabBar reloadData];
    [self.pageView reloadData];
}

- (void)loadData {
    [self reloadData];
}

#pragma mark -- TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.datas[index];
    return cell;
}


#pragma mark -- TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return floor(WIDE/3.0 - 10);
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pageView scrollToViewAtIndex:index animate:YES];
}

#pragma mark -- TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.datas.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    UIView *view = [[UIView alloc]initWithFrame:[pagerView.layout frameForItemAtIndex:index]];
    view.backgroundColor = COLOR_F8F5EF;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height) style:UITableViewStyleGrouped];
    if(index > 0) {
        tableView.frame = CGRectMake(15, 15, view.width - 30, view.height - 30);
        tableView.layer.masksToBounds = YES;
        tableView.layer.cornerRadius = 10;
        tableView.layer.borderWidth = 1;
        tableView.layer.borderUIColor = COLOR_C8975E;
        tableView.backgroundColor = [UIColor redColor];
        tableView.backgroundColor = COLOR_FFFFFF;
        tableView.separatorColor = COLOR_FFFFFF;
       
       
    }else {
        tableView.backgroundColor = COLOR_F8F5EF;
        tableView.separatorColor = COLOR_F8F5EF;
    }
    tableView.tag = index;
    tableView.delegate = self;
    tableView.dataSource = self;
   
    if (@available(iOS 11.0, *)) {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        
    }
    self.tableView = tableView;
    [view addSubview:self.tableView];
    return view;
}



#pragma mark -- TYPagerViewDelegate
- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
   
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}


#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag  == 1) {
        return self.detailModel.recipeLogList.count;
    }else if(tableView.tag == 2) {
        if(self.expressArr.count == 0) {
            return 1;
        }
        return self.expressArr.count;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        if(self.currentTag == 0) {
            return [RecipeDetailTableViewCell getCellHeightWith:indexPath modelWith:self.detailModel.recipeModel detailModelWith:self.detailModel];
        }else {
            return [RecipeHosTableViewCell getCellHeightWith:indexPath modelWith:self.detailModel.recipeModel detailModelWith:self.detailModel];
        }
       
    }else {
        if(tableView.tag == 1) {
            RecipeLogItemModel *subModel = self.detailModel.recipeLogList[indexPath.row];
            return [RecipeLogTableViewCell getCellHeightWithModel:subModel];
        }else {
            if(self.expressArr.count == 0 ) {
                return 100;
            }
            return [RecipeLogTableViewCell getCellHeightWith:self.expressArr[indexPath.row]];
        }
        
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        if(self.currentTag == 0) {
            RecipeDetailTableViewCell *cell = [RecipeDetailTableViewCell getTableView:tableView indexPathWith:indexPath];
            cell.model = self.detailModel.recipeModel;
            cell.detailModel = self.detailModel;
            @weakify(self);
            [[[cell.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                self.detailModel.isExpand = !self.detailModel.isExpand;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            return cell;
        }else {
            RecipeHosTableViewCell *cell = [RecipeHosTableViewCell getTableView:tableView indexPathWith:indexPath];
            cell.model = self.detailModel.recipeModel;
            cell.detailModel = self.detailModel;
            @weakify(self);
            [[[cell.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                self.detailModel.isExpand = !self.detailModel.isExpand;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            return cell;
        }
        
        
    }else {
        if(self.expressArr.count == 0 && tableView.tag == 2) {
            NoDataTableViewCell *cell = [NoDataTableViewCell getTableView:tableView indexPathWith:indexPath];
            return cell;
        }else {
            RecipeLogTableViewCell *cell = [RecipeLogTableViewCell getTableView:tableView indexPathWith:indexPath];
            if(tableView.tag == 1) {
                RecipeLogItemModel *model = self.detailModel.recipeLogList[indexPath.row];
                model.isLast = indexPath.row == self.detailModel.recipeLogList.count -1;
                if(self.detailModel.recipeLogList.count == 1) {
                    model.isLast = YES;
                }
                cell.model = model;
            }else {
                ExpressItemModel *model = self.expressArr[indexPath.row];
                model.isLast = indexPath.row == self.expressArr.count -1;
                if(self.expressArr.count == 1) {
                    model.isLast = YES;
                }
                cell.expressModel = model;
            }
            return cell;
        }
        
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSMutableArray *)expressArr {
    if(!_expressArr) {
        _expressArr = [NSMutableArray array];
    }
    return _expressArr;
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
