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
#import "RefuseView.h"
#import "AgreeView.h"
@interface AssistantDetailVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong)  PromoteUserModel *model;
@property (nonatomic, strong) UIAreaPickView *areaView;
@property (nonatomic, strong) StatementPickView *pickView;
@property (nonatomic, copy) NSString *refuseStr;
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
- (IBAction)refuseClick:(id)sender {
    RefuseView *refuseView = [RefuseView createViewFromNib];
    TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:refuseView preferredStyle:TYAlertControllerStyleAlert];
    alertVC.backgoundTapDismissEnable = YES;
    /// 选择日期
    @weakify(self);
    [refuseView.subject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(x) {
            self.refuseStr = x;
            for (NSLayoutConstraint *constraint in refuseView.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    [refuseView removeConstraint:constraint];
                }
            }
            CGFloat newHeight =  [ClassMethod sizeText:x font:[UIFont systemFontOfSize:14] limitWidth:280].height< 28? 164: 136+ [ClassMethod sizeText:x font:[UIFont systemFontOfSize:14] limitWidth:280].height;
            
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:refuseView
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0
                                                                                 constant:newHeight];
            [refuseView addConstraint:heightConstraint];
            
            // 强制刷新布局
            [refuseView layoutIfNeeded];
        }
    }];
    
    [[refuseView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
    }];
    [[refuseView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
        @strongify(self);
        [self summitDataWith: @"2"];
        
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)summitDataWith:(NSString *)reviewStatus  {
    if(self.model.agentLevel.length == 0 && [reviewStatus integerValue] == 1) {
        [ZZProgress showErrorWithStatus:@"请选择医助等级"];
        return;
    }
    if((self.model.manageAreaNames.length == 0 || self.model.addressDetail.length == 0) && [reviewStatus integerValue] == 1) {
        [ZZProgress showErrorWithStatus:@"请选择所属地区"];
        return;
    }
    if([reviewStatus integerValue] == 2 &&  self.refuseStr.length == 0) {
        [ZZProgress showErrorWithStatus:@"请填写拒绝原因"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:reviewStatus forKey:@"reviewStatus"];
    [dic setValue:self.refuseStr forKey:@"reviewRemark"];
    [dic setValue:self.model.agentLevel forKey:@"agentLevel"];
    [dic setValue:self.model.manageAreaNames forKey:@"manageAreaNames"];
    [dic setValue:self.model.addressDetail forKey:@"addressDetail"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",AgentReviewURL, self.model.user_id];
    [[RequestManager shareInstance]requestWithMethod:BodyPOST url:url dict:dic hasHeader:YES finished:^(id request) {
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{});
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {
        
    }];
}

- (IBAction)agreeClick:(id)sender {
    AgreeView *agreeView =  [AgreeView createViewFromNib];
    TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:agreeView preferredStyle:TYAlertControllerStyleAlert];
    alertVC.backgoundTapDismissEnable = YES;
    @weakify(self);
    [[agreeView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
    }];
    [[agreeView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
        @strongify(self);
        [self summitDataWith: @"1"];
        
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
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
