//
//  CustomRecipeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import "CustomRecipeViewController.h"
#import "RecipeCustomAlertView.h"
#import "CustomRecipeTableViewCell.h"
#import "HomeModel.h"
@interface CustomRecipeViewController ()
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RecipeCustomAlertView *alertView;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *date2;
@property (nonatomic, copy) NSString *recipe_status;
@property (nonatomic, copy) NSString *doctorName;
@end

@implementation CustomRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"处方订单";
    [self initialize];
    // Do any additional setup after loading the view.
}

- (void)initialize {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, WIDE - 15, 45)];
    [self.view addSubview:headerView];
    UIButton *filterBtn = [[UIButton alloc]init];
    [filterBtn setImage:[UIImage imageNamed:@"icon_screen"] forState:UIControlStateNormal];
    [headerView addSubview:filterBtn];
    [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.width.height.mas_equalTo(45);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    @weakify(self)
    [[filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.alertView show];
    }];
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = COLOR_FFFFFF;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 4;
    [headerView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(0); // 左边距离父视图为 0
        make.top.equalTo(headerView.mas_top).offset(5); // 顶部距离父视图为 0
        make.bottom.equalTo(headerView.mas_bottom).offset(-5); // 底部距离父视图为 0
        make.right.equalTo(filterBtn.mas_left).offset(-5);
    }];
    
    UIImageView *searchImg = [ClassMethod createImgViewFrameWith:CGRectMake(10, 10, 15, 15) imageNamed:@"icon_search"];
    [searchView addSubview:searchImg];
    
    UITextField *searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, WIDE - 120,  35)];
    searchTextF.returnKeyType = UIReturnKeySearch;
    searchTextF.placeholder = @"请输入患者姓名/手机号/症状";
    searchTextF.borderStyle = UITextBorderStyleNone;
    searchTextF.font = [UIFont systemFontOfSize:14];
    searchTextF.textAlignment = NSTextAlignmentLeft;
    searchTextF.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UITextField *tf = tuple.first;
        self.keyWord = tf.text;
        [self refresh];
    }];
    
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(RACTuple *tuple) {
        UITextField *tf = tuple.first;
        // 如果需要关闭键盘
        [tf resignFirstResponder];
    }];
    
    [searchView addSubview:searchTextF];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.alertView];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    
    [self.alertView.commitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.doctorName = [x valueForKey:@"doctorName"];
        self.recipe_status = [x valueForKey:@"recipe_status"];
        self.date1 = [x valueForKey:@"date1"];
        self.date2 = [x valueForKey:@"date2"];
        [self refresh];
    }];
    [self.view bringSubviewToFront:self.nodataView];
    [self.view bringSubviewToFront:self.alertView];

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
    [dic setValue:self.doctorName forKey:@"doctorName"];
    [dic setValue:@(self.currentPage) forKey:@"pageNum"];
    [dic setValue:@"10" forKey:@"pageSize"];
    if([[self.param allKeys]containsObject:@"userId"]) {
        [dic setValue:self.param[@"userId"] forKey:@"hospitalId"];
    }else {
        [dic setValue:@"" forKey:@"hospitalId"];
    }
    [dic setValue:self.recipe_status forKey:@"recipeStatus"];
    [dic setValue:self.keyWord forKey:@"symptoms"];
    [dic setValue:self.date1 forKey:@"date1"];
    [dic setValue:self.date2 forKey:@"date2"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url: PromoteRecipeListURL dict:dic  hasHeader:YES  finished:^(id request) {
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
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomRecipeTableViewCell *cell = [CustomRecipeTableViewCell getTableView:tableView indexPathWith:indexPath];
    RecipeOrderItemModel *subModel = self.dataArray[indexPath.row];
    cell.model = subModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return  [CustomRecipeTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}



#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, WIDE, HIGHT - NAV_H - TAB_H - 65) style:UITableViewStyleGrouped];
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

- (RecipeCustomAlertView *)alertView {
    if(!_alertView) {
        _alertView = [[NSBundle mainBundle]loadNibNamed:@"RecipeCustomAlertView" owner:self options:nil].lastObject;
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
