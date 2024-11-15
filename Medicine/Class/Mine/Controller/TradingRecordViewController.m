//
//  TradingRecordViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import "TradingRecordViewController.h"
#import <TYTabPagerBar.h>
#import <TYPagerView.h>
#import "TradingHeaderView.h"
#import "TradingTableViewCell.h"
#import "TimeRangeView.h"

@interface TradingRecordViewController ()
<
TYPagerViewDataSource,
TYPagerViewDelegate,
TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic ,strong) NSArray *datas;
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerView *pageView;
@property (nonatomic ,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *effectView;
@property (nonatomic, strong) TimeRangeView *timeRangeView1;
@property (nonatomic, strong) TimeRangeView *timeRangeView2;
@property (nonatomic, assign) BOOL isTimeSelected;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (nonatomic, copy) NSString *operatorEndTime1;
@property (nonatomic, copy) NSString *operatorStartTime1;

@property (nonatomic, copy) NSString *operatorEndTime2;
@property (nonatomic, copy) NSString *operatorStartTime2;
@end

@implementation TradingRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"交易记录";
    self.datas = @[@"余额明细",@"充值记录"];
    [self addPageTabBar];
    [self addPagerView];
    [self loadData];
    [self requestAccountInfo];
    [self.effectView addSubview:self.timeRangeView1];
    [self.effectView addSubview:self.timeRangeView2];
    [self.topView bringSubviewToFront:self.effectView];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestAccountInfo {
    [[RequestManager shareInstance]requestWithMethod:GET url:AccountDecURL dict:nil hasHeader: YES finished:^(id request) {
        BaseDataModel *model = [BaseDataModel mj_objectWithKeyValues:request];
        AccountInfoModel *infoModel = [AccountInfoModel mj_objectWithKeyValues:model.data];
        self.balanceLab.text = infoModel.balance;
    } failed:^(NSError *error) {
        
    }];
}


- (void)requestData {
    self.type = self.pageView.curIndex == 0? @"1":@"0";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [dic setValue:self.type forKey:@"type"];
    if(self.pageView.curIndex == 0) {
        [dic setValue:self.operatorEndTime1 forKey:@"operatorEndTime"];
        [dic setValue:self.operatorStartTime1 forKey:@"operatorStartTime"];
    }else {
        [dic setValue:self.operatorEndTime2 forKey:@"operatorEndTime"];
        [dic setValue:self.operatorStartTime2 forKey:@"operatorStartTime"];
    }
    [[RequestManager shareInstance]requestWithMethod:GET url:GetOrgPayListURL dict:dic  hasHeader:YES  finished:^(id request) {
        if(self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [TransLogModel class]
            };
        }];
        model.listModel = [PageListModel mj_objectWithKeyValues:model.list];
 
        [self.dataArray addObjectsFromArray:model.listModel.data];
        [self.tableView reloadData];
        
        if([model.listModel.current_page integerValue] >= [model.listModel.last_page integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
            
        }
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)refresh {
    self.currentPage = 1;
    [self requestData];
}

- (void)loadMore {
    self.currentPage++;
    [self requestData];
}


- (void)addPageTabBar {
    self.tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, 0, WIDE - 30, 55)];
    self.tabBar.backgroundColor = COLOR_FFFFFF;
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.normalTextColor = COLOR_562306;
    self.tabBar.layout.selectedTextColor = MainColor;
    self.tabBar.layout.progressColor = MainColor;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15];
    self.tabBar.layout.progressWidth  = 80;
    self.tabBar.layout.cellSpacing = 0;
    self.tabBar.layout.cellEdging = 0;
    self.tabBar.collectionView.scrollEnabled = NO;
    self.tabBar.progressView.layer.cornerRadius = 2;
    self.tabBar.progressView.layer.masksToBounds = YES;
    self.tabBar.dataSource = self;
    self.tabBar.delegate = self;
    [self.tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.topView addSubview:self.tabBar];
    
    [self.tabBar addBottomBorderWithColor:COLOR_E2C8A9 width:0.5];
}

- (void)addPagerView {
    self.pageView = [[TYPagerView alloc]init];
    self.pageView.scrollView.bounces = NO;
    self.pageView.layout.autoMemoryCache = NO;
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    [self.pageView.layout registerClass:[UITableView class] forItemWithReuseIdentifier:@"cellId"];
    [self.topView addSubview:self.pageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageView.frame = CGRectMake(0, 55, WIDE - 30, self.topView.height);
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
    return self.tabBar.width/self.datas.count;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    self.timeRangeView1.hidden = YES;
    self.timeRangeView2.hidden = YES;
    self.isTimeSelected = NO;
    self.effectView.hidden = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.pageView scrollToViewAtIndex:index animate:YES];
}

#pragma mark -- TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.datas.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    UITableView *tableView = [[UITableView alloc]initWithFrame:[pagerView.layout frameForItemAtIndex:index] style:UITableViewStyleGrouped];
    tableView.separatorColor = COLOR_E2C8A9;
    tableView.tag = index;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"TradingHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"TradingHeaderViewId"];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [tableView.mj_header beginRefreshing];
    self.tableView = tableView;
    return tableView;
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransLogModel *model = self.dataArray[indexPath.row];
    return [TradingTableViewCell getCellHeightWith:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradingTableViewCell *cell = [TradingTableViewCell getTableView:tableView indexPathWith:indexPath];
    TransLogModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self);
    [[[cell.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(model.remark.length>0) {
            model.isExpand = !model.isExpand;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TradingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TradingHeaderViewId"];
    headerView.timeBtn.selected = self.isTimeSelected;
    if(self.pageView.curIndex == 0) {
        if(self.operatorStartTime1.length == 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            [headerView.timeBtn setTitle:dateString forState:UIControlStateNormal];
        }else {
            [headerView.timeBtn setTitle:[NSString stringWithFormat:@"%@~%@",self.operatorStartTime1,self.operatorEndTime1] forState:UIControlStateNormal];
        }
    }else {
        if(self.operatorStartTime2.length == 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            [headerView.timeBtn setTitle:dateString forState:UIControlStateNormal];
        }else {
            [headerView.timeBtn setTitle:[NSString stringWithFormat:@"%@~%@",self.operatorStartTime2,self.operatorEndTime2] forState:UIControlStateNormal];
        }
    }
    
    [[headerView.timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.isTimeSelected = !headerView.timeBtn.selected;
        if(self.pageView.curIndex == 0) {
            self.timeRangeView2.hidden = YES;
            self.effectView.hidden = self.timeRangeView1.hidden = !self.isTimeSelected;
            [self.timeRangeView1.beginTextF becomeFirstResponder];
        }else {
            self.timeRangeView1.hidden = YES;
            self.effectView.hidden = self.timeRangeView2.hidden = !self.isTimeSelected;
            [self.timeRangeView2.beginTextF becomeFirstResponder];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return headerView;
}
- (IBAction)rechargeClick:(id)sender {
    [self pushVC:@"RechargeViewController" animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.timeRangeView1.frame = CGRectMake(0, 0, self.effectView.width, self.effectView.height);
    self.timeRangeView2.frame = CGRectMake(0, 0, self.effectView.width, self.effectView.height);
}


#pragma mark -- LazyMethod
- (TimeRangeView *)timeRangeView1 {
    if(!_timeRangeView1) {
        _timeRangeView1 = [[NSBundle mainBundle]loadNibNamed:@"TimeRangeView" owner:self options:nil].lastObject;
        _timeRangeView1.frame = CGRectMake(0, 0, self.effectView.width, self.effectView.height);
        _timeRangeView1.hidden = YES;
        @weakify(self);
        [_timeRangeView1.subject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.effectView.hidden = self.timeRangeView1.hidden = YES;
            self.isTimeSelected = NO;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            self.operatorEndTime1 = [x valueForKey:@"operatorEndTime"];
            self.operatorStartTime1 = [x valueForKey:@"operatorStartTime"];
            [self refresh];
        }];
    }
    return _timeRangeView1;
}

- (TimeRangeView *)timeRangeView2 {
    if(!_timeRangeView2) {
        _timeRangeView2 = [[NSBundle mainBundle]loadNibNamed:@"TimeRangeView" owner:self options:nil].lastObject;
        _timeRangeView2.frame = CGRectMake(0, 0, self.effectView.width, self.effectView.height);
        _timeRangeView2.hidden = YES;
        @weakify(self);
        [_timeRangeView2.subject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.effectView.hidden = self.timeRangeView2.hidden = YES;
            self.isTimeSelected = NO;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            self.operatorEndTime2 = [x valueForKey:@"operatorEndTime"];
            self.operatorStartTime2 = [x valueForKey:@"operatorStartTime"];
            [self refresh];
        }];
    }
    return _timeRangeView2;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
