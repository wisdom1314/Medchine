//
//  DoctorDetailVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/14.
//

#import "DoctorDetailVC.h"
#import "HomeModel.h"
#import "ZZBigView.h"
#import "UIAreaPickView.h"
#import "StatementPickView.h"
#import "DoctorTableViewCell.h"
#import "RefuseView.h"
#import "AgreeView.h"
@interface DoctorDetailVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong)  PromoteUserModel *model;
@property (nonatomic, strong) UIAreaPickView *areaView;
@property (nonatomic, strong) StatementPickView *pickView;
@property (nonatomic, strong) StatementPickView *pharmacyPickView;
@property (nonatomic, strong) NSMutableArray *pharmacyArr;
@property (nonatomic, copy) NSString *refuseStr;
@end

@implementation DoctorDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"医生详情";
    if([[self.param allKeys]containsObject:@"userId"]) {
        [self requestDetail];
    }
    [self requestDics];
    [self requestPharmacy];
    // Do any additional setup after loading the view from its nib.
}


- (void)requestDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:[NSString stringWithFormat:@"%@/%@",HospotalDetailURL, self.param[@"userId"]] dict:dic hasHeader:YES finished:^(id request) {
        self.model = [PromoteUserModel mj_objectWithKeyValues:request[@"data"]];
        if([self.model.status integerValue] == 10) {
            self.bottomHeight.constant = 65;
            self.bottomView.hidden = NO;
        }else {
            self.bottomHeight.constant = 0;
            self.bottomView.hidden = YES;
        }
        self.model.businessLicenseFileModel = [idCardImgModel mj_objectWithKeyValues:self.model.businessLicenseFile];
        NSLog(@"sdsdsd %@ %@", self.model.businessLicenseFile, self.model.businessLicenseFileModel.url);
        self.model.hospitalLicenseFileModel = [idCardImgModel mj_objectWithKeyValues:self.model.hospitalLicenseFile];
        self.model.doctorLicenseFileModel = [idCardImgModel mj_objectWithKeyValues:self.model.doctorLicenseFile];
        self.model.pharmacyModel = [PharmacyModel mj_objectWithKeyValues:self.model.pharmacy];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestDics {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"hospital_cert_type" forKey:@"dictType"];
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

- (void)requestPharmacy {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:PharmacyListURL dict:dic hasHeader:YES finished:^(id request) {
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [PharmacyModel class]
            };
        }];
        model.listModel = [PageListModel mj_objectWithKeyValues:model.list];
        self.pharmacyArr = model.listModel.data.mutableCopy;
        NSMutableArray *dicArray = [NSMutableArray array];
        for (PharmacyModel *subModel in model.listModel.data) {
            [dicArray addObject:@{
                @"id": subModel.pharmacy_id,
                @"value": subModel.simpleName
            }];
        }
        self.pharmacyPickView.dataArray = dicArray;
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.model.status integerValue] == 10) {
        return 3;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTableViewCell *cell = [DoctorTableViewCell getTableView:tableView indexPathWith:indexPath modelWith:self.model];
    cell.model = self.model;
    
    @weakify(self);
    [[[cell.qmBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:@[self.model.managerSignUrl] with:0];
        bigView.isWhite = YES;
        [bigView show];
    }];
    [[[cell.bazBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:@[self.model.hospitalLicenseFileModel.url] with:0];
        
        [bigView show];
    }];
    
    [[[cell.yyzzBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:@[self.model.businessLicenseFileModel.url] with:0];
        [bigView show];
    }];

    if([self.model.status integerValue] == 10) {
        [[[cell.cardTextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
             self.model.certNo = x;
            
        }];
        
        [[[cell.hosNameTextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
             self.model.hospitalname = x;
            
        }];
        [[[cell.chooseAreaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.areaView preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            @weakify(self);
            [self.areaView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
                    RegionItemModel *itemModel = x;
                    self.model.province = itemModel.province;
                    self.model.city = itemModel.city;
                    self.model.area = itemModel.area;
                    [self.tableView reloadData];
                }
                [alertVC dismissViewControllerAnimated:YES];
            }];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
        
        [[[cell.chooseCardBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.pickView preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            [self.pickView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
                    NSString *value = [x valueForKey:@"value"];
                    NSString *dictValue = [x valueForKey:@"id"];
                    self.model.certType = dictValue;
                    self.model.certTypeName = value;
                    [self.tableView reloadData];
                }
                [alertVC dismissViewControllerAnimated:YES];
            }];
            [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
        }];
        
        
        [[[cell.chooseMedBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.pharmacyPickView   preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            [self.pharmacyPickView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
//                    NSString *value = [x valueForKey:@"value"];
                    NSString *dictValue = [x valueForKey:@"id"];
                    PharmacyModel *matchedModel = [[PharmacyModel alloc]init];
                    for (PharmacyModel *subModel in self.pharmacyArr) {
                        if([subModel.pharmacy_id isEqualToString:dictValue]) {
                            matchedModel = subModel;
                            break;
                        }
                    }
                    self.model.pharmacy = [matchedModel mj_keyValues];
                    self.model.pharmacyModel = matchedModel;
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
    return [DoctorTableViewCell getCellHeightWith:indexPath modelWith:self.model];
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
- (IBAction)saveClick:(id)sender {
    AgreeView *agreeView =  [AgreeView createViewFromNib];
    agreeView.commitLab.text = @"是否确定保存并提交审核？";
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


- (void)summitDataWith:(NSString *)reviewStatus  {
    if([reviewStatus integerValue] == 2 &&  self.refuseStr.length == 0) {
        [ZZProgress showErrorWithStatus:@"请填写拒绝原因"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:reviewStatus forKey:@"reviewStatus"];
    [dic setValue:self.refuseStr forKey:@"reviewRemark"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",HospitalReviewURL, self.model.hospitalId];
    [[RequestManager shareInstance]requestWithMethod:BodyPOST url:url dict:dic hasHeader:YES finished:^(id request) {
        [self requestDetail];
    } failed:^(NSError *error) {
        
    }];
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

- (StatementPickView *)pharmacyPickView {
    if(!_pharmacyPickView) {
        _pharmacyPickView = [[StatementPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _pharmacyPickView;
}

- (NSMutableArray *)pharmacyArr {
    if(!_pharmacyArr) {
        _pharmacyArr = [NSMutableArray array];
    }
    return _pharmacyArr;
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


