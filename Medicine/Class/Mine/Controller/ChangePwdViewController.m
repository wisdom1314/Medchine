//
//  ChangePwdViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import "ChangePwdViewController.h"
#import "AppDelegate+Service.h"
@interface ChangePwdViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UITextField *orginalTextF;
@property (weak, nonatomic) IBOutlet UITextField *pasTextF;
@property (weak, nonatomic) IBOutlet UITextField *commitPasTextF;


@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"修改密码";
    self.viewHeight.constant = HIGHT - NAV_H - Indicator_H;
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commitClick:(id)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"确认是否修改？"];
    alertView.buttonHeight = 40;
    alertView.buttonFont = [UIFont systemFontOfSize:14];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 4.0f;
    alertView.buttonDestructiveBgColor = MainColor;
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        
        [self requestData];
    }]];
    [alertView showInController:self];
}

- (void)requestData {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if(self.orginalTextF.text.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if(self.pasTextF.text.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if(self.commitPasTextF.text.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    
    NSString *passwordRegex = @"^(?=.*[0-9])(?=.*[a-zA-Z]).{8,30}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    if (![passwordTest evaluateWithObject:self.pasTextF.text]) {
        [ZZProgress showErrorWithStatus:@"请输入8-30位新密码，至少包含大小写字母和数字，不能连续3位或以上字符（如123\abc）"];
        return;
    }
    NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:self.orginalTextF.text forKey:@"password"];
    [dic setValue:self.pasTextF.text forKey:@"new_password"];
    [dic setValue:self.commitPasTextF.text forKey:@"confirm_password"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:POST url:UpdatePasswordURL dict:dic finished:^(id request) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"doctorInfo"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
       
        [MedicineManager sharedInfo].isLogined = NO;
        [MedicineManager sharedInfo].token = nil;
        [MedicineManager sharedInfo].doctorModel = nil;
        [[AppDelegate shareAppDelegate]goLogin];

    } failed:^(NSError *error) {
        
    }];
    
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
