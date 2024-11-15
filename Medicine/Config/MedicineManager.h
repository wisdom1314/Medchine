//
//  MedicineManager.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicineManager : NSObject


/// 获取当前单例
+ (instancetype)sharedInfo;

@property (nonatomic, copy) NSString *token;

/// 是否已经登录 YES：登录，NO：未登录
@property (nonatomic, assign) BOOL isLogined;

@property (nonatomic, strong) BaseUserInfoModel *doctorModel; /// 医生端
@property (nonatomic, strong) HospitalModel *hospitalModel;
@property (nonatomic, strong) UserInfoModel *customModel; /// 其他角色
@property (nonatomic, assign) BOOL isCustom;

@end

NS_ASSUME_NONNULL_END
