//
//  UserPrivacyView.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/30.
//

#import "UserPrivacyView.h"
#import <WebKit/WebKit.h>

@interface UserPrivacyView ()
<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation UserPrivacyView

- (void)awakeFromNib {
    [super awakeFromNib];
  
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    
    
//    NSString *text = @"感谢您使用持正堂共享智慧药房！\n 我们非常重视用户的隐私和个人信息保护，为实现部分功能及服务，我们会根据您的授权获取和使用必要的信息，若您点击\"同意\"即代表您已阅读并同意《隐私政策》和《用户协议》；如果您点击\"暂不同意\"，则相关服务不可用";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    
//    UIFont *font = [UIFont systemFontOfSize:15];
//    [attributedString addAttribute:NSFontAttributeName
//                             value:font
//                             range:NSMakeRange(0, text.length)];
//    
//    // 设置普通文本颜色
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:COLOR_999999
//                             range:NSMakeRange(0, text.length)];
//    NSRange range1 = [text rangeOfString:@"《隐私政策》"];
//    
//   
//    [attributedString addAttribute:NSLinkAttributeName
//                             value:PrivacyURL
//                             range:range1];
//    
//    NSRange range2 = [text rangeOfString:@"《用户协议》"];
//    [attributedString addAttribute:NSLinkAttributeName
//                             value:UserAgreementURL
//                             range:range2];
//    
//    self.textView.editable = NO;
//    self.textView.selectable = YES;
//    self.textView.attributedText = attributedString;
//    self.textView.delegate = self;

}

//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL
//                                                   inRange:(NSRange)range
//{
//    if ([URL.absoluteString isEqualToString:PrivacyURL]) {
//        [self.subject sendNext:@"1"];
////        [[UIViewController currentViewController] pushVC:@"WebViewController" param:@{@"url":PrivacyURL, @"title": @"隐私政策"} animated:YES];
//        return NO;
//    } else if ([URL.absoluteString isEqualToString:UserAgreementURL]) {
//        [self.subject sendNext:@"2"];
////        [[UIViewController currentViewController] pushVC:@"WebViewController" param:@{@"url":UserAgreementURL, @"title": @"用户协议"} animated:YES];
//        return NO;
//    }
//    return YES;
//}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: url]]];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"toAgreement"]) {
        NSDictionary *dic  = message.body;
        [self.subject sendNext: [dic valueForKey: @"url"]];
    }
}

#pragma mark -- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

}


#pragma mark -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,
                      [NSURLCredential credentialForTrust:serverTrust]);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt:%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([scheme isEqualToString:@"weixin"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        /// 如果是跳转一个新页面
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    
}

#pragma mark -- LazyMethod
- (WKWebView *)webView {
    if(!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        /// js调用iOS
        configuration.userContentController = [[WKUserContentController alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"toAgreement"];
        ///
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 0;
        configuration.preferences = preferences;
        NSString *css = @"body, html { margin: 0; padding: 0; max-width: 100vw; overflow-x: hidden; } img, iframe { max-width: 100%; height: auto; } * { box-sizing: border-box; }";
        NSString *javascript = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; document.getElementsByTagName('head')[0].appendChild(meta); var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style);", css];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:script];
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.backView.width,140) configuration:configuration];
        _webView.backgroundColor = COLOR_FFFFFF;
        [_webView setUserInteractionEnabled:YES];
        [_webView setOpaque:NO];
        _webView.allowsBackForwardNavigationGestures = YES; /// Enable swipe back
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        }
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;

        _webView.scrollView.bounces = NO;
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;

        [self.backView addSubview:_webView];
    }
    return _webView;
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
