//Tencent is pleased to support the open source community by making WeDemo available.
//Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
//Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//http://opensource.org/licenses/MIT
//Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WXApi.h>
#import <WXApiObject.h>

@protocol WXAuthDelegate <NSObject>

@optional
- (void)wxAuthSucceed:(NSString*)code;
- (void)wxAuthDenied;
- (void)wxAuthCancel;

- (void)wxMesSucceed;
- (void)wxMesDenied;
- (void)wxMesCancel;

- (void)wxPaySuccessed;
- (void)wxPayFailed;

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<WXAuthDelegate, NSObject> delegate;

/**
 *  严格单例，唯一获得实例的方法.
 *
 *  @return 实例对象.
 */
+ (instancetype)sharedManager;

/**
 *  发送微信验证请求.
 *
 *  @restrict 该方法支持未安装微信的用户.
 *
 *  @param viewController 发起验证的VC
 *  @param delegate       处理验证结果的代理
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate;




/// 微信分享
- (void)WeiXinShareWithTitle:(NSString *)title
             descriptionWith:(NSString *)description
               imageNameWith:(NSData *)imageName
                     urlWith:(NSString *)url
                     AtScene:(enum WXScene)scene
                    delegate:(id<WXAuthDelegate>)delegate;



/// 微信分享邀请码
- (void)WeiXinShareWithdetail:(UIImage *)shareImg
                      AtScene:(enum WXScene)scene
                     delegate:(id<WXAuthDelegate>)delegate;


///// 微信支付
//- (void)WeixinPayWithModel:(ZZAlipayDetailModel *)detailModel
//                  delegate:(id<WXAuthDelegate>)delegate;

@end
