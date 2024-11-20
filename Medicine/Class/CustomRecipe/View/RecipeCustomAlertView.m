//
//  RecipeCustomAlertView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import "RecipeCustomAlertView.h"
#import "UIDatePickView.h"
#import "StatementPickView.h"

@interface RecipeCustomAlertView()

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *recipeStatusBtn;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameTextF;
@property (nonatomic, strong) UIDatePickView *dateView1;
@property (nonatomic, strong) UIDatePickView *dateView2;
@property (nonatomic, strong) StatementPickView *recipeStatusPickView;

@property (nonatomic, copy) NSString *currentStartTime;
@property (nonatomic, copy) NSString *currentEndTime;
@property (nonatomic, copy) NSString *currentRecipeStatus;
@property (nonatomic, copy) NSString *currentRecipeStatusId;

@property (nonatomic, copy) NSArray *recipeStatusArr;
@end

@implementation RecipeCustomAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alpha = 0;
    self.hidden = YES;
    
    NSString *placeholderText = @"请输入医生姓名";
    UIColor *placeholderColor = [UIColor colorWithRed:86/255.0 green:35/255.0 blue:6/255.0 alpha:0.3];
    self.doctorNameTextF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    self.currentStartTime = @"";
    self.currentEndTime = @"";
    self.currentRecipeStatusId = @"";
    
    self.recipeStatusArr = @[@{@"id": @"", @"value": @"全部"}, @{@"id": @"NEW", @"value": @"新处方"}, @{@"id": @"AUDIT", @"value": @"已审核"},@{@"id": @"DOWNLOAD", @"value": @"已下载"}, @{@"id": @"DELIVERY", @"value": @"已发货"},@{@"id": @"FINISH", @"value": @"已完成"},@{@"id": @"CANCEL", @"value": @"已取消"}];
    
    self.currentRecipeStatus = @"全部";
    [self.recipeStatusBtn setTitle:self.currentRecipeStatus forState:UIControlStateNormal];
    [self.recipeStatusBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
    
    
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
    
    [[self.recipeStatusBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.recipeStatusPickView.dataArray = self.recipeStatusArr;
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.recipeStatusPickView preferredStyle:TYAlertControllerStyleActionSheet];
        alertVC.backgoundTapDismissEnable = YES;
        /// 选择缴费状态
        @weakify(self);
        [self.recipeStatusPickView.commitSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if(x) {
                self.currentRecipeStatus = [x valueForKey:@"value"];
                self.currentRecipeStatusId = [x valueForKey:@"id"];
                [self reloadBtnShow];
            }
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
    }];
    
}
- (IBAction)closeClick:(id)sender {
    [self tapClick];
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
        @"doctorName": self.doctorNameTextF.text,
        @"date1": self.currentStartTime,
        @"date2": self.currentEndTime,
        @"recipe_status": self.currentRecipeStatusId
    }];
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
    self.currentRecipeStatusId = @"";
    self.currentRecipeStatus = @"全部";
    self.doctorNameTextF.text = @"";
    [self reloadBtnShow];
    [self tapClick];
    [self.commitSubject sendNext:@{
        @"doctorName": self.doctorNameTextF.text,
        @"date1": self.currentStartTime,
        @"date2": self.currentEndTime,
        @"recipe_status": self.currentRecipeStatusId
    }];
}






- (void)reloadBtnShow {

    if(self.currentRecipeStatus.length>0) {
        [self.recipeStatusBtn setTitle:self.currentRecipeStatus forState:UIControlStateNormal];
        [self.recipeStatusBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
    }

    
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


- (StatementPickView *)recipeStatusPickView {
    if(!_recipeStatusPickView) {
        _recipeStatusPickView = [[StatementPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _recipeStatusPickView;
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
