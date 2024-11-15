//
//  TimeRangeView.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import "TimeRangeView.h"
#import <PGDatePicker.h>

@interface TimeRangeView ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet PGDatePicker *datePicker;
@property (nonatomic, copy) NSString *beginDateStr;
@property (nonatomic, copy) NSString *endDateStr;


@end

@implementation TimeRangeView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    /// 初始化
    NSDate * date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.beginDateStr = dateString;
    self.beginTextF.text = self.beginDateStr;
    self.endDateStr = @"";
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.beginTextF.delegate = self;
    self.endTextF.delegate = self;
    [self.beginTextF becomeFirstResponder];
    self.datePicker.datePickerMode = PGDatePickerModeDate;
    self.datePicker.showUnit = PGShowUnitTypeCenter;
    self.datePicker.middleTextColor = COLOR_562306;
    self.datePicker.textColorOfSelectedRow = COLOR_562306;
    self.datePicker.textFontOfSelectedRow = [UIFont boldSystemFontOfSize:17];
    self.datePicker.textFontOfOtherRow = [UIFont systemFontOfSize:16];
    self.datePicker.textColorOfOtherRow = [UIColor colorWithHexString:@"#CCBDB4"];
    self.datePicker.lineBackgroundColor = [UIColor clearColor];
    self.datePicker.maximumDate =  [NSDate date];
    self.datePicker.autoSelected = YES;
    self.datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDate * date = [calendar dateFromComponents:dateComponents];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        if([self.beginTextF isFirstResponder]) {
            self.beginTextF.text = dateString;
            self.beginDateStr = dateString;
        }
        if([self.endTextF isFirstResponder]) {
            self.endTextF.text = dateString;
            self.endDateStr = dateString;
        }
    };
    @weakify(self);
    [[self.clearBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.beginTextF.text = @"";
        self.beginDateStr =  @"";
        self.endTextF.text =  @"";
        self.endDateStr =  @"";
    }];
    
    
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.beginDateStr.length > 0 && self.endDateStr.length == 0) {
            [ZZProgress showErrorWithStatus:@"请选择结束时间"];
            return;
        }
        if(self.beginDateStr.length == 0 && self.endDateStr.length > 0) {
            [ZZProgress showErrorWithStatus:@"请选择开始时间"];
            return;
        }
        if(self.subject) {
            [self.subject sendNext:@{@"operatorStartTime":self.beginDateStr, @"operatorEndTime":self.endDateStr}];
        }
    }];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    textField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    [textField reloadInputViews];
    if(textField.tag == 0) {
        self.beginTextF.text = self.beginDateStr;
    }
    if(textField.tag == 1) {
        if(self.endDateStr.length == 0) {
            self.endDateStr = self.beginDateStr;
        }
        self.endTextF.text = self.endDateStr;
    }
    return YES;
}

- (RACSubject *)subject {
    if(!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
