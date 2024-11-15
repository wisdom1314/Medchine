//
//  RechargeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import "RechargeViewController.h"
#import "MineModel.h"


@interface RechargeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UITextField *priceTextF;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (nonatomic, copy) NSString *price;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, copy) NSString *rechargeType;
@property (nonatomic, copy) NSString *remark;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewHeight.constant = HIGHT - NAV_H - Indicator_H <650? 650: HIGHT - NAV_H - Indicator_H;
    self.navTitle = @"充值";
    
    [[self.priceTextF rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        self.price = x;
    }];
    
    [[self.textView rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        if(![x isEqualToString:@"请输入交易说明"]) {
            self.remark = x;
        }
    }];
    
    [[self rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if([textView.text isEqualToString:@"请输入交易说明"]) {
            textView.text = @"";
            textView.textColor = COLOR_333333;
        }
    }];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)choosePrice:(UIButton *)sender {
    [self initBtn];
    sender.selected = YES;
    sender.backgroundColor =  COLOR_F3D4D0;
    self.priceTextF.text =  self.price = [NSString stringWithFormat:@"%ld", sender.tag];
    [self.priceTextF becomeFirstResponder];
}

- (void)initBtn {
    self.btn1.selected = self.btn2.selected = self.btn3.selected = self.btn4.selected = self.btn5.selected = self.btn6.selected = NO;
    self.btn1.backgroundColor = self.btn2.backgroundColor = self.btn3.backgroundColor= self.btn4.backgroundColor = self.btn5.backgroundColor = self.btn6.backgroundColor = COLOR_FAF7F2;
}
- (IBAction)choosePayWay:(UIButton *)sender {
    self.wxBtn.selected = self.alipayBtn.selected = NO;
    sender.selected = YES;
    if(self.wxBtn.isSelected) {
        self.rechargeType = @"WEPAY_H5";
    }else {
        self.rechargeType = @"ALIPAY_APP";
    }
    
}
- (IBAction)commitRechagre:(id)sender {
    
//    NSString *entryStr = [ClassMethod decryptUseDES:@"7bf8bbe862ec923ae24b75545620ff59" key:DESKey];
//    
//    NSLog(@"sdsdsd %@", entryStr);
//    
//    return;
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(self.price.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入充值金额"];
        return;
    }
    if(self.rechargeType.length == 0) {
        [ZZProgress showErrorWithStatus:@"请选择支付方式"];
        return;
    }
    
    if([self.rechargeType isEqualToString:@"WEPAY_H5"]) {
        NSString *key = DESKey;
        NSString *needStr = [NSString stringWithFormat:@"rechargeType=WEPAY_H5&amount=%@&doctorId=%@&hospitalId=%@&remark=%@",self.price, [MedicineManager sharedInfo].doctorModel.doctor_id, [MedicineManager sharedInfo].doctorModel.hospital_id, self.remark];
        NSString *entryStr = [ClassMethod desEncryptToString:needStr key:key];
        NSString *payUrl = [NSString stringWithFormat: @"%@/wepayh5/#/pages/main/pay?rechargeType=WEPAY_H5&amount=%@&doctorId=%@&hospitalId=%@&remark=%@&encryptStr=%@&modalShow=false",BaseURL,self.price, [MedicineManager sharedInfo].doctorModel.doctor_id, [MedicineManager sharedInfo].doctorModel.hospital_id, self.remark, entryStr];
        [self pushVC:@"WebViewController" param:@{@"url":payUrl, @"title": @"支付", @"amount": self.price, @"type": @"wxpay"} animated:YES];
    }else {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.price forKey:@"amount"];
        [dic setValue:self.rechargeType forKey:@"rechargeType"];
        [dic setValue:self.remark forKey:@"remark"];
        [[RequestManager shareInstance]requestWithMethod:BodyPOST url:CreateOrderURL dict:dic hasHeader:YES finished:^(id request) {
            if([[request allKeys]containsObject:@"data"]) {
                PayModel *model = [PayModel mj_objectWithKeyValues:request[@"data"]];
                [[AlipaySDK defaultService] payOrder:model.form fromScheme:@"alipayMedicine" callback:^(NSDictionary *resultDic) {
                    if([[resultDic allKeys]containsObject:@"resultStatus"]) {
                        if ([resultDic[@"resultStatus"]integerValue]==9000) {
                            [ZZProgress showErrorWithStatus:@"支付成功!"];
                            [self pushVC:@"RechargeResultVC" param:@{@"status": @"success", @"amount": self.price, @"paymemtSn": model.form, @"type": @"alipay"} animated:YES];
                        }else {
                            if([resultDic[@"resultStatus"] integerValue] == 6001) {
                                [ZZProgress showErrorWithStatus:@"用户取消支付"];
                            }else {
                                [ZZProgress showErrorWithStatus:@"支付失败"];
                            }
                            [self pushVC:@"RechargeResultVC" param:@{@"status": @"fail", @"amount": self.price, @"paymemtSn": model.form, @"type": @"alipay"} animated:YES];
                        }
                    }
                }];
            }
        } failed:^(NSError *error) {
            
        }];
        
        
    }
    
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
