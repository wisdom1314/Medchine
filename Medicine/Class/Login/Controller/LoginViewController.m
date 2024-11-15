//
//  LoginViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "LoginViewController.h"
#import "AppDelegate+Service.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;
@property (weak, nonatomic) IBOutlet UITextField *userTextF;
@property (weak, nonatomic) IBOutlet UITextField *passTextF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"登录";
    self.viewHeight.constant = HIGHT - NAV_H - Indicator_H <600? 600: HIGHT - NAV_H - Indicator_H;
    
//    self.userTextF.text = @"0271179";
//    self.passTextF.text = @"12qw12qw";
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
    // Do any additional setup after loading the view from its nib.
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
                
                /// 医助
                model.customModel = [UserInfoModel mj_objectWithKeyValues:model.user];
                [ClassMethod setModel:model.customModel key:@"customInfo"];
                [MedicineManager sharedInfo].customModel = model.customModel;
                
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
        [ZZProgress showErrorWithStatus:@"请先阅读并同意隐私协议"];
    }
    
}

- (IBAction)remmberClick:(id)sender {
    self.rememberBtn.selected = !self.rememberBtn.selected;
}

- (IBAction)privacyClick:(id)sender {
    [self pushVC:@"WebViewController" param:@{@"url":PrivacyURL, @"title": @"隐私协议"} animated:YES];
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
