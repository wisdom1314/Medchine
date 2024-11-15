//
//  TradingTypeView.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import "TradingTypeView.h"

@interface TradingTypeView ()
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *rebackBtn;

@end

@implementation TradingTypeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

- (IBAction)statusClick:(UIButton *)sender {
    if(sender.tag == 0) {
        self.rechargeBtn.selected = YES;
        self.rechargeBtn.backgroundColor = COLOR_F3D4D0;
        self.payBtn.selected = NO;
        self.payBtn.backgroundColor = COLOR_FAF7F2;
        self.rebackBtn.selected = NO;
        self.rebackBtn.backgroundColor = COLOR_FAF7F2;
    }else if(sender.tag == 1) {
        self.rechargeBtn.selected = NO;
        self.rechargeBtn.backgroundColor = COLOR_FAF7F2;
        self.payBtn.selected = YES;
        self.payBtn.backgroundColor = COLOR_F3D4D0;
        self.rebackBtn.selected = NO;
        self.rebackBtn.backgroundColor = COLOR_FAF7F2;
    }else {
        self.rechargeBtn.selected = NO;
        self.rechargeBtn.backgroundColor = COLOR_FAF7F2;
        self.payBtn.selected = NO;
        self.payBtn.backgroundColor = COLOR_FAF7F2;
        self.rebackBtn.selected = YES;
        self.rebackBtn.backgroundColor = COLOR_F3D4D0;
    }
    
    [self.subject sendNext:@(sender.tag)];
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
