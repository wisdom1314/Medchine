//
//  StatementViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import "StatementViewController.h"
#import "StatementTableViewCell.h"
#import "StatementAlertView.h"
#import "StatementModel.h"
#import "StatementHeaderView.h"
PaymentStatus const PaymentStatusAll = @"";
PaymentStatus const PaymentStatusWait = @"WAIT";
PaymentStatus const PaymentStatusPayed = @"PAYED";
PaymentStatus const PaymentStatusRefund = @"REFUND";

@interface StatementViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) StatementAlertView *alertView;
@property (nonatomic, copy) NSString *currentDoctorId;
@property (nonatomic, copy) NSString *payment_status;
@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *date2;
@property (nonatomic, copy) NSArray *paymentArray;
@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"颗粒统计";
    
    [self rightViewShowWithImg:@"icon_screen" titleWith:nil actionWith:@selector(showScreenClick)];
    
    self.paymentArray = @[@{@"id": PaymentStatusAll, @"value": @"全部"}, @{@"id": PaymentStatusWait, @"value": @"未缴费"}, @{@"id": PaymentStatusPayed, @"value": @"已缴费"}, @{@"id": PaymentStatusRefund, @"value": @"已退单"}];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StatementHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatementHeaderViewId"];
    
    self.currentDoctorId = [MedicineManager sharedInfo].doctorModel.doctor_id;
    
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.alertView];
    
    [self requestListData];
    [self requestDoctors];
    
    @weakify(self);
    [self.alertView.commitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.currentDoctorId = [x valueForKey:@"doctor_id"];
        self.payment_status = [x valueForKey:@"payment_status"];
        self.date1 = [x valueForKey:@"date1"];
        self.date2 = [x valueForKey:@"date2"];
        [self requestListData];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)showScreenClick {
    [self.alertView show];
}

- (void)requestListData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.currentDoctorId forKey:@"doctor_id"];
    [dic setValue:[MedicineManager sharedInfo].hospitalModel.hospital_id forKey:@"hospital_id"];
    [dic setValue:self.payment_status forKey:@"payment_status"];
    [dic setValue:self.date1 forKey:@"date1"];
    [dic setValue:self.date2 forKey:@"date2"];
    [[RequestManager shareInstance]requestWithMethod:POST url:GenReportURL dict:dic finished:^(id request) {
        [self.dataArray removeAllObjects];
        StatementModel *model = [StatementModel mj_objectWithKeyValues:request];
        [self.dataArray addObjectsFromArray:model.report_drug_list];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)requestDoctors {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].hospitalModel.hospital_id forKey:@"hospital_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SelectDoctorURL dict:dic finished:^(id request) {
        DoctorListModel *model = [DoctorListModel mj_objectWithKeyValues:request];
        self.alertView.doctorArray = model.doctor_list;
        self.alertView.paymentArray = self.paymentArray;
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- UITableViewDelegate && Sourcce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatementTableViewCell *cell = [StatementTableViewCell getTableView:tableView indexPathWith:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return  45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatementHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StatementHeaderViewId"];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT - NAV_H - TAB_H) style:UITableViewStyleGrouped];
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
    }
    return _tableView;
}


- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (StatementAlertView *)alertView {
    if(!_alertView) {
        _alertView = [[NSBundle mainBundle]loadNibNamed:@"StatementAlertView" owner:self options:nil].lastObject;
        _alertView.frame = CGRectMake(0, 0, WIDE, self.view.height);
    }
    return _alertView;
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
