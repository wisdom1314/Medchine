//
//  PrescriptionViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import "PrescriptionViewController.h"
#import "DateTimeTool.h"
#import "PrescriptionHeaderView.h"
#import "PrescriptionTableViewCell.h"
#import "PrescriptionTableHeaderView.h"
#import "HomeModel.h"
#import "PromoteAlertView.h"
@interface PrescriptionViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *dateStart;
@property (nonatomic, copy) NSString *dateEnd;
@property (nonatomic, strong) PrescriptionHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PromoteAlertView *alertView;


@end

@implementation PrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateStart = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    self.dateEnd = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    [self.headerView.chooseBtn setTitle:[NSString stringWithFormat:@"%@~%@",self.dateStart, self.dateEnd] forState:UIControlStateNormal];
    @weakify(self);
    [self.alertView.commitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.dateStart = [x valueForKey:@"date1"];
        self.dateEnd = [x valueForKey:@"date2"];
        [self.headerView.chooseBtn setTitle:[NSString stringWithFormat:@"%@~%@",self.dateStart, self.dateEnd] forState:UIControlStateNormal];
        [self requestData];
    }];
    self.alertView.frame = CGRectMake(0, NAV_H, WIDE, HIGHT - NAV_H);
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
    
    [[self.headerView.chooseBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.alertView show];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PrescriptionTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PrescriptionTableHeaderViewId"];
    [self requestData];
    [[self.headerView.segmentControll rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(__kindof UISegmentedControl * _Nullable x) {
        @strongify(self);
        NSInteger selectedIndex = x.selectedSegmentIndex;
        if(selectedIndex == 0) {
            self.dateStart = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
            self.dateEnd = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
        }else if(selectedIndex == 1) {
            
            self.dateStart = [DateTimeTool stringFromDate:[DateTimeTool getYesterday] DateFormat:@"yyyy-MM-dd"];
            self.dateEnd = [DateTimeTool stringFromDate:[DateTimeTool getYesterday] DateFormat:@"yyyy-MM-dd"];
            
        }else if(selectedIndex == 2) {
            self.dateStart = [DateTimeTool stringFromDate:[DateTimeTool getLast7DaysRange][@"startDate"] DateFormat:@"yyyy-MM-dd"];
            self.dateEnd = [DateTimeTool stringFromDate:[DateTimeTool getLast7DaysRange][@"endDate"] DateFormat:@"yyyy-MM-dd"];
        }else {
            self.dateStart = [DateTimeTool stringFromDate:[DateTimeTool getLast30DaysRange][@"startDate"] DateFormat:@"yyyy-MM-dd"];
            self.dateEnd = [DateTimeTool stringFromDate:[DateTimeTool getLast30DaysRange][@"endDate"] DateFormat:@"yyyy-MM-dd"];
        }
        [self requestData];
        NSLog(@"选中项：%ld", (long)selectedIndex);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
   
    self.headerView.frame = CGRectMake(0, 0, WIDE, 115);
    [self.view addSubview:self.headerView];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.dateStart forKey:@"dateStart"];
    [dic setValue:self.dateEnd forKey:@"dateEnd"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:RecipeDailyAmountURL dict:dic hasHeader:YES finished:^(id request) {
        RecipeDailyModel *model = [RecipeDailyModel mj_objectWithKeyValues:request];
        self.dataArray = [model.data mutableCopy];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrescriptionTableViewCell *cell = [PrescriptionTableViewCell getTableView:tableView indexPathWith:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PrescriptionTableViewCell getCellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PrescriptionTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PrescriptionTableHeaderViewId"];
    headerView.contentView.backgroundColor = COLOR_FFFFFF;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 115, WIDE - 30, HIGHT - NAV_H - Indicator_H - 125 - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_FFFFFF;
        _tableView.separatorColor = COLOR_FFFFFF;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.borderUIColor = COLOR_C8975E;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 10.f;
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            
            
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (PrescriptionHeaderView *)headerView {
    if(!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"PrescriptionHeaderView" owner:self options:nil].lastObject;
    }
    return _headerView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (PromoteAlertView *)alertView {
    if(!_alertView) {
        _alertView = [[NSBundle mainBundle]loadNibNamed:@"PromoteAlertView" owner:self options:nil].lastObject;
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
