//
//  UIDatePickView.m
//  SSRead
//
//  Created by 张智慧 on 2021/2/6.
//

#import "UIDatePickView.h"
#import "DateTimeTool.h"

@interface UIDatePickView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, copy) NSString *pickDateStr;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation UIDatePickView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF;
        self.pickDateStr = [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
        [self addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(40, 0, 0, 0));
        }];
        
        [self addSubview:self.commitBtn];
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.top.equalTo(self);
        }];
        
        @weakify(self);
        [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.currentDateStr = self.pickDateStr;
            [self.commitSubject sendNext:self.currentDateStr];
        }];
        
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.top.equalTo(self);
        }];
        
        [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.commitSubject sendNext:nil];
        }];
    }
    return self;
}


- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.pickDateStr = [formatter stringFromDate:datePicker.date];
    
}



#pragma mark -- LazyMethod
- (UIDatePicker *)datePicker {
    if(!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_datePicker setDate:[NSDate date] animated:YES];
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
        _datePicker.backgroundColor = COLOR_FFFFFF;
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _datePicker;
}

- (UIButton *)commitBtn {
    if(!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _commitBtn;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelBtn;
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
