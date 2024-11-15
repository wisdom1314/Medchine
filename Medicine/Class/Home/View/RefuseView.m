//
//  RefuseView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import "RefuseView.h"

@interface RefuseView ()
@property (nonatomic, copy) NSString *reason;
@end

@implementation RefuseView

- (void)awakeFromNib  {
    [super awakeFromNib];
    
    [[self rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if([textView.text isEqualToString:@"请输入拒绝原因"]) {
            textView.text = @"";
            textView.textColor = COLOR_562306;
        }
    }];

    
    [[self.textView rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        self.reason = x;
        self.textViewHeight.constant = [ClassMethod sizeText:x font:[UIFont systemFontOfSize:14] limitWidth:280].height < 28? 38: [ClassMethod sizeText:x font:[UIFont systemFontOfSize:14] limitWidth:280].height + 10;
        
      
        
        [self.subject sendNext:self.reason];
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
