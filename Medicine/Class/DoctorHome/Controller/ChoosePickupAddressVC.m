//
//  ChoosePickupAddressVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/16.
//

#import "ChoosePickupAddressVC.h"
#import "PickupAddressCell.h"
#import "HomeModel.h"

@interface ChoosePickupAddressVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (nonatomic, copy) NSString *simpleName;
@end

@implementation ChoosePickupAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"选择自提点";
    self.currentPage = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.mj_header beginRefreshing];
    
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(RACTuple *tuple) {
        // 如果需要关闭键盘
        [self.textF resignFirstResponder];
    }];
    
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
        UITextField *tf = tuple.first;
        self.simpleName = tf.text;
        [self refresh];
    }];
    

    // Do any additional setup after loading the view from its nib.
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@1 forKey:@"selfPick"];
    [dic setValue:@(self.currentPage) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pagesize"];
    [dic setValue:self.simpleName forKey:@"simpleName"];
    [[RequestManager shareInstance]requestWithMethod:GET url:SelfPickListURL dict:dic  hasHeader:YES  finished:^(id request) {
        if(self.currentPage == 1) {
            [self.dataArray removeAllObjects];
        }
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [SelfPickModel class]
            };
        }];
        model.listModel = [PageListModel mj_objectWithKeyValues:model.list];
 
        [self.dataArray addObjectsFromArray:model.listModel.data];
        self.emptyView.hidden = (self.dataArray.count != 0)?YES:NO;
        [self.tableView reloadData];
        
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
    PickupAddressCell *cell = [PickupAddressCell getTableView:tableView indexPathWith:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return  [PickupAddressCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (SelfPickModel *subModel in self.dataArray) {
        subModel.isSelect = NO;
    }
    SelfPickModel *model = self.dataArray[indexPath.row];
    model.isSelect = YES;
    [self.tableView reloadData];
    
    if(self.backBlockWithParam) {
        self.backBlockWithParam(@{@"selfPickModel": model});
    }
    [self.navigationController popViewControllerAnimated:YES];
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
