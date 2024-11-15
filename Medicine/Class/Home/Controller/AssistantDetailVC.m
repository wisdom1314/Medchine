//
//  AssistantDetailVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/13.
//

#import "AssistantDetailVC.h"
#import "AssistantTableViewCell.h"
#import "HomeModel.h"
#import "ZZBigView.h"
#import "UIAreaPickView.h"
#import "StatementPickView.h"
@interface AssistantDetailVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong)  PromoteUserModel *model;
@property (nonatomic, strong) UIAreaPickView *areaView;
@property (nonatomic, strong) StatementPickView *pickView;
@end

@implementation AssistantDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"医助详情";
    
    if([[self.param allKeys]containsObject:@"userId"] && [[self.param allKeys]containsObject:@"nickName"]) {
        [self requestDetail];
    }
    [self requestDics];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:[NSString stringWithFormat:@"%@/%@",PromoteAgentDetail, self.param[@"userId"]] dict:dic hasHeader:YES finished:^(id request) {
        self.model = [PromoteUserModel mj_objectWithKeyValues:request[@"data"]];
        if([self.model.status integerValue] == 10) {
            self.bottomHeight.constant = 65;
            self.bottomView.hidden = NO;
        }else {
            self.bottomHeight.constant = 0;
            self.bottomView.hidden = YES;
        }
        self.model.idcardImageModel1 = [idCardImgModel mj_objectWithKeyValues:self.model.idcardImage1];
        self.model.idcardImageModel2 = [idCardImgModel mj_objectWithKeyValues:self.model.idcardImage2];
        self.model.nickName = self.param[@"nickName"];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestDics {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"agent_level" forKey:@"dictType"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:GetDicsURL dict:dic hasHeader:YES finished:^(id request) {
        DictModel *model = [DictModel mj_objectWithKeyValues:request];
        NSMutableArray *dicArray = [NSMutableArray array];
        for (DictItemModel *subModel in model.data) {
            [dicArray addObject:@{
                @"id": subModel.dictValue,
                @"value": subModel.dictLabel
            }];
        }
        self.pickView.dataArray = dicArray;
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssistantTableViewCell *cell = [AssistantTableViewCell getTableView:tableView indexPathWith:indexPath];
    cell.model = self.model;
    
    @weakify(self);
    [[[cell.idcardImgBtn1 rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:@[self.model.idcardImageModel1.url] with:0];
        [bigView show];
    }];
    [[[cell.idcardImgBtn2 rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:@[self.model.idcardImageModel2.url] with:0];
        [bigView show];
    }];
  
    
    if([self.model.status integerValue] == 10) {
        [[[cell.chosseAreaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.areaView preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            @weakify(self);
            [self.areaView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
                    RegionItemModel *itemModel = x;
                    self.model.manageAreaNames = [NSString stringWithFormat:@"%@,%@,%@",itemModel.province,itemModel.city,itemModel.area];
                    [self.tableView reloadData];
                }
                [alertVC dismissViewControllerAnimated:YES];
            }];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
        
        [[[cell.chooseLevelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.pickView preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            [self.pickView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
                    NSString *value = [x valueForKey:@"value"];
                    NSString *dictValue = [x valueForKey:@"id"];
                    self.model.agentLevel = dictValue;
                    self.model.agentLevelName = value;
                    [self.tableView reloadData];
                }
                [alertVC dismissViewControllerAnimated:YES];
            }];
            [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
        }];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AssistantTableViewCell getCellHeightWith:indexPath modelWith:self.model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}


- (UIAreaPickView *)areaView {
    if(!_areaView) {
        _areaView = [[UIAreaPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _areaView;
}


- (StatementPickView *)pickView {
    if(!_pickView) {
        _pickView = [[StatementPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _pickView;
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
