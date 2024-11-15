//
//  MineViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "MineViewController.h"
#import "InfoTableViewCell.h"
#import "InfoHeaderView.h"

@interface MineViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) InfoHeaderView *headerView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的";
    if([MedicineManager sharedInfo].isCustom) {
        self.dataArray = @[@{@"imgName": @"icon_help", @"title": @"帮助中心"},@{@"imgName": @"icon_set", @"title": @"设置"}];
    }else {
        self.dataArray = @[@{@"imgName": @"icon_sale", @"title": @"账户中心"},@{@"imgName": @"icon_sale", @"title": @"持正堂业务销售"},@{@"imgName": @"icon_help", @"title": @"帮助中心"},@{@"imgName": @"icon_set", @"title": @"设置"}];
    }
    
    self.headerView = [[NSBundle mainBundle]loadNibNamed:@"InfoHeaderView" owner:self options:nil].firstObject;
    self.headerView.backgroundColor = MainColor;
    self.headerView.frame = CGRectMake(0, 0, WIDE, 130);
    self.tableView.tableHeaderView = self.headerView;
    
    if([MedicineManager sharedInfo].isCustom) {
        self.headerView.nickNameLab.hidden = NO;
        self.headerView.nickNameLab.text = [MedicineManager sharedInfo].customModel.nickName;
        self.headerView.nameLab.hidden = YES;
    }else {
        self.headerView.nameLab.text = [NSString stringWithFormat:@"%@【%@】",[MedicineManager sharedInfo].doctorModel.doctorname, [MedicineManager sharedInfo].doctorModel.loginname];
        self.headerView.hosLab.text = [MedicineManager sharedInfo].hospitalModel.hospitalname;
    }
    
   
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoTableViewCell *cell = [InfoTableViewCell getTableView:tableView indexPathWith:indexPath];
    cell.imgView.image = [UIImage imageNamed:self.dataArray[indexPath.row][@"imgName"]];
    cell.textLab.text = self.dataArray[indexPath.row][@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [InfoTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([MedicineManager sharedInfo].isCustom) {
         if(indexPath.row == 0) {
            [self pushVC:@"HelpCenterViewController" animated:YES];
        }else {
            [self pushVC:@"SettingViewController" animated:YES];
        }
    }else {
        if(indexPath.row == 0) {
            [self pushVC:@"AccountViewController" animated:YES];
        }else if(indexPath.row == 1) {
            [self pushVC:@"BusinessViewController" animated:YES];
        }else if(indexPath.row == 2) {
            [self pushVC:@"HelpCenterViewController" animated:YES];
        }else {
            [self pushVC:@"SettingViewController" animated:YES];
        }
    }
   
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
        UIView *headerView = [ClassMethod createViewFrameWith:CGRectMake(0, 0, WIDE, 200*WIDES) backColorWith:COLOR_F8F5EF];
//        [headerView addSubview:self.scrollView];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
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
