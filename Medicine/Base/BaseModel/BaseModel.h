//
//  BaseModel.h
//  SimiBao
//
//  Created by 张智慧 on 2020/8/5.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@end

@interface BaseUserInfoModel : BaseModel<NSCoding>
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *doctorname;
@property (nonatomic, copy) NSString *hospital_id;
@property (nonatomic, copy) NSString *adduser;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *department_id;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *unioncode;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *loginname;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *isDefault;
@end

@class HospitalModel;
@class UserInfoModel;
@interface LoginInfoModel :BaseModel
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSDictionary *hospital;
@property (nonatomic, strong) HospitalModel *hospitalModel;
@property (nonatomic, copy) NSDictionary *doctor;
@property (nonatomic, strong) BaseUserInfoModel *infoModel;
@property (nonatomic, copy) NSString *isDefaultPwd;
@property (nonatomic, copy) NSDictionary *user;
@property (nonatomic, strong) UserInfoModel *customModel;
@end

@interface HospitalModel : BaseModel<NSCoding>
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *adduser;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cost_money;
@property (nonatomic, copy) NSString *depname;
@property (nonatomic, copy) NSString *drug_source;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *hospital_code;
@property (nonatomic, copy) NSString *hospital_id;
@property (nonatomic, copy) NSString *hospitaladdress;
@property (nonatomic, copy) NSString *hospitalname;
@property (nonatomic, copy) NSString *hospitaltel;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *pharmacy_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *short_name;
@property (nonatomic, copy) NSString *total_money;
@end


@interface UserInfoModel : BaseModel
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *pwdStatus;
@property (nonatomic, copy) NSString *myInviteCode;
@property (nonatomic, copy) NSString *inviteUrl;
@property (nonatomic, copy) NSString *promoteUrl;
@property (nonatomic, copy) NSString *agent;
@end

NS_ASSUME_NONNULL_END
