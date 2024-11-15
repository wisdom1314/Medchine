//
//  AddDoctorOrderInfoViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "AddDoctorOrderInfoViewController.h"

@interface AddDoctorOrderInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (nonatomic, copy) NSString *careful;

@end

@implementation AddDoctorOrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"添加医嘱";
    self.viewHeight.constant = HIGHT - NAV_H - Indicator_H;

    [[self rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if([textView.text isEqualToString:@"请输入"]) {
            textView.text = @"";
            textView.textColor = COLOR_333333;
        }
    }];
    
    [[self.textView rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        self.careful = x;
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)addAttention {
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:self.careful forKey:@"careful"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SaveAttentionURL dict:dic finished:^(id request) {
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{@"staus": @"success"});
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {
        
    }];
}

- (IBAction)commitClick:(id)sender {
    if(self.careful.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入医嘱内容"];
    }else {
        [self addAttention];
    }
}
- (IBAction)cancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
