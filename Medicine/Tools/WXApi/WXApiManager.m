//Tencent is pleased to support the open source community by making WeDemo available.
//Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
//Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//http://opensource.org/licenses/MIT
//Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#import "WXApiManager.h"

static NSString* const kWXNotInstallErrorTitle = @"您还没有安装微信，不能使用微信分享功能";

@interface WXApiManager ()

@property (nonatomic, strong) NSString *authState;

@end

@implementation WXApiManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        _delegate = nil;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}


- (void)WeiXinShareWithTitle:(NSString *)title
             descriptionWith:(NSString *)description
               imageNameWith:(NSData *)imageName
                     urlWith:(NSString *)url
                     AtScene:(enum WXScene)scene
                    delegate:(id<WXAuthDelegate>)delegate
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageWithData:imageName]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    /// 默认是Session分享给朋友,Timeline是朋友圈,Favorite是收藏
    req.scene = scene;
    req.message = message;
    req.bText = NO;
    self.delegate = delegate;
    [WXApi sendReq:req completion:nil];
    
}

- (void)weiXinShareYearListWithTitle:(NSString *)title
                     descriptionWith:(NSString *)description
                             urlWith:(NSString *)url
                             AtScene:(enum WXScene)scene
                            delegate:(id<WXAuthDelegate>)delegate
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"sharelist"]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    /// 默认是Session分享给朋友,Timeline是朋友圈,Favorite是收藏
    req.scene = scene;
    req.message = message;
    req.bText = NO;
    self.delegate = delegate;
    [WXApi sendReq:req completion:nil];
}

- (void)WeiXinShareWithdetail:(UIImage *)shareImg
                      AtScene:(enum WXScene)scene
                     delegate:(id<WXAuthDelegate>)delegate
{
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *imageObject = [WXImageObject object];
    // 图片真实数据内容
    imageObject.imageData = UIImagePNGRepresentation(shareImg);
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    self.delegate = delegate;
    req.message = message;
    req.scene = scene;//会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
    [WXApi sendReq:req completion:nil];
    
}



/// 微信支付
//- (void)WeixinPayWithModel:(ZZAlipayDetailModel *)detailModel
//                  delegate:(id<WXAuthDelegate>)delegate
//{
//    PayReq *request = [[PayReq alloc]init];
//    request.partnerId = detailModel.partnerid;
//    request.prepayId = detailModel.prepayid;
//    request.package = detailModel.package;
//    request.nonceStr = detailModel.noncestr;
//    request.timeStamp = detailModel.timestamp.intValue;
//    request.sign = detailModel.sign;
//    self.delegate = delegate;
//    [WXApi sendReq:request completion:^(BOOL success) {
//        
//    }];
//}

#pragma mark - Public Methods
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    self.authState = @"";/// 用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
    self.delegate = delegate;
    [WXApi sendAuthReq:req viewController:viewController delegate:self completion:nil];
}

#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req {
    // just leave it here, WeChat will not call our app
}

-(void)onResp:(BaseResp*)resp {    
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        if (![authResp.state isEqualToString:self.authState]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)])
                [self.delegate wxAuthDenied];
            return;
        }
        
        switch (resp.errCode) {
            case WXSuccess:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthSucceed:)])
                    [self.delegate wxAuthSucceed:authResp.code];
                break;
            case WXErrCodeAuthDeny:/// 授权失败
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)])
                    [self.delegate wxAuthDenied];
                break;
            case WXErrCodeUserCancel:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthCancel)])
                    [self.delegate wxAuthCancel];
            default:
                break;
        }
    }
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case WXSuccess:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxMesSucceed)])
                    [self.delegate wxMesSucceed];
                break;
            case WXErrCodeAuthDeny:/// 授权失败
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxMesDenied)])
                    [self.delegate wxMesDenied];
                break;
            case WXErrCodeUserCancel:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxMesCancel)])
                    [self.delegate wxMesCancel];
            default:
                break;
        }
    }
    
    /// 支付
    if([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
            {
                if([self.delegate respondsToSelector:@selector(wxPaySuccessed)]) {
                    [self.delegate wxPaySuccessed];
                }
            }
                break;
                
            default:
            {
                if([self.delegate respondsToSelector:@selector(wxPayFailed)]) {
                    [self.delegate wxPayFailed];
                }
                [ZZProgress showErrorWithStatus:@"支付失败!"];
            }
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }

    }
}

@end
