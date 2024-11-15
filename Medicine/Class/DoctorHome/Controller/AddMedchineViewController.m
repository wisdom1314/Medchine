//
//  AddMedchineViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "AddMedchineViewController.h"
#import "AddMedichineCell.h"
#import "HomeModel.h"

@interface AddMedchineViewController ()
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) BOOL isEx;
@end

@implementation AddMedchineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"添加药品";
    self.emptyView.hidden = NO;
    
    if([[self.param allKeys]containsObject:@"type"]) {
        self.isEx = YES;
    }
    
    [[self.textF rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        if(x.length>0) {
            NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
            if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
                UITextRange *selectedRange = [self.textF markedTextRange];
                //获取高亮部分
                UITextPosition *position = [self.textF positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    self.keyWord = x;
                   [self requestDrug];
                }
                else{//有高亮选择的字符串，则暂不对文字进行统计和限制
                }
            }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
                self.keyWord = x;
               [self requestDrug];
            }

        }
    }];
    // Do any additional setup after loading the view from its nib.
}


- (void)requestDrug {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forKey:@"hospital_id"];
    [dic setValue:self.keyWord forKey:@"q"];
    [[RequestManager shareInstance]requestWithMethod:POST url: self.isEx?SelectDrugPkgURL: GetDrugListURL dict:dic hasHeader:YES finished:^(id request) {
        DrugListModel *model = [DrugListModel mj_objectWithKeyValues:request];
        for (DrugItemModel *subModel in model.list) {
            subModel.isEx = self.isEx;
        }
        self.dataArray = model.list.mutableCopy;
        [self.tableView reloadData];
        self.emptyView.hidden = self.dataArray.count>0;
    } failed:^(NSError *error) {
        
    }];
}


#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AddMedichineCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddMedichineCell *cell = [AddMedichineCell getTableView:tableView indexPathWith:indexPath];
    DrugItemModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{@"model": model});
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];

    return cell;
   
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray=  [NSMutableArray array];
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
