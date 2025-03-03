//
//  LoginViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "LoginViewController.h"
#import "AppDelegate+Service.h"
#import "UserPrivacyView.h"
#import "HomeModel.h"
#import "Reachability.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;
@property (weak, nonatomic) IBOutlet UITextField *userTextF;
@property (weak, nonatomic) IBOutlet UITextField *passTextF;
@property (weak, nonatomic) IBOutlet UIButton *privacyBtn;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyWidth;
@property (nonatomic, strong) PrivacyRuleItemModel *privayModel;

@property (nonatomic, strong) PrivacyRuleItemModel *ruleModel;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear: animated];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        
    } else {
        [self checkAgreement];
    }
    
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reachability = [notification object];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    // 判断网络是否恢复
    if (netStatus != NotReachable) {
        // 如果网络恢复，用户同意了网络连接
        [self handleNetworkConnection:YES];
    } else {
        // 网络不可用
        [self handleNetworkConnection:NO];
    }
}

- (void)handleNetworkConnection:(BOOL)isConnected {
    if (isConnected) {
        [self checkAgreement];
    }
}

- (void)checkAgreement {
    if([ClassMethod getStringBy:@"isFrist"].length>0) {
    }else {
        UserPrivacyView *privacyView = [UserPrivacyView createViewFromNib];
        privacyView.url =  WebURL;
        @weakify(self);
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:privacyView preferredStyle:TYAlertControllerStyleAlert];
        alertVC.backgoundTapDismissEnable = NO;
        [self presentViewController:alertVC animated:YES completion:nil];
        [[privacyView.cacelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [alertVC dismissViewControllerAnimated:YES];
            self.agreenBtn.selected = NO;
            exit(0);
        }];
        [[privacyView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if([privacyView.agreeBtn isSelected]) {
                [ClassMethod setString:@"1" key:@"isFrist"];
                [alertVC dismissViewControllerAnimated:YES];
                self.agreenBtn.selected = YES;
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
    
    [self getAgreeList];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"登录";
    self.viewHeight.constant = HIGHT - NAV_H - Indicator_H <600? 600: HIGHT - NAV_H - Indicator_H;
    
    
//    self.userTextF.text = @"0271179";
//    self.passTextF.text = @"Zhyf2022v2";
    if([ClassMethod getStringBy:@"username"].length>0) {
        self.userTextF.text = [ClassMethod getStringBy:@"username"];
    }
   
    if([ClassMethod getStringBy:@"password"].length>0) {
        self.passTextF.text = [ClassMethod getStringBy:@"password"];
       
        self.rememberBtn.selected = YES;
    }
    
    @weakify(self);
    [[self.agreenBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.agreenBtn.selected = !self.agreenBtn.selected;
    }];
    
 
    self.privacyBtn.hidden = self.ruleBtn.hidden = YES;
    self.addLab.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)getAgreeList {
    [[RequestManager shareInstance]requestWithMethod:GET url:AgreementListURL dict:nil hasHeader:YES finished:^(id request) {
        PrivacyRuleModel *model = [PrivacyRuleModel mj_objectWithKeyValues:request];
        for (PrivacyRuleItemModel *subModel in model.data) {
            if([subModel.type isEqualToString:@"privacy"]) {
                self.privacyBtn.hidden = NO;
                self.privayModel = subModel;
            }else if([subModel.type isEqualToString:@"user"]) {
                self.ruleBtn.hidden = NO;
                self.ruleModel = subModel;
            }
        }
        
        if(!self.privacyBtn.isHidden && !self.ruleBtn.isHidden) {
            self.addLab.hidden = NO;
        }else if(self.privacyBtn.isHidden) {
            self.privacyWidth.constant = 0;
        }

    } failed:^(NSError *error) {
        
    }];
}

- (IBAction)loginClick:(id)sender {
    if(self.agreenBtn.isSelected) {
        if(self.userTextF.text.length == 0) {
            [ZZProgress showErrorWithStatus:@"请输入账号"];
        }else if(self.passTextF.text.length == 0) {
            [ZZProgress showErrorWithStatus:@"请输入密码"];
        }else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:self.userTextF.text forKey:@"username"];
            [dic setValue:self.passTextF.text forKey:@"password"];
            [[RequestManager shareInstance]requestWithMethod:POST url:LoginURL dict:dic finished:^(id request) {
                LoginInfoModel *model = [LoginInfoModel mj_objectWithKeyValues:request];
               
                if([model.isDefaultPwd integerValue] == 1) {
                    [ClassMethod setString:@"1" key:@"needUpdatePwd"];
                }
                
                /// 保存token
                [ClassMethod setString:model.token key:@"token"];
                [MedicineManager sharedInfo].token = model.token;
                [MedicineManager sharedInfo].isLogined = YES;
                
                /// 医生端
                model.infoModel = [BaseUserInfoModel mj_objectWithKeyValues:model.doctor];
                model.hospitalModel = [HospitalModel mj_objectWithKeyValues:model.hospital];
                [ClassMethod setModel:model.hospitalModel key:@"hospitalInfo"];
                [MedicineManager sharedInfo].hospitalModel = model.hospitalModel;
                [ClassMethod setModel:model.infoModel key:@"doctorInfo"];
                [MedicineManager sharedInfo].doctorModel = model.infoModel;
                /// 医助 & 医生端
                model.customModel = [UserInfoModel mj_objectWithKeyValues:model.user];
                [ClassMethod setModel:model.customModel key:@"customInfo"];
                [MedicineManager sharedInfo].customModel = model.customModel;
                
                [ClassMethod setString:model.customModel.userId key:@"userId"];
                [MedicineManager sharedInfo].userId = model.customModel.userId;
                
                if(self.rememberBtn.isSelected) {
                    [ClassMethod setString:self.userTextF.text key:@"username"];
                    [ClassMethod setString:self.passTextF.text key:@"password"];
                }
                
                if(model.customModel && [model.customModel.userType integerValue] != 10 && [model.customModel.userType integerValue] != 30) {
                    [MedicineManager sharedInfo].isCustom = YES;
                    [[AppDelegate shareAppDelegate]goCustomMain];
                }else {
                    [MedicineManager sharedInfo].isCustom = NO;
                    [[AppDelegate shareAppDelegate]goMain];
                }
        
                
            } failed:^(NSError *error) {
                
            }];
        }
    }else {
        [ZZProgress showErrorWithStatus:@"请阅读并同意隐私政策和用户协议"];
    }
    
}

- (IBAction)remmberClick:(id)sender {
    self.rememberBtn.selected = !self.rememberBtn.selected;
}

- (IBAction)privacyClick:(id)sender {
    [self pushVC:@"WebViewController" param:@{@"url":[NSString stringWithFormat:@"%@?i=%@",PrivacyRuleURL, self.privayModel.agreementId], @"title": self.privayModel.title} animated:YES];
}
- (IBAction)agreenClick:(id)sender {
    [self pushVC:@"WebViewController" param:@{@"url":[NSString stringWithFormat:@"%@?i=%@",PrivacyRuleURL, self.ruleModel.agreementId], @"title": self.ruleModel.title} animated:YES];
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
