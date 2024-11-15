//
//  PromoteAlertView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/13.
//

#import "PromoteAlertView.h"
#import "UIDatePickView.h"
@interface PromoteAlertView()
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (nonatomic, strong) UIDatePickView *dateView1;
@property (nonatomic, strong) UIDatePickView *dateView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (nonatomic, copy) NSString *currentStartTime;
@property (nonatomic, copy) NSString *currentEndTime;
@end

@implementation PromoteAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomHeight.constant = Indicator_H;
    self.alpha = 0;
    self.hidden = YES;
 
    self.currentStartTime = @"";
    self.currentEndTime = @"";
  
    @weakify(self);
    [[self.startTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.dateView1 preferredStyle:TYAlertControllerStyleActionSheet];
        alertVC.backgoundTapDismissEnable = YES;
        /// 选择日期
        @weakify(self);
        [self.dateView1.commitSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [alertVC dismissViewControllerAnimated:YES];
            if(x) {
                self.currentStartTime = x;
                [self reloadBtnShow];
            }
        }];
        
        [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
    }];
    
    [[self.endTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.dateView2 preferredStyle:TYAlertControllerStyleActionSheet];
        alertVC.backgoundTapDismissEnable = YES;
        /// 选择日期
        @weakify(self);
        [self.dateView2.commitSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [alertVC dismissViewControllerAnimated:YES];
            if(x) {
                self.currentEndTime = x;
                [self reloadBtnShow];
            }
        }];
        
        [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
    }];

    
}

- (void)show {
    self.hidden = NO;
    self.transform = CGAffineTransformMakeTranslation(WIDE, 0);
    [UIView animateWithDuration:0.3 animations:^{
        // 最终位置回到原位
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }];
}
- (IBAction)commitClick:(id)sender {
    [self tapClick];
    [self.commitSubject sendNext:@{
      
        @"date1": self.currentStartTime,
        @"date2": self.currentEndTime,
       
    }];
}
- (IBAction)closeClick:(id)sender {
    [self tapClick];
}

- (void)tapClick {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [UIView animateWithDuration:0.3 animations:^{
        // 将视图移动到右边屏幕外
        self.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (IBAction)cancelClick:(id)sender {
    /// 重置
    self.currentStartTime = @"";
    self.currentEndTime = @"";

    [self reloadBtnShow];
    [self tapClick];
    [self.commitSubject sendNext:@{
     
        @"date1": self.currentStartTime,
        @"date2": self.currentEndTime,
      
    }];
}






- (void)reloadBtnShow {


    if(self.currentEndTime.length>0) {
        [self.endTimeBtn setTitle:self.currentEndTime forState:UIControlStateNormal];
        [self.endTimeBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
    }else {
        [self.endTimeBtn setTitle:@"请选择结束时间" forState:UIControlStateNormal];
        [self.endTimeBtn setTitleColor:RGBA(86, 35, 6, 0.3) forState:UIControlStateNormal];
    }
    if(self.currentStartTime.length>0) {
        [self.startTimeBtn setTitle:self.currentStartTime forState:UIControlStateNormal];
        [self.startTimeBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
    }else {
        [self.startTimeBtn setTitle:@"请选择开始时间" forState:UIControlStateNormal];
        [self.startTimeBtn setTitleColor:RGBA(86, 35, 6, 0.3) forState:UIControlStateNormal];
    }
  
}

- (UIDatePickView *)dateView1 {
    if(!_dateView1) {
        _dateView1 = [[UIDatePickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _dateView1;
}

- (UIDatePickView *)dateView2 {
    if(!_dateView2) {
        _dateView2 = [[UIDatePickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _dateView2;
}



- (RACSubject *)commitSubject {
    if(!_commitSubject) {
        _commitSubject = [RACSubject subject];
    }
    return _commitSubject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
