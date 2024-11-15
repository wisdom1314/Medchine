//
//  PayPromptView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/10.
//

#import "PayPromptView.h"

@implementation PayPromptView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0f;
    
    
}

- (IBAction)cancelClick:(id)sender {
    [self.subject sendNext: @"0"];
}
- (IBAction)commitClick:(id)sender {
    [self.subject sendNext: @"1"];
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
