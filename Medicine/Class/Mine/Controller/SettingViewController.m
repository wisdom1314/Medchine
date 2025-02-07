//
//  SettingViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "AppDelegate+Service.h"
#import "HomeModel.h"

@interface SettingViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *arr;

@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (nonatomic, strong) NSMutableArray *privacyRuleArr;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_FFFFFF;
    self.navTitle = @"设置";
    [self getAgreeList];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"版本号：V%@",version];
    
    UIView *footView = [ClassMethod createViewFrameWith:CGRectMake(0, 0, WIDE, 100) backColorWith:COLOR_FFFFFF];
    
    UIButton *logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, WIDE - 30, 45)];
    logOutBtn.backgroundColor = COLOR_FBF6ED;
    logOutBtn.layer.masksToBounds = YES;
    logOutBtn.layer.cornerRadius = 4.0f;
    logOutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [footView addSubview:logOutBtn];
    @weakify(self);
    [[logOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"确定退出登录吗？"];
        alertView.buttonHeight = 40;
        alertView.buttonFont = [UIFont systemFontOfSize:14];
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4.0f;
        alertView.buttonDestructiveBgColor = MainColor;
      
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
//            [ClassMethod clearUserDefaults];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"doctorInfo"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customInfo"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
            [MedicineManager sharedInfo].isLogined = NO;
            [MedicineManager sharedInfo].token = nil;
            [MedicineManager sharedInfo].doctorModel = nil;
            [MedicineManager sharedInfo].customModel = nil;
            [MedicineManager sharedInfo].userId = nil;
            [[AppDelegate shareAppDelegate]goLogin];
        }]];
        [alertView showInController:self];
    }];
    
    self.tableView.tableFooterView = footView;
    // Do any additional setup after loading the view from its nib.
}

- (void)getAgreeList {
    [[RequestManager shareInstance]requestWithMethod:GET url:AgreementListURL dict:nil hasHeader:YES finished:^(id request) {
        PrivacyRuleModel *model = [PrivacyRuleModel mj_objectWithKeyValues:request];
        self.privacyRuleArr = [model.data mutableCopy];
        if(self.privacyRuleArr.count == 2) {
            PrivacyRuleItemModel *subModel = self.privacyRuleArr[0];
            if([subModel.type isEqualToString:@"privacy"]) {
                self.arr = @[@"修改密码", @"隐私政策", @"用户协议",@"个人信息收集清单",@"系统权限管理", @"注销账户"];
            }else {
                self.arr = @[@"修改密码", @"用户协议", @"隐私政策",@"个人信息收集清单",@"系统权限管理", @"注销账户"];
            }
           
        }else if(self.privacyRuleArr.count == 1) {
            PrivacyRuleItemModel *subModel = self.privacyRuleArr[0];
            if([subModel.type isEqualToString:@"privacy"]) {
                self.arr = @[@"修改密码", @"隐私政策",@"个人信息收集清单",@"系统权限管理", @"注销账户"];
            }else if([subModel.type isEqualToString:@"user"]) {
                self.arr = @[@"修改密码",@"用户协议",@"个人信息收集清单",@"系统权限管理", @"注销账户"];
            }
        }else {
            self.arr = @[@"修改密码",@"个人信息收集清单",@"系统权限管理", @"注销账户"];
        }
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [SettingTableViewCell getTableView:tableView indexPathWith:indexPath];
    cell.textLab.text = self.arr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [SettingTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row == 0) {
        [self pushVC:@"ChangePwdViewController" animated:YES];
    }else if(indexPath.row == 1 && self.privacyRuleArr.count>0) {
        PrivacyRuleItemModel *subModel = self.privacyRuleArr[0];
        [self pushVC:@"WebViewController" param:@{@"url":[NSString stringWithFormat:@"%@?i=%@",PrivacyRuleURL, subModel.agreementId], @"title": subModel.title} animated:YES];
    }else if(indexPath.row == 2 && self.privacyRuleArr.count == 2) {
        PrivacyRuleItemModel *subModel = self.privacyRuleArr[1];
        [self pushVC:@"WebViewController" param:@{@"url":[NSString stringWithFormat:@"%@?i=%@",PrivacyRuleURL, subModel.agreementId], @"title": subModel.title} animated:YES];
    }else if(indexPath.row == self.privacyRuleArr.count+1) {
        [self pushVC:@"PersonalCollectionVC" animated:YES];
    }else if(indexPath.row == self.privacyRuleArr.count+2) {
        [self pushVC:@"AuthorityViewController" animated:YES]; /// 系统权限管理
    }else {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"是否确定注销，注销后，删除后账户将无法登陆，该账户下所有信息都将被删除。  并且注销成功没有注销成功的提示。"];
        alertView.buttonHeight = 40;
        alertView.buttonFont = [UIFont systemFontOfSize:14];
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4.0f;
        alertView.buttonDestructiveBgColor = MainColor;
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            [self cancelAccount];
        }]];
        
        
        [alertView showInController:self];
    }
}

- (IBAction)toIcpClick:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://beian.miit.gov.cn"]];
}

- (void)cancelAccount {
    [[RequestManager shareInstance]requestWithMethod:POST url:CancelAccountURL dict:nil hasHeader:YES finished:^(id request) {
        [ClassMethod clearUserDefaults];
        [MedicineManager sharedInfo].isLogined = NO;
        [MedicineManager sharedInfo].token = nil;
        [MedicineManager sharedInfo].doctorModel = nil;
        [MedicineManager sharedInfo].customModel = nil;
        [ClassMethod clearUserDefaults];
        [[AppDelegate shareAppDelegate]goLogin];
    } failed:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)privacyRuleArr {
    if(!_privacyRuleArr) {
        _privacyRuleArr = [NSMutableArray array];
    }
    return  _privacyRuleArr;
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
