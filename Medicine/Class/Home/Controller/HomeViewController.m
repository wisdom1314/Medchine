//
//  HomeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "HomeViewController.h"
#import <SDCycleScrollView.h>
#import "WelcomeTableViewCell.h"
#import "StatisticsTableViewCell.h"
#import "PwdPromptView.h"
#import "HomeModel.h"
#import "ShowQrcodeView.h"
#import "SGCreateCode.h"
#import "DateTimeTool.h"

@interface HomeViewController ()
<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, assign) BOOL isTG;///     是否推广
@property (nonatomic, copy) NSString *dateStart;
@property (nonatomic, copy) NSString *dateEnd;
@property (nonatomic, copy) NSString *agentCount;
@property (nonatomic, copy) NSString *inviteCount;
@property (nonatomic, copy) NSString *recipeAmount;
@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestBannerList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleImage];
    [self initialize];
    self.dateStart = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    self.dateEnd = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    self.isTG = [MedicineManager sharedInfo].customModel.promoteUrl.length>0? YES: NO;
    self.agentCount = self.inviteCount = self.recipeAmount = @"0";
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)initialize {
    if([ClassMethod getStringBy:@"needUpdatePwd"]) { 
        PwdPromptView *promptView = [PwdPromptView createViewFromNib];
        TYAlertController *alertVC =  [TYAlertController alertControllerWithAlertView:promptView preferredStyle:TYAlertControllerStyleAlert];
        alertVC.backgoundTapDismissEnable = NO;
        [[promptView.cacelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"needUpdatePwd"];
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[promptView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"needUpdatePwd"];
            [self pushVC:@"ChangePwdViewController" animated:YES];
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    [self.view addSubview:self.tableView];
    self.scrollView.imageURLStringsGroup = @[];
    
}

- (void)requestBannerList {
    [[RequestManager shareInstance]requestWithMethod:POST url:LoopImagesURL dict:nil finished:^(id request) {
        NSMutableArray *imgArr = [NSMutableArray array];
        BannerModel *model = [BannerModel mj_objectWithKeyValues:request];
        for (BannerPicModel *subModel in model.images) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@", BaseURL, subModel.picurl]];
        }
        self.scrollView.imageURLStringsGroup = imgArr;
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestData {
    [self requestHomeDataWith:PromoteAgentCountURL];
    [self requestHomeDataWith:PromoteInviteCountURL];
    [self requestHomeDataWith:PromoteRecipeAmountSumURL];
}

- (void)requestHomeDataWith:(NSString *)url {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].customModel.userId forKey:@"promoteUserId"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [dic setValue:@"1" forKey:@"includeSon"];
    [dic setValue:self.dateStart forKey:@"dateStart"];
    [dic setValue:self.dateEnd forKey:@"dateEnd"];
    [[RequestManager shareInstance]requestWithMethod:GET url:url dict:dic hasHeader:YES finished:^(id request) {
        if([[request allKeys]containsObject:@"data"]) {
            if([url isEqualToString:PromoteAgentCountURL]) {
                self.agentCount = [NSString stringWithFormat:@"%@", request[@"data"]];
            }else if([url isEqualToString:PromoteInviteCountURL]) {
                self.inviteCount = [NSString stringWithFormat:@"%@", request[@"data"]];
            }else {
                self.recipeAmount = [NSString stringWithFormat:@"%@", request[@"data"]];
            }
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark  -- UITableViewDelegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        WelcomeTableViewCell *cell = [WelcomeTableViewCell getTableView:tableView indexPathWith:indexPath];
        if(self.isTG) {
            UIImage *qrcodeImage = [SGCreateCode createQRCodeWithData:[MedicineManager sharedInfo].customModel.inviteUrl size:40 color:MainColor backgroundColor:COLOR_FFFFFF];
            [cell.recommandBtn setImage:qrcodeImage forState:UIControlStateNormal];
            [cell.changeBtn setTitle:@"推广码" forState:UIControlStateNormal];
        }else {
            UIImage *qrcodeImage = [SGCreateCode createQRCodeWithData:[MedicineManager sharedInfo].customModel.promoteUrl size:40 color:MainColor backgroundColor:COLOR_FFFFFF];
            [cell.recommandBtn setImage:qrcodeImage forState:UIControlStateNormal];
            [cell.changeBtn setTitle:@"邀请码" forState:UIControlStateNormal];
        }
        
        @weakify(self);
        [[[cell.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.isTG = !self.isTG;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [[[cell.recommandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            ShowQrcodeView *qrcodeView = [ShowQrcodeView createViewFromNib];
            qrcodeView.isTG = self.isTG;
            TYAlertController *alertVC =  [TYAlertController alertControllerWithAlertView:qrcodeView preferredStyle:TYAlertControllerStyleAlert];
            alertVC.backgoundTapDismissEnable = YES;
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
        return cell;
    }else {
        StatisticsTableViewCell *cell = [StatisticsTableViewCell getTableView:tableView indexPathWith:indexPath];
        cell.tgNumLab.text = self.agentCount;
        cell.inviateLab.text = self.inviteCount;
        cell.priceLab.text = [ClassMethod stringWithDecimalNumber:[self.recipeAmount doubleValue]];
        
        @weakify(self);
        [[[cell.seeDetailBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"DetailViewController" animated:YES];
        }];
        [[[cell.segment rac_signalForControlEvents:UIControlEventValueChanged]takeUntil:cell.rac_prepareForReuseSignal]
         subscribeNext:^(__kindof UISegmentedControl * _Nullable x) {
            @strongify(self);
            NSInteger selectedIndex = x.selectedSegmentIndex;
            if(selectedIndex == 0) {
                self.dateStart = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
                self.dateEnd = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
            }else if(selectedIndex == 1) {
                self.dateStart = [DateTimeTool stringFromDate:[DateTimeTool getFirstDayOfCurrentMonth] DateFormat:@"yyyy-MM-dd"];
                self.dateEnd = [DateTimeTool stringFromDate:[DateTimeTool getLastDayOfCurrentMonth] DateFormat:@"yyyy-MM-dd"];
                
            }else if(selectedIndex == 2) {
                self.dateStart = [DateTimeTool stringFromDate:[DateTimeTool getFirstDayOfCurrentYear] DateFormat:@"yyyy-MM-dd"];
                self.dateEnd = [DateTimeTool stringFromDate:[DateTimeTool getLastDayOfCurrentYear] DateFormat:@"yyyy-MM-dd"];
            }else {
                self.dateStart = @"";
                self.dateEnd = @"";
            }
            
            [self requestData];
            NSLog(@"选中项：%ld", (long)selectedIndex);
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return (indexPath.section == 0 )?70: 165;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    
}

#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT - NAV_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_F8F5EF;
        _tableView.separatorColor = COLOR_F8F5EF;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            
        }
        UIView *headerView = [ClassMethod createViewFrameWith:CGRectMake(0, 0, WIDE, 200*WIDES) backColorWith:COLOR_F8F5EF];
        [headerView addSubview:self.scrollView];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (SDCycleScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 10, WIDE-30, 200*WIDES - 20) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        _scrollView.backgroundColor = COLOR_F8F5EF;
        _scrollView.currentPageDotColor = MainColor;
        _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.autoScrollTimeInterval = 5;
    }
    return _scrollView;
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
