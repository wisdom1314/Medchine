//
//  StatementPickView.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import "StatementPickView.h"

@interface StatementPickView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) NSArray *listArray;
@end

@implementation StatementPickView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF;
        [self addSubview:self.commitBtn];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.pickerView];
        @weakify(self);
        [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSInteger selectIndex = [self.pickerView selectedRowInComponent:0];
            [self.commitSubject sendNext: self.listArray[selectIndex]];
        }];
        [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.commitSubject sendNext:nil];
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.listArray = dataArray;
    [self.pickerView reloadAllComponents];
}

- (void)setDefaultValue:(NSString *)defaultValue {
    NSUInteger index = [self.listArray indexOfObjectPassingTest:^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        return [dict[@"id"] isEqualToString:defaultValue];
    }];
    if (index != NSNotFound) {
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    }
}

#pragma mark -PickerViewDelegate && DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.listArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.listArray[row][@"value"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDE;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark -- LazyMethod
- (UIPickerView *)pickerView {
    if(!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, WIDE, self.height - 40)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (RACSubject *)commitSubject {
    if(!_commitSubject) {
        _commitSubject = [RACSubject subject];
    }
    return _commitSubject;
}

- (NSArray *)listArray {
    if(!_listArray) {
        _listArray = [NSArray array];
    }
    return _listArray;
}

- (UIButton *)commitBtn {
    if(!_commitBtn) {
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDE - 70, 0, 60, 40)];;
        [_commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _commitBtn;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
