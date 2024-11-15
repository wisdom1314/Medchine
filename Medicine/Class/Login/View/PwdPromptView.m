//
//  PwdPromptView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/1.
//

#import "PwdPromptView.h"

@implementation PwdPromptView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
