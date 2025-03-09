//
//  RecipeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/10.
//

#import "RecipeViewController.h"
#import "RecipeOrderAlertView.h"
#import "RecipeButtonView.h"
#import "RecipeOrderTableViewCell.h"
#import "HomeModel.h"
#import "StatementModel.h"
#import "PayQrcodeView.h"
#import "PayPromptView.h"

@interface RecipeViewController ()
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RecipeOrderAlertView *alertView;
@property (nonatomic, strong) RecipeButtonView *recipeButtonView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, copy) NSArray *paymentArray;
@property (nonatomic, copy) NSString *currentDoctorId;
@property (nonatomic, copy) NSString *payment_status;
@property (nonatomic, copy) NSString *recipe_status;
@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *date2;

@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"处方订单";
    self.paymentArray = @[@{@"id": @"", @"value": @"全部"}, @{@"id": @"WAIT", @"value": @"未缴费"}, @{@"id": @"PAYED", @"value": @"已缴费"},@{@"id": @"CANCEL", @"value": @"已取消"}, @{@"id": @"REFUND", @"value": @"已退单"}];
    self.currentDoctorId = [MedicineManager sharedInfo].doctorModel.doctor_id;
    [self initialize];
    [self requestDoctors];
    // Do any additional setup after loading the view from its nib.
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

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.currentDoctorId forKey:@"doctor_id"];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forKey:@"hospital_id"];
    [dic setValue:self.payment_status forKey:@"payment_status"];
    [dic setValue:self.recipe_status forKey:@"recipe_status"];
    [dic setValue:self.keyWord forKey:@"symptoms"];
    [dic setValue:self.date1 forKey:@"date1"];
    [dic setValue:self.date2 forKey:@"date2"];
    [[RequestManager shareInstance]requestWithMethod:POST url: self.currentTag ==0? RecipeListURL : RecipeHosListURL dict:dic  hasHeader:YES  finished:^(id request) {
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
    

    self.recipeButtonView = [[NSBundle mainBundle]loadNibNamed:@"RecipeButtonView" owner:self options:nil].lastObject;
    self.recipeButtonView.frame = CGRectMake(0, 55, WIDE, 50);
    [self.view addSubview:self.recipeButtonView];
    
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
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.alertView];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    
    [self.alertView.commitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.currentDoctorId = [x valueForKey:@"doctor_id"];
        self.payment_status = [x valueForKey:@"payment_status"];
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


- (void)loadBtnStatus {
    
    if(self.recipeButtonView.shareBtn.selected) {
        self.recipeButtonView.shareBtn.backgroundColor = COLOR_FFFFFF;
        self.recipeButtonView.myBtn.backgroundColor = COLOR_F3ECE0;
        
        self.currentTag = 0;
       
    }else {
        self.recipeButtonView.shareBtn.backgroundColor = COLOR_F3ECE0;
        self.recipeButtonView.myBtn.backgroundColor = COLOR_FFFFFF;
        self.currentTag = 1;
       
    }
    [self refresh];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.recipeButtonView.frame = CGRectMake(0, 55, WIDE, 50);
}

- (void)payMoneyWith:(RecipeOrderItemModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:model.recipe_id forKey:@"recipe_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:PayMoneyURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)deleteRecipeOrder:(RecipeOrderItemModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:model.recipe_id forKey:@"recipe_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:DelRecipeURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
    } failed:^(NSError *error) {
        
    }];
    
}


- (void)cancelRecipeOrder:(RecipeOrderItemModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:model.recipe_id forKey:@"recipe_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:CancelRecipeURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)payQrcodeWith:(RecipeOrderItemModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:model.recipe_id forKey:@"recipe_id"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:POST url:RecipePayQrcodeURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
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
    RecipeOrderTableViewCell *cell = [RecipeOrderTableViewCell getTableView:tableView indexPathWith:indexPath];
    RecipeOrderItemModel *subModel = self.dataArray[indexPath.row];
    subModel.tag = self.currentTag;
    cell.model = subModel;
    @weakify(self);
    [[[cell.topBtn    rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if([subModel.payment_status isEqualToString:@"WAIT"]) {
            PayQrcodeView *qrcodeView = [PayQrcodeView createViewFromNib];
            qrcodeView.priceLab.text = [NSString stringWithFormat:@"金额：%.2f", [subModel.recipe_sale_price doubleValue]];
            [qrcodeView.qrcodeImagView sd_setImageWithURL:[NSURL URLWithString:subModel.payQrimage] placeholderImage:nil];
            TYAlertController *alertVC =  [TYAlertController alertControllerWithAlertView:qrcodeView preferredStyle:TYAlertControllerStyleAlert];
            alertVC.backgoundTapDismissEnable = YES;
            /// 选择日期
            @weakify(self);
            [qrcodeView.subject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                [alertVC dismissViewControllerAnimated:YES];
                if(x) {
                    if([x integerValue] == 1) {
                        [self payQrcodeWith: subModel];
                    }
                }
            }];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
    [[[cell.centerBtn    rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if([subModel.payment_status isEqualToString:@"WAIT"]) {
            PayPromptView *promptView = [PayPromptView createViewFromNib];
            TYAlertController *alertVC =  [TYAlertController alertControllerWithAlertView:promptView preferredStyle:TYAlertControllerStyleAlert];
            alertVC.backgoundTapDismissEnable = YES;
            /// 选择日期
            @weakify(self);
            [promptView.subject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                [alertVC dismissViewControllerAnimated:YES];
                if(x) {
                    if([x integerValue] == 1) {
                        [self payMoneyWith:subModel];
                    }
                }
            }];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
    [[[cell.bottomBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(subModel.tag == 0) {
            if([subModel.payment_status isEqualToString:@"WAIT"] || [subModel.payment_status isEqualToString:@"CANCEL"]) {
                
                TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"确认是否删除该处方订单？"];
                alertView.buttonHeight = 40;
                alertView.buttonFont = [UIFont systemFontOfSize:14];
                alertView.layer.masksToBounds = YES;
                alertView.layer.cornerRadius = 4.0f;
                alertView.buttonDestructiveBgColor = MainColor;
                [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                }]];
                [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    [self deleteRecipeOrder:subModel];
                }]];
                [alertView showInController:self];
                
            }
        }else {
            
            if([subModel.payment_status isEqualToString:@"PAYED"] ){
                TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"确认是否取消该处方？"];
                alertView.buttonHeight = 40;
                alertView.buttonFont = [UIFont systemFontOfSize:14];
                alertView.layer.masksToBounds = YES;
                alertView.layer.cornerRadius = 4.0f;
                alertView.buttonDestructiveBgColor = MainColor;
                [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                }]];
                [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    [self cancelRecipeOrder:subModel];
                }]];
                [alertView showInController:self];
            }
        }
        
        
        
    }];
    
    [[[cell.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self pushVC:@"RecipeDetailStatusVC" param:@{@"recipe_name": subModel.recipe_name, @"type": @(self.currentTag)} animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    RecipeOrderItemModel *subModel = self.dataArray[indexPath.row];
    return  [RecipeOrderTableViewCell getCellHeightWith:indexPath modelWith:subModel];
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


#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, WIDE, HIGHT - NAV_H - TAB_H - 120) style:UITableViewStyleGrouped];
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

- (RecipeOrderAlertView *)alertView {
    if(!_alertView) {
        _alertView = [[NSBundle mainBundle]loadNibNamed:@"RecipeOrderAlertView" owner:self options:nil].lastObject;
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
