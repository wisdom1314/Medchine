//
//  CategoryManagerViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "CategoryManagerViewController.h"
#import "RecipeTemplateTableViewCell.h"
#import "DealCategoryView.h"
#import "HomeModel.h"

@interface CategoryManagerViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CategoryManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"分类管理";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"" forKey:@"name"];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [[RequestManager shareInstance]requestWithMethod:GET url:RecipeCategoryListURL dict:dic  hasHeader:YES  finished:^(id request) {
        if(self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [CategoryModel class]
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

- (void)deleteCategoryWith:(CategoryModel *)model {
    NSString *url = [NSString stringWithFormat:@"%@/%@",DeleteCategoryURL, model.category_id];
    [[RequestManager shareInstance]requestWithMethod:POST url:url dict:nil hasHeader:YES finished:^(id request) {
        [self refresh];
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTemplateTableViewCell *cell = [RecipeTemplateTableViewCell getTableView:tableView indexPathWith:indexPath];
    CategoryModel *model = self.dataArray[indexPath.row];
    cell.categoryModel = model;
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
            [self deleteCategoryWith:model];
        }]];
        [alertView showInController:self];
    }];
    
    [[[cell.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        DealCategoryView *categoryView = [DealCategoryView createViewFromNib];
        categoryView.model = model;
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:categoryView preferredStyle:TYAlertControllerStyleAlert];
        alertVC.backgoundTapDismissEnable = YES;
        [self presentViewController:alertVC animated:YES completion:nil];
        @weakify(self);
        [[categoryView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[categoryView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [categoryView.subject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSString *sort = [x valueForKey:@"sort"];
            NSString *name = [x valueForKey:@"name"];
            CategoryModel *subModel = [[CategoryModel alloc]init];
            subModel.sort = sort;
            subModel.name = name;
            subModel.category_id = model.category_id;
            [self updateCategoryWith:subModel];
            [alertVC dismissViewControllerAnimated:YES];
        }];
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

- (IBAction)addClick:(id)sender {
    DealCategoryView *categoryView = [DealCategoryView createViewFromNib];;
    TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:categoryView preferredStyle:TYAlertControllerStyleAlert];
    alertVC.backgoundTapDismissEnable = YES;
    [self presentViewController:alertVC animated:YES completion:nil];
    @weakify(self);
    [[categoryView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
    }];
    [[categoryView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
    }];
    [categoryView.subject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
       
        NSString *sort = [x valueForKey:@"sort"];
        NSString *name = [x valueForKey:@"name"];
        [self addCategoryWith:name sortWith:sort];
        [alertVC dismissViewControllerAnimated:YES];
    }];
    
}


- (void)addCategoryWith:(NSString *)name sortWith:(NSString *)sort {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:name forKey:@"name"];
    [dic setValue:sort forKey:@"sort"];
    [[RequestManager shareInstance]requestWithMethod:BodyPOST url:AddCategoryURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
    } failed:^(NSError *error) {
        
    }];
}

- (void)updateCategoryWith:(CategoryModel *)model {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:model.name forKey:@"name"];
    [dic setValue:model.sort forKey:@"sort"];
    [dic setValue:model.category_id forKey:@"id"];
    [[RequestManager shareInstance]requestWithMethod:BodyPOST url:EditCategroyURL dict:dic hasHeader:YES finished:^(id request) {
        [self refresh];
    } failed:^(NSError *error) {
        
    }];
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
