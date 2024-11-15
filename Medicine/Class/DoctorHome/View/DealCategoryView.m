//
//  DealCategoryView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "DealCategoryView.h"

@interface DealCategoryView ()
<UITextFieldDelegate>

@end

@implementation DealCategoryView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numTextF.delegate = self;
    self.nameTextF.delegate = self;
    [self.nameTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    @weakify(self);
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UITextField *tf = tuple.first;
        if(tf.tag == 1) {
            self.sort = tf.text;
        }else {
            self.name = tf.text;
        }
    }];
    
    [[self.addBtn rac_signalForControlEvents: UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSInteger current = [self.sort integerValue] + 1;
        self.sort = [NSString stringWithFormat:@"%ld", current];
        self.numTextF.text = self.sort;
    }];
    
    [[self.reduceBtn rac_signalForControlEvents: UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSInteger current = [self.sort integerValue]-1;
        self.sort = [NSString stringWithFormat:@"%ld", current];
        self.numTextF.text = self.sort;
    }];
    
    [[self.commitBtn rac_signalForControlEvents: UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if(self.name.length == 0) {
            [ZZProgress showErrorWithStatus:@"请输入分类名称"];
            return;
        }
        if(self.sort.length == 0) {
            [ZZProgress showErrorWithStatus:@"请输入排序号（0-100）"];
            return;
        }
       
        if(self.subject) {
            [self.subject sendNext:@{@"sort": self.sort, @"name": self.name}];
        }
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag  == 1) {
        NSString *endStr = [NSString stringWithFormat:@"%@%@",textField.text, string];
        if([endStr integerValue]>100) {
            [ZZProgress showErrorWithStatus:@"请输入范围在0-100之间的整数"];
            return NO;
        }
    }else {
        if (textField.text.length >= 50 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

/// 限制50个字符
- (void)textFieldDidChange:(UITextField *)textField {
    if(textField.tag == 0) {
        NSInteger kMaxLength = 50;
        NSString *toBeString = textField.text;
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
        if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (toBeString.length > kMaxLength) {
                    textField.text = [toBeString substringToIndex:kMaxLength];
                }
                self.numLab.text = [NSString stringWithFormat:@"%ld/50",textField.text.length];
            }
            else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        
    }
 
}

- (void)setModel:(CategoryModel *)model {
    _model = model;
    self.sort = model.sort;
    self.name = model.name;
    self.numTextF.text = self.sort;
    self.nameTextF.text = self.name;
    self.numLab.text = [NSString stringWithFormat:@"%ld/50",self.nameTextF.text.length];
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
