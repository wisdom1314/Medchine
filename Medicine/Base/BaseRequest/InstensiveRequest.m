//
//  InstensiveRequest.m
//  Yavon
//
//  Created by GOOT on 2018/7/9.
//  Copyright © 2018年 He. All rights reserved.
//

/// 待优化

#import "InstensiveRequest.h"
#import <AFHTTPSessionManager.h>
#import "AppDelegate+Service.h"

@implementation InstensiveRequest

- (NSString *)urlWithPath:(NSString *)url{
    return [NSString stringWithFormat:@"%@%@",BaseURL,url];
}

- (void)beginRequest {
    if(self.requestType == Img) {
        [self beginMultipartRequst];
    }else {
        switch (self.requestMethod) {
            case GET:
            {
                [self getRequest];
            }
                break;
            case POST:
            {
                [self postRequest];
            }
                break;
            case PATCH:
            {
                [self patchRequest];
            }
                break;
            case DELETE:
            {
                [self deleteRequest];
            }
                break;
            case BodyPOST:
            {
                [self bodyRequest];
            }
                break;
                
            case AdvGET:
            {
                [self advGETRequest];
            }
                break;
                
            case RedDotPOST:
            {
                [self redDotRequest];
            }
                
            default:
                break;
        }
    }
}

#pragma mark -- 上传图片相关
- (void)beginMultipartRequst {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/jpeg",@"image/png", nil];
    if([MedicineManager sharedInfo].token.length!=0) {
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].token forHTTPHeaderField:@"token"];
    }
    [manager.requestSerializer setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forHTTPHeaderField:@"hospitalId"];
    [manager.requestSerializer setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forHTTPHeaderField:@"doctorId"];
   
    [manager POST:[self urlWithPath:self.url] parameters:self.paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.upData name:self.key fileName:self.fileName mimeType:self.mimeType];
        [formData appendPartWithFormData:[@"12345678909876543212345678909876" dataUsingEncoding:NSUTF8StringEncoding] name:@"sign"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZZProgress dismiss];
        if([responseObject[@"code"] integerValue] == 0) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }else {
            [ZZProgress showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (task.error.code == NSURLErrorCancelled) {
            // 取消了请求
        } else {
            // 其他错误
            [ZZProgress showErrorWithStatus:@"网络连接失败"];
            if (self.failed) {
                self.failed(error);
            }
        }
        
    }];
}

#pragma mark -- Ordinary
/// GET请求
- (void)getRequest {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if([MedicineManager sharedInfo].token.length!=0) {
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].token forHTTPHeaderField:@"token"];
    }
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSString *vers=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; /// 获取版本号
    [manager.requestSerializer setValue:vers forHTTPHeaderField:@"version"];
    NSString *phoneModel = [[UIDevice currentDevice]model];
    [manager.requestSerializer setValue:phoneModel forHTTPHeaderField:@"mcode"];
    
    if(self.hasHeader) {
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forHTTPHeaderField:@"hospitalId"];
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forHTTPHeaderField:@"doctorId"];
    }
   
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    [paramsDic setValue:@"12345678909876543212345678909876" forKey:@"sign"];
    [manager GET:[self urlWithPath:self.url] parameters:paramsDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isAutoMask) {
            [ZZProgress dismiss];
        }
        if([responseObject[@"state"] isEqualToString:@"succ"] || [self.url containsString:@"app/login/user_info"]) {
            if(self.finished) {
                self.finished(responseObject);
            }
        }else {
//            if([responseObject[@"message"] containsString:@"登录"] && ![responseObject[@"message"] containsString:@"解绑"] ) {
//                /// 去登录页面
//                [[AppDelegate shareAppDelegate]goLogin];
//            }
            [ZZProgress showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZZProgress showErrorWithStatus:@"网络连接失败"];
        if (self.failed) {
            self.failed(error);
        }
    }];
}

/// POST请求
- (void)postRequest {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
   
    if([MedicineManager sharedInfo].token.length!=0) {
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].token forHTTPHeaderField:@"token"];
    }
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSString *vers=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; /// 获取版本号
    [manager.requestSerializer setValue:vers forHTTPHeaderField:@"version"];
    NSString *phoneModel = [[UIDevice currentDevice]model];
    [manager.requestSerializer setValue:phoneModel forHTTPHeaderField:@"mcode"];
    if(self.hasHeader) {
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forHTTPHeaderField:@"hospitalId"];
        [manager.requestSerializer setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forHTTPHeaderField:@"doctorId"];
    }
   
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
        
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    [paramsDic setValue:@"12345678909876543212345678909876" forKey:@"sign"];
    [manager POST:[self urlWithPath:self.url] parameters:paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isAutoMask) {
            [ZZProgress dismiss];
        }
        if([responseObject[@"state"] isEqualToString:@"A4101"]) {
            if(self.finished) {
                self.finished(responseObject);
            }
        }else if([responseObject[@"state"] isEqualToString:@"succ"] || [self.url containsString:@"get_help"]) {
            if(self.finished) {
                self.finished(responseObject);
            }
        }else {
            if([responseObject[@"msg"] isKindOfClass:[NSString class]]) {
                [ZZProgress showErrorWithStatus:responseObject[@"msg"]];
            }else {
                [ZZProgress showErrorWithStatus:@"未知错误"];
            }
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [ZZProgress showErrorWithStatus:@"网络连接失败"];
        
        if (self.failed) {
            self.failed(error);
        }
    }];
    
}


- (void)advGETRequest {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    if([MedicineManager sharedInfo].token.length!=0) {
//        [manager.requestSerializer setValue:[MedicineManager sharedInfo].token forHTTPHeaderField:@"token"];
//        NSLog(@"******token %@",[MedicineManager sharedInfo].token);
//    }
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];
    NSString *vers=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; /// 获取版本号
    [manager.requestSerializer setValue:vers forHTTPHeaderField:@"version"];
    NSString *phoneModel = [[UIDevice currentDevice]model];
    [manager.requestSerializer setValue:phoneModel forHTTPHeaderField:@"mcode"];

    [manager GET:[self urlWithPath:self.url] parameters:self.paramDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if([responseObject[@"code"] integerValue] == 0) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.failed) {
            self.failed(error);
        }
    }];
}


#pragma mark ----
/// PATCH请求
- (void)patchRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    [mananger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    [mananger PATCH:[self urlWithPath:self.url] parameters:self.paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isAutoMask) {
            [ZZProgress dismiss];
        }
        if([responseObject[@"code"] integerValue] == 0) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }else {
            [ZZProgress showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failed) {
            self.failed(error);
        }
        [ZZProgress showErrorWithStatus:@"网络连接失败"];
    }];
}

/// DELETE请求
- (void)deleteRequest {
    AFHTTPSessionManager *mananger=[AFHTTPSessionManager manager];
    mananger.responseSerializer = [AFJSONResponseSerializer serializer];
    [mananger.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mananger.requestSerializer.timeoutInterval = 20.f;
    [mananger.requestSerializer didChangeValueForKey:@"timeoutInterval"];
   
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    [mananger DELETE:[self urlWithPath:self.url] parameters:self.paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.isAutoMask) {
            [ZZProgress dismiss];
        }
        if([responseObject[@"code"] integerValue] == 200) {
            if(self.finished) {
                self.finished(responseObject[@"data"]);
            }
        }else {
            if([responseObject[@"message"] containsString:@"登录"] && ![responseObject[@"message"] containsString:@"解绑"] ) {
                /// 去登录页面
                [[AppDelegate shareAppDelegate]goLogin];
            }
            
            [ZZProgress showErrorWithStatus:responseObject[@"message"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failed) {
            self.failed(error);
        }
        [ZZProgress showErrorWithStatus:@"网络连接失败"];
        
    }];
}


///  主要的数据请求
- (void)bodyRequest {
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    [paramsDic setValue:@"12345678909876543212345678909876" forKey:@"sign"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[self urlWithPath:self.url] parameters:nil error:nil];
    request.timeoutInterval = 20;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    /// 新增
    if([MedicineManager sharedInfo].token.length!=0) {
        [request setValue:[MedicineManager sharedInfo].token forHTTPHeaderField:@"token"];
    }
    
    if(self.hasHeader) {
        [request setValue:[MedicineManager sharedInfo].doctorModel.hospital_id forHTTPHeaderField:@"hospitalId"];
        [request setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forHTTPHeaderField:@"doctorId"];
    }
    
    if (self.isAutoMask) {
        [ZZProgress showWithStatus:@"加载中..."];
    }

    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            if([responseObject isKindOfClass:[NSDictionary class]]) {
            
                if([responseObject[@"state"] isEqualToString:@"succ"]) {
                    if (self.isAutoMask) {
                        [ZZProgress dismiss];
                    }
                    if(self.finished) {
                        self.finished(responseObject);
                    }
                }else {
                    [ZZProgress showErrorWithStatus:responseObject[@"msg"]];
                }
            }
        }
        
    }];
    [task resume];
}


- (void)redDotRequest {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.paramDic options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[self urlWithPath:self.url] parameters:nil error:nil];
    request.timeoutInterval = 20;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    /// 新增
    if([ClassMethod getStringBy:@"token"].length!=0) {
        [request setValue:[ClassMethod getStringBy:@"token"] forHTTPHeaderField:@"token"];
    }
    [request setValue:@"ios" forHTTPHeaderField:@"client"];
    NSString *vers=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; /// 获取版本号
    [request setValue:vers forHTTPHeaderField:@"version"];
    NSString *phoneModel = [[UIDevice currentDevice]model];
    [request setValue:phoneModel forHTTPHeaderField:@"mcode"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            if([responseObject isKindOfClass:[NSDictionary class]]) {
                if([responseObject[@"code"] integerValue] == 0) {
                    if(self.finished) {
                        self.finished(responseObject[@"data"]);
                    }
                }else {
                    NSLog(@"!!!!! %@",responseObject[@"message"]);
                }
            }
        }
        
    }];
    [task resume];
}

@end
