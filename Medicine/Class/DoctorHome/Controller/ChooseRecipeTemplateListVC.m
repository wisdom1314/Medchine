//
//  ChooseRecipeTemplateListVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "ChooseRecipeTemplateListVC.h"
#import "RecipeTemplateTableViewCell.h"

@interface ChooseRecipeTemplateListVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ChooseRecipeTemplateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"处方模板";
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [dic setValue:@"SELF" forKey:@"pharmacy_type"];
    [dic setValue:@"" forKey:@"keyword"];
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
        [self pushVC:@"AddRecipeTemplateViewController" param:@{@"recipesampleModel": model, @"pharmacy_type": @"SELF"} backBlock:^(NSDictionary * _Nonnull dic) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TemplateModel *model = self.dataArray[indexPath.row];
    [self getTemplateDetailWith:model];
    
  
}

- (void)getTemplateDetailWith:(TemplateModel *)recipesampleModel {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:recipesampleModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:recipesampleModel.recipesample_id forKey:@"recipesample_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:GetRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        DrugListModel *model = [DrugListModel mj_objectWithKeyValues:request];
        NSMutableArray *drugList = [NSMutableArray array];
        for (DrugItemModel *subModel in model.list) {
            subModel.drugname = subModel.granule_name;
            subModel.num = [subModel.herb_dose integerValue];
            subModel.useful_value = subModel.equivalent;
            subModel.hiscode = subModel.granule_his;
            [drugList addObject:subModel];
        }
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{@"drugArr":drugList});
        }
        [self.navigationController popViewControllerAnimated:YES];
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
