//
//  WebViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
//#import "WebViewJavascriptBridge.h"
@interface WebViewController ()
<WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
//@property WebViewJavascriptBridge* bridge;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = [self.param valueForKey:@"title"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.param valueForKey:@"url"]]]];
    if([[self.param valueForKey:@"title"] isEqualToString:@"支付"]) {
        //    registerHandler 场景：让 JavaScript 调用 iOS 原生代码中的方法。
        //    callHandler 场景：让 iOS 原生代码调用 JavaScript 中的方法。
//        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
//        [self.bridge registerHandler:@"toAccountCenter" handler:^(id data, WVJBResponseCallback responseCallback) {
//            NSLog(@"ObjC Echo called with: %@", data);
//            responseCallback(data);
//        }];
    }

    // Do any additional setup after loading the view from its nib.
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"toAccountCenter"]) {
//        [self pushVC:@"RechargeResultVC" param:@{@"status": @"success", @"amount": [self.param valueForKey:@"amount"] , @"type": @"wxpay"} animated:YES];
        [self pushVC:@"AccountViewController" param:@{@"source": @"pay"} animated:YES];
    }
}

#pragma mark -- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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
//    self.progressView.hidden = NO;
//    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    [self.view bringSubviewToFront:self.progressView];
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



//- (void)dealloc {
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//}


- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -- LazyMethod
- (WKWebView *)webView {
    if(!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        /// js调用iOS
        configuration.userContentController = [[WKUserContentController alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"toAccountCenter"];
        ///
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 0;
        configuration.preferences = preferences;
        NSString *css = @"body, html { margin: 0; padding: 0; max-width: 100vw; overflow-x: hidden; } img, iframe { max-width: 100%; height: auto; } * { box-sizing: border-box; }";
        NSString *javascript = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; document.getElementsByTagName('head')[0].appendChild(meta); var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style);", css];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:script];
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT - NAV_H - Indicator_H) configuration:configuration];
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

        // Disable horizontal scrolling
        _webView.scrollView.bounces = NO;
        _webView.scrollView.alwaysBounceHorizontal = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;

        [self.view addSubview:_webView];
    }
    return _webView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
