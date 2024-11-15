//
//  AddMyRecipeTempateView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/26.
//

#import "AddMyRecipeTempateView.h"

@interface AddMyRecipeTempateView ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *bzTextF;
@end

@implementation AddMyRecipeTempateView

- (void)awakeFromNib  {
    [super awakeFromNib];
  
    
    
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if(self.nameTextF.text.length == 0) {
            [ZZProgress showErrorWithStatus:@"请输入模板名称"];
            return;
        }
        if(self.subject) {
            [self.subject sendNext:@{
                            @"recipesample_name":self.nameTextF.text,
                            @"recipesample_symptoms":self.bzTextF.text,
                        }];
        }
        
    }];
        
    
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
