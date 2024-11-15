//
//  HistoryDoctorOrderListVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "HistoryDoctorOrderListVC.h"
#import "HistoryDoctorOrderCell.h"
#import "HomeModel.h"

@interface HistoryDoctorOrderListVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentTag;

@end

@implementation HistoryDoctorOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"历史处方";
    self.currentTag = [[self.param valueForKey:@"type"] integerValue];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)refresh {
    self.currentPage = 1;
    [self requestData];
}

- (void)loadMore {
    self.currentPage++;
    [self requestData];
}


- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forKey:@"hospital_id"];
    [dic setValue:@"" forKey:@"payment_status"];
    [dic setValue:@"" forKey:@"recipe_status"];

    [[RequestManager shareInstance]requestWithMethod:POST url: self.currentTag ==0? RecipeListURL : RecipeHosListURL    dict:dic  hasHeader:YES  finished:^(id request) {
        if(self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [RecipeOrderItemModel class]
            };
        }];
        model.listModel = [PageListModel mj_objectWithKeyValues:model.list];
 
        [self.dataArray addObjectsFromArray:model.listModel.data];
        [self.tableView reloadData];
        
        self.nodataView.y = self.tableView.y;
        self.nodataView.height = self.tableView.height;
        self.nodataView.hidden = (self.dataArray.count != 0)?YES:NO;
        
        if([model.listModel.current_page integerValue] >= [model.listModel.last_page integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
            
        }
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryDoctorOrderCell *cell = [HistoryDoctorOrderCell getTableView:tableView indexPathWith:indexPath];
    
    RecipeOrderItemModel *subModel = self.dataArray[indexPath.row];
    @weakify(self);
    [[[cell.topBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{@"model":subModel});
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    cell.model = subModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return  [HistoryDoctorOrderCell getCellHeightWith:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeOrderItemModel *subModel = self.dataArray[indexPath.row];
    [self pushVC:@"RecipeDetailViewController" param:@{@"recipe_name": subModel.recipe_name, @"type": @(self.currentTag)} animated:YES];
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
