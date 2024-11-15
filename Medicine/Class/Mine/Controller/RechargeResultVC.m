//
//  RechargeResultVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/20.
//

#import "RechargeResultVC.h"

@interface RechargeResultVC ()
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *stausLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *reBtn;


@end

@implementation RechargeResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"充值结果";
    
    if([[self.param valueForKey:@"status"] isEqualToString:@"success"]) {
        self.topImgView.image = [UIImage imageNamed:@"success"];
        self.stausLab.text = @"充值成功";
        self.detailLab.text = [NSString stringWithFormat:@"您已成功充值%@元", self.param[@"amount"]];
        [self.reBtn setTitle:@"查看余额" forState:UIControlStateNormal];
    }else {
        self.topImgView.image = [UIImage imageNamed:@"error"];
        self.stausLab.text = @"充值失败";
        self.detailLab.text = @"对不起，您本次充值失败";
        [self.reBtn setTitle:@"点击重试" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)leftClick:(id)sender {
    
    self.tabBarController.selectedIndex = 0;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

- (IBAction)rightClick:(id)sender {
    NSLog(@"sdsds %@",self.param);
    if(![[self.param valueForKey:@"status"] isEqualToString:@"success"]) {
        [self.navigationController popViewControllerAnimated: YES];
//        if([[self.param valueForKey:@"type"] isEqualToString:@"alipay"]) {
//            [[AlipaySDK defaultService] payOrder:self.param[@"paymentSn"] fromScheme:@"alipayMedicine" callback:^(NSDictionary *resultDic) {
//                if([[resultDic allKeys]containsObject:@"resultStatus"]) {
//                    if ([resultDic[@"resultStatus"]integerValue]==9000) {
//                        [ZZProgress showErrorWithStatus:@"支付成功!"];
//                        [self pushVC:@"AccountViewController" param:@{@"source": @"pay"} animated:YES];
//                    }else {
//                        if([resultDic[@"resultStatus"] integerValue] == 6001) {
//                            [ZZProgress showErrorWithStatus:@"用户取消支付"];
//                        }else {
//                            [ZZProgress showErrorWithStatus:@"支付失败"];
//                        }
//                    }
//                }
//            }];
//        }else { /// 微信支付
//            
//        }
    }else {
        [self pushVC:@"AccountViewController" param:@{@"source": @"pay"} animated:YES];
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
