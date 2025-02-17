//
//  DoctorHomeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/18.
//

#import "DoctorHomeViewController.h"
#import <SDCycleScrollView.h>
#import "DoctorWelcomeCell.h"
#import "DoctorGridCell.h"
#import "HomeModel.h"
#import "PwdPromptView.h"
#import "DoctorHomeFooterView.h"
#import "UserPrivacyView.h"
@interface DoctorHomeViewController ()
<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) RegionItemModel *regionModel;
@property (nonatomic, strong) DoctorHomeFooterView *footerView;
@property (nonatomic, strong) PrivacyRuleModel *agreeModel;
@end

@implementation DoctorHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleImage];
    [self initialize];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestBannerList];
    [self requestAddressInfo];
    
}

- (void)checkAgreement {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [dic setValue:[MedicineManager sharedInfo].userId forKey:@"u"];
    [[RequestManager shareInstance]requestWithMethod:GET url:CheckLastAgreementURL dict:dic hasHeader:YES finished:^(id request) {
        BOOL showPrivacy = NO;
        PrivacyRuleModel *model = [PrivacyRuleModel mj_objectWithKeyValues:request];
        self.agreeModel = model;
        for (PrivacyRuleItemModel *subModel in model.data) {
            if(subModel.acceptTime.length == 0) {
                showPrivacy = YES;
            }
        }
        if(showPrivacy) {
            UserPrivacyView *privacyView = [UserPrivacyView createViewFromNib];
            privacyView.url = [NSString stringWithFormat:@"%@?t=%@&u=%@",UpdatePrivacyURL, [MedicineManager sharedInfo].token, [MedicineManager sharedInfo].userId];
            @weakify(self);
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:privacyView preferredStyle:TYAlertControllerStyleAlert];
            alertVC.backgoundTapDismissEnable = NO;
            [self presentViewController:alertVC animated:YES completion:nil];
            [[privacyView.cacelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                
                [alertVC dismissViewControllerAnimated:YES];
//                exit(0);  
              
            }];
            [[privacyView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if([privacyView.agreeBtn isSelected]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    NSMutableArray *arr = [NSMutableArray array];
                    for (PrivacyRuleItemModel *subModel in self.agreeModel.data) {
                        if(subModel.acceptTime.length == 0) {
                            [arr addObject:subModel.agreementId];
                        }
                    }
                    [dic setValue:arr forKey:@"agreementIds"];
                    [dic setValue:[MedicineManager sharedInfo].userId forKey:@"userId"];
                    [[RequestManager shareInstance]requestWithMethod:BodyPOST url:AgreeURL dict:dic hasHeader:YES finished:^(id request) {
                        [alertVC dismissViewControllerAnimated:YES];
                    } failed:^(NSError *error) {
                        
                    }];
                }else {
                    [ZZProgress showErrorWithStatus:@"请先阅读并同意"];
                }
            }];
           
            [privacyView.subject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                NSString *url = (NSString *)x;
                [self pushVC:@"WebViewController" param:@{@"url":url, @"title": @""} animated:YES];
                [alertVC dismissViewControllerAnimated:YES];
            }];
        }
       
        
    } failed:^(NSError *error) {
        
    }];
}


- (void)initialize {
    if([ClassMethod getStringBy:@"needUpdatePwd"]) {
        PwdPromptView *promptView = [PwdPromptView createViewFromNib];
        TYAlertController *alertVC =  [TYAlertController alertControllerWithAlertView:promptView preferredStyle:TYAlertControllerStyleAlert];
        alertVC.backgoundTapDismissEnable = NO;
        [[promptView.cacelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"needUpdatePwd"];
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[promptView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"needUpdatePwd"];
            [self pushVC:@"ChangePwdViewController" animated:YES];
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    [self.view addSubview:self.tableView];
}

- (void)requestBannerList {
    [[RequestManager shareInstance]requestWithMethod:POST url:LoopImagesURL dict:nil finished:^(id request) {
        NSMutableArray *imgArr = [NSMutableArray array];
        BannerModel *model = [BannerModel mj_objectWithKeyValues:request];
        for (BannerPicModel *subModel in model.images) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@", BaseURL, subModel.picurl]];
        }
        self.scrollView.imageURLStringsGroup = imgArr;
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestAddressInfo {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [[RequestManager shareInstance]requestWithMethod:GET url:UserInfoURL dict:dic finished:^(id request) {
        RegionItemModel *regionModel = [RegionItemModel mj_objectWithKeyValues:request];
        self.regionModel = regionModel;
        [ClassMethod setString:regionModel.userId key:@"userId"];
        [MedicineManager sharedInfo].userId = regionModel.userId;
        if([self.regionModel.isComplete integerValue] == 1) {
            self.tableView.tableFooterView = [[UIView alloc]init];
        }else {
            self.footerView.model = self.regionModel;
            self.footerView.frame = CGRectMake(0, 0, WIDE, 100);
            self.tableView.tableFooterView = self.footerView;
        }
        [self checkAgreement];
    } failed:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        DoctorWelcomeCell *cell = [DoctorWelcomeCell getTableView:tableView indexPathWith:indexPath];
        return cell;
    }else {
        DoctorGridCell *cell = [DoctorGridCell getTableView:tableView indexPathWith:indexPath];
        @WeakSelf(self);
        cell.typeBlock = ^(GRIDTYPE type) {
            switch (type) {
                case GRIDTYPE_SharePharmacy:
                    [weakSelf pushVC:@"CreateRecipeViewController" animated:YES];
                    break;
                case GRIDTYPE_MyPharmacy:
                    [weakSelf pushVC:@"MyCreateRecipeViewController" animated:YES];
                    break;
                case GRIDTYPE_RecipeModel:
                    [weakSelf pushVC:@"RecipeTemplateViewController" animated:YES];
                    break;
                case GRIDTYPE_DoctorAdvice:
                    [weakSelf pushVC:@"AddDoctorOrderViewController" animated:YES];
                    break;
                default:
                    break;
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return (indexPath.section == 0 )?70: 215;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    
}

#pragma mark -- LazyMethod
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT - NAV_H) style:UITableViewStyleGrouped];
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
        UIView *headerView = [ClassMethod createViewFrameWith:CGRectMake(0, 0, WIDE, 200*WIDES) backColorWith:COLOR_F8F5EF];
        [headerView addSubview:self.scrollView];
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (SDCycleScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 10, WIDE-30, 200*WIDES - 20) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        _scrollView.layer.masksToBounds = YES;
        _scrollView.layer.cornerRadius = 10.0f;
        _scrollView.backgroundColor = COLOR_F8F5EF;
        _scrollView.currentPageDotColor = MainColor;
        _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.autoScrollTimeInterval = 5;
    }
    return _scrollView;
}

- (DoctorHomeFooterView *)footerView {
    if(!_footerView) {
        _footerView = [[NSBundle mainBundle]loadNibNamed:@"DoctorHomeFooterView" owner:self options:nil].lastObject;
    }
    return _footerView;
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
