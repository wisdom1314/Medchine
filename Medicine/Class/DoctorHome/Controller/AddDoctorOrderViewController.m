//
//  AddDoctorOrderViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "AddDoctorOrderViewController.h"
#import "AddDoctorOrderTableViewCell.h"
#import "HomeModel.h"

@interface AddDoctorOrderViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation AddDoctorOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"常用医嘱";
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SelectAttentionListURL dict:dic finished:^(id request) {
        [self.dataArray removeAllObjects];
        AttentionListModel *model = [AttentionListModel mj_objectWithKeyValues:request];
        [self.dataArray addObjectsFromArray:model.list];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)deleteAttetionWith:(NSString *)attentionId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:attentionId forKey:@"attention_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:DeleteAttentionURL dict:dic finished:^(id request) {
        [self requestData];
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
    AddDoctorOrderTableViewCell *cell = [AddDoctorOrderTableViewCell getTableView:tableView indexPathWith:indexPath];
    AttentionItemModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self);
    [[[cell.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"确认是否删除医嘱？"];
        alertView.buttonHeight = 40;
        alertView.buttonFont = [UIFont systemFontOfSize:14];
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4.0f;
        alertView.buttonDestructiveBgColor = MainColor;
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            [self deleteAttetionWith:model.attention_id];
        }]];
        [alertView showInController:self];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    AttentionItemModel *model = self.dataArray[indexPath.row];
    return  [AddDoctorOrderTableViewCell getCellHeightWith:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[self.param allKeys]containsObject:@"isChoose"]) {
        AttentionItemModel *model = self.dataArray[indexPath.row];
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{@"attentionItemModel":model});
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (IBAction)addCutomDoctorOrderClick:(id)sender {
    [self pushVC:@"AddDoctorOrderInfoViewController" param:nil backBlock:^(NSDictionary * _Nonnull dic) {
        [self requestData];
    } animated:YES];
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
