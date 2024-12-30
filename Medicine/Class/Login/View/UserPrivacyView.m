//
//  UserPrivacyView.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/30.
//

#import "UserPrivacyView.h"

@interface UserPrivacyView ()
<UITextViewDelegate>

@end

@implementation UserPrivacyView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    NSString *text = @"感谢您使用持正堂共享智慧药房！\n 我们非常重视用户的隐私和个人信息保护，为实现部分功能及服务，我们会根据您的授权获取和使用必要的信息，若您点击\"同意\"即代表您已阅读并同意《隐私政策》和《用户协议》；如果您点击\"暂不同意\"，则相关服务不可用";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:NSMakeRange(0, text.length)];
    
    // 设置普通文本颜色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_999999
                             range:NSMakeRange(0, text.length)];
    NSRange range1 = [text rangeOfString:@"《隐私政策》"];
    
   
    [attributedString addAttribute:NSLinkAttributeName
                             value:PrivacyURL
                             range:range1];
    
    NSRange range2 = [text rangeOfString:@"《用户协议》"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:UserAgreementURL
                             range:range2];
    
    self.textView.editable = NO;
    self.textView.selectable = YES;
    self.textView.attributedText = attributedString;
    self.textView.delegate = self;

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL
                                                   inRange:(NSRange)range
{
    if ([URL.absoluteString isEqualToString:PrivacyURL]) {
        [self.subject sendNext:@"1"];
//        [[UIViewController currentViewController] pushVC:@"WebViewController" param:@{@"url":PrivacyURL, @"title": @"隐私政策"} animated:YES];
        return NO;
    } else if ([URL.absoluteString isEqualToString:UserAgreementURL]) {
        [self.subject sendNext:@"2"];
//        [[UIViewController currentViewController] pushVC:@"WebViewController" param:@{@"url":UserAgreementURL, @"title": @"用户协议"} animated:YES];
        return NO;
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
