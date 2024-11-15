//
//  PayQrcodeView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/5.
//

#import "PayQrcodeView.h"

@implementation PayQrcodeView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0f;
    
    
}
- (IBAction)cancelClick:(id)sender {
    [self.subject sendNext: @"0"];
}
- (IBAction)commitClick:(id)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"确认是否已经缴费成功？"];
    alertView.buttonHeight = 40;
    alertView.buttonFont = [UIFont systemFontOfSize:14];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 4.0f;
    alertView.buttonDestructiveBgColor = MainColor;
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self.subject sendNext: @"1"];
    }]];
    [alertView showInWindow];
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
