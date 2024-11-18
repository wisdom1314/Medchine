//
//  CustomRecipeTablesView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import "CustomRecipeTablesView.h"
#import "MemberInfoTableViewCell.h"
#import "HomeModel.h"
@interface CustomRecipeTablesView ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *nodataView;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *keyWordStr;
@property (nonatomic, copy) NSString *dateStart;
@property (nonatomic, copy) NSString *dateEnd;
@property (nonatomic, copy) NSString *promoteUserId;
@property (nonatomic, assign) BOOL isHos;

@end

@implementation CustomRecipeTablesView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    [self.tableView.mj_header beginRefreshing];
    
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
    [dic setValue:self.promoteUserId forKey:@"promoteUserId"];
    [dic setValue:@"1" forKey:@"includeSon"];
    [dic setValue:@10 forKey:@"pageSize"];
    [dic setValue:@(self.currentPage) forKey:@"pageNum"];
    [dic setValue:self.status forKey:@"status"];
    [dic setValue:self.keyWordStr forKey:@"keywords"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [dic setValue:self.dateStart forKey:@"dateStart"];
    [dic setValue:self.dateEnd forKey:@"dateEnd"];
    [[RequestManager shareInstance]requestWithMethod:GET url:self.isHos? HospitalsListURL: PromoteAgentsListURL dict:dic hasHeader:YES finished:^(id request) {
        if(self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [PromoteUserBaseModel class]
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)setType:(NSInteger)type {
    _type = type;
    if(self.isHos) {
        if(type == 0)  {
            self.status = @"";
        }else if(type == 1) {
            self.status = @"10";
        }else if(type == 2) {
            self.status = @"11";
        }else if(type == 3) {
            self.status = @"20";
        }else {
            self.status = @"30";
        }
    }else {
        if(type == 0)  {
            self.status = @"";
        }else if(type == 1) {
            self.status = @"10";
        }else if(type == 2) {
            self.status = @"20";
        }else {
            self.status = @"30";
        }
    }
    [self refresh];
}

- (void)setKeyWord:(NSString *)keyWord {
    _keyWord = keyWord;
    self.keyWordStr = keyWord;
}

- (void)setDate1:(NSString *)date1 {
    _date1 = date1;
    self.dateStart = date1;
}

- (void)setDate2:(NSString *)date2 {
    _date2 = date2;
    self.dateEnd = date2;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    self.promoteUserId = userId;
}

- (void)setIsDoctor:(BOOL)isDoctor {
    _isDoctor = isDoctor;
    self.isHos = isDoctor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberInfoTableViewCell *cell = [MemberInfoTableViewCell getTableView:tableView indexPathWith:indexPath];
    PromoteUserBaseModel *model = self.dataArray[indexPath.row];
    model.isHos = self.isHos;
    cell.model = model;
    [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if(self.isHos) {
            if([model.status integerValue] == 20) {
                 /// 处方订单
                [[UIViewController currentViewController] pushVC:@"CustomRecipeViewController"  animated:YES];
            }else {
                [[UIViewController currentViewController] pushVC:@"DoctorDetailVC" param:@{@"userId":model.hospitalId} animated:YES];
            }
        }else {
            if([model.status integerValue] == 20) {
                [[UIViewController currentViewController] pushVC:@"AssistantPassedVC" param:@{@"userId":model.user_id} animated:YES];
            }else {
        
                [[UIViewController currentViewController] pushVC:@"AssistantDetailVC" param:@{@"userId":model.user_id, @"nickName": model.promoteUser.nickName} backBlock:^(NSDictionary * _Nonnull dic) {
                    [self refresh];
                } animated:YES];
            }
            
        }
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PromoteUserBaseModel *model = self.dataArray[indexPath.row];
    return [MemberInfoTableViewCell getCellHeightWith:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PromoteUserBaseModel *model = self.dataArray[indexPath.row];
    if(self.isHos) {
        if([model.status integerValue] == 20) {
            [[UIViewController currentViewController] pushVC:@"CustomRecipeViewController"  animated:YES];
        }else {
            [[UIViewController currentViewController] pushVC:@"DoctorDetailVC" param:@{@"userId":model.hospitalId} animated:YES];
        }
    }else {
        if([model.status integerValue] == 20) {
            [[UIViewController currentViewController] pushVC:@"AssistantPassedVC" param:@{@"userId":model.user_id} animated:YES];
        }else {
            [[UIViewController currentViewController] pushVC:@"AssistantDetailVC" param:@{@"userId":model.user_id, @"nickName": model.promoteUser.nickName} backBlock:^(NSDictionary * _Nonnull dic) {
                [self refresh];
            } animated:YES];
        }
    }
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)nodataView {
    if(!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDE, self.height)];
        UILabel *lab = [ClassMethod createLabelWithFrame:CGRectMake(0, 100, _nodataView.width, 20) Font:14 Text:@"暂无数据"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = COLOR_C8975E;
        [_nodataView addSubview:lab];
        [self addSubview:_nodataView];
    }
    return _nodataView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
