//
//  RecipeTemplateViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "RecipeTemplateViewController.h"
#import "RecipeButtonView.h"
#import "RecipeTemplateTableViewCell.h"
#import "HomeModel.h"

@interface RecipeTemplateViewController ()
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *tabBackView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RecipeButtonView *recipeButtonView;
@property (nonatomic, assign) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (nonatomic, copy) NSString *pharmacy_type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (nonatomic, copy) NSString *keyWord;
@end

@implementation RecipeTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"处方模板";
    self.pharmacy_type = @"SHARE";
//    药房类型 SHARE-共享药房 SELF-我的药房
    // Do any additional setup after loading the view from its nib.
}

- (void)initialize {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, WIDE - 15, 45)];
    [self.view addSubview:headerView];
  
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = COLOR_FFFFFF;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 4;
    [headerView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(0); // 左边距离父视图为 0
        make.top.equalTo(headerView.mas_top).offset(5); // 顶部距离父视图为 0
        make.bottom.equalTo(headerView.mas_bottom).offset(-5); // 底部距离父视图为 0
        make.right.equalTo(headerView.mas_right).offset(-15);
    }];
    
    UIImageView *searchImg = [ClassMethod createImgViewFrameWith:CGRectMake(10, 10, 15, 15) imageNamed:@"icon_search"];
    [searchView addSubview:searchImg];
    
    UITextField *searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, WIDE - 120,  35)];
    searchTextF.returnKeyType = UIReturnKeySearch;
    searchTextF.placeholder = @"请输入症状关键字";
    searchTextF.borderStyle = UITextBorderStyleNone;
    searchTextF.font = [UIFont systemFontOfSize:14];
    searchTextF.textAlignment = NSTextAlignmentLeft;
    searchTextF.delegate = self;
    @weakify(self);
    [[searchTextF rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.keyWord = x;
    }];

    [searchView addSubview:searchTextF];
    

    self.recipeButtonView = [[NSBundle mainBundle]loadNibNamed:@"RecipeButtonView" owner:self options:nil].lastObject;
    self.recipeButtonView.frame = CGRectMake(0, 55, WIDE, 50);
    [self.view addSubview:self.recipeButtonView];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//    [self.tableView.mj_header beginRefreshing];
    
    [[self.recipeButtonView.myBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.recipeButtonView setBtnSelected:1];
        [self loadBtnStatus];
    }];
    [[self.recipeButtonView.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.recipeButtonView setBtnSelected:0];
        [self loadBtnStatus];
    }];
    
    [self loadBtnStatus];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self refresh];
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
    [dic setValue:self.pharmacy_type forKey:@"pharmacy_type"];
    [dic setValue:self.keyWord forKey:@"keyword"];
    [[RequestManager shareInstance]requestWithMethod:POST url:RecipesamplelistURL dict:dic  hasHeader:YES  finished:^(id request) {
        if(self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [TemplateModel class]
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

- (void)deleteRecipesampleWith:(TemplateModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue: model.doctor_id forKey:@"doctor_id"];
    [dic setValue: model.recipesample_id forKey:@"recipesample_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:DeleteRecipesampleURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
    } failed:^(NSError *error) {
        
    }];
    
}



- (void)loadBtnStatus {
    if(self.recipeButtonView.shareBtn.selected) {
        self.recipeButtonView.shareBtn.backgroundColor = COLOR_FFFFFF;
        self.recipeButtonView.myBtn.backgroundColor = COLOR_F3ECE0;
        self.pharmacy_type = @"SHARE";
        self.categoryBtn.hidden = NO;
        self.categoryBtnHeight.constant = 45;
        self.categoryTop.constant = 10;
        self.bottomHeight.constant = 120;
    }else {
        self.recipeButtonView.shareBtn.backgroundColor = COLOR_F3ECE0;
        self.recipeButtonView.myBtn.backgroundColor = COLOR_FFFFFF;
        self.pharmacy_type = @"SELF";
        self.categoryBtn.hidden = YES;
        self.categoryBtnHeight.constant = 0;
        self.categoryTop.constant = 0;
        self.bottomHeight.constant = 65;
    }
    [self refresh];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.recipeButtonView.frame = CGRectMake(0, 55, WIDE, 50);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTemplateTableViewCell *cell = [RecipeTemplateTableViewCell getTableView:tableView indexPathWith:indexPath];
    TemplateModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self);
    [[[cell.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"确认是否删除该处方模板？"];
        alertView.buttonHeight = 40;
        alertView.buttonFont = [UIFont systemFontOfSize:14];
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4.0f;
        alertView.buttonDestructiveBgColor = MainColor;
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            [self deleteRecipesampleWith: model];
        }]];
        [alertView showInController:self];
    }];
    
    [[[cell.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self pushVC:@"AddRecipeTemplateViewController" param:@{@"recipesampleModel": model, @"pharmacy_type": self.pharmacy_type} backBlock:^(NSDictionary * _Nonnull dic) {
            [self refresh];
        } animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return  [RecipeTemplateTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    TemplateModel *model = self.dataArray[indexPath.row];
    [self pushVC:@"AddRecipeTemplateViewController" param:@{@"recipesampleModel": model, @"pharmacy_type": self.pharmacy_type, @"isDetail": @"1"} animated:YES];
}

- (IBAction)addClick:(id)sender {
    
    [self pushVC:@"AddRecipeTemplateViewController" param:@{@"pharmacy_type": self.pharmacy_type} backBlock:^(NSDictionary * _Nonnull dic) {
        [self refresh];
    } animated:YES];
}

- (IBAction)manageClick:(id)sender {
    
    [self pushVC:@"CategoryManagerViewController" animated:YES];
}


#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, WIDE, HIGHT - NAV_H - Indicator_H - 110 - 120) style:UITableViewStyleGrouped];
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
