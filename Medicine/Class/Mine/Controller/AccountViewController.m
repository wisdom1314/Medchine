//
//  AccountViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/26.
//

#import "AccountViewController.h"
#import "TradingTableViewCell.h"
#import "TimeRangeView.h"
#import <PGDatePicker.h>
#import "PGPickerView+Swizzling.h"
#import "TradingTypeView.h"
#import "HomeModel.h"
#import "MineModel.h"

@interface AccountViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (nonatomic, strong) TimeRangeView *timeRangeView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) TradingTypeView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneylab;
@property (weak, nonatomic) IBOutlet UILabel *costMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *creditLineLab;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *operatorStartTime;
@property (nonatomic, copy) NSString *operatorEndTime;
@property (nonatomic, copy) NSString *type;
@end

@implementation AccountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"账户中心";
    if([[self.param allKeys]containsObject:@"source"]) {
        self.fd_interactivePopDisabled = YES;
    }
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        
    }
    
    [self.backView addSubview:self.timeRangeView];
    [self.backView addSubview:self.typeView];
    
    [self.timeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [self.typeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    @weakify(self);
    [[self.timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.timeBtn.selected = !self.timeBtn.selected;
        self.backView.hidden = self.timeRangeView.hidden = !self.timeBtn.isSelected;
        self.typeView.hidden = YES;
        self.typeBtn.selected = NO;
    }];
    
    [[self.typeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.typeBtn.selected = !self.typeBtn.selected;
        self.backView.hidden = self.typeView.hidden = !self.typeBtn.isSelected;
        self.timeRangeView.hidden = YES;
        self.timeBtn.selected = NO;
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    [self requestAccountInfo];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[self.param allKeys]containsObject:@"source"]) {
        [self refresh];
        [self requestAccountInfo];
    }
    self.rechageBtn.hidden = NO;
//    [self requestLimit];

}

- (void)requestLimit {
    [[RequestManager shareInstance]requestWithMethod:GET url:RelatedPharmacyURL dict:nil hasHeader: YES finished:^(id request) {
        SelfPickModel *model = [SelfPickModel mj_objectWithKeyValues:request[@"data"]];
        if([model.isSelfSupport integerValue] == 1) {
            self.rechageBtn.hidden = NO;
        }else {
            self.rechageBtn.hidden = YES;
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestAccountInfo {
    [[RequestManager shareInstance]requestWithMethod:GET url:AccountDecURL dict:nil hasHeader: YES finished:^(id request) {
        BaseDataModel *model = [BaseDataModel mj_objectWithKeyValues:request];
        AccountInfoModel *infoModel = [AccountInfoModel mj_objectWithKeyValues:model.data];
        self.balanceLab.text = infoModel.balance;
        self.costMoneyLab.text = infoModel.costMoney;
        self.totalMoneylab.text = infoModel.totalMoney;
        self.creditLineLab.text = infoModel.creditLine;
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [dic setValue:self.operatorEndTime forKey:@"operatorEndTime"];
    [dic setValue:self.operatorStartTime forKey:@"operatorStartTime"];
    [dic setValue:self.type forKey:@"type"];
    [[RequestManager shareInstance]requestWithMethod:GET url:GetOrgTransLogListURL dict:dic  hasHeader:YES  finished:^(id request) {
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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

- (IBAction)moreClick:(id)sender {
    [self pushVC:@"TradingRecordViewController" animated:YES];
}


#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    TransLogModel *model = self.dataArray[indexPath.row];
    return [TradingTableViewCell getCellHeightWith:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}
- (IBAction)rechargeClick:(id)sender {
    [self pushVC:@"RechargeViewController" animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.timeRangeView.frame = CGRectMake(0, 0, self.backView.width, self.backView.height);
    self.typeView.frame = CGRectMake(0, 0, self.backView.width, self.backView.height);
}

#pragma mark -- LazyMethod
- (TimeRangeView *)timeRangeView {
    if(!_timeRangeView) {
        _timeRangeView = [[NSBundle mainBundle]loadNibNamed:@"TimeRangeView" owner:self options:nil].lastObject;
        _timeRangeView.frame = CGRectMake(0, 0, self.backView.width, self.backView.height);
        _timeRangeView.hidden = YES;
        
        @weakify(self);
        [_timeRangeView.subject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.backView.hidden = self.timeRangeView.hidden = YES;
            self.timeBtn.selected  = NO;
            self.typeView.hidden = YES;
            self.typeBtn.selected = NO;
            self.operatorEndTime = [x valueForKey:@"operatorEndTime"];
            self.operatorStartTime = [x valueForKey:@"operatorStartTime"];
            [self refresh];
        }];

    }
    return _timeRangeView;
}

- (TradingTypeView *)typeView {
    if(!_typeView) {
        _typeView = [[NSBundle mainBundle]loadNibNamed:@"TradingTypeView" owner:self options:nil].lastObject;
        _typeView.frame = CGRectMake(0, 0, self.backView.width, self.backView.height);
        _typeView.hidden = YES;
        
        @weakify(self);
        [_typeView.subject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.backView.hidden = self.typeView.hidden = YES;
            self.typeBtn.selected  = NO;
            self.type = [NSString stringWithFormat:@"%@", x];
            self.timeBtn.selected = NO;
            self.timeRangeView.hidden = YES;
            [self refresh];
        }];
    }
    return _typeView;
}


- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)shouldBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
