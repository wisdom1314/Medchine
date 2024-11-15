//
//  BaseModel.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/5.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {// 以字符串类型为例
        return  @"";
    }

    return oldValue;
}

@end




@implementation BaseUserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.doctor_id forKey:@"doctor_id"];
    [aCoder encodeObject:self.doctorname forKey:@"doctorname"];
    [aCoder encodeObject:self.hospital_id forKey:@"hospital_id"];
    [aCoder encodeObject:self.adduser forKey:@"adduser"];
    [aCoder encodeObject:self.addtime forKey:@"addtime"];
    [aCoder encodeObject:self.department_id forKey:@"department_id"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.unioncode forKey:@"unioncode"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.loginname forKey:@"loginname"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.is_delete forKey:@"is_delete"];
    [aCoder encodeObject:self.isDefault forKey:@"isDefault"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.doctor_id  = [aDecoder decodeObjectForKey:@"doctor_id"];
        self.doctorname  = [aDecoder decodeObjectForKey:@"doctorname"];
        self.hospital_id  = [aDecoder decodeObjectForKey:@"hospital_id"];
        self.adduser = [aDecoder decodeObjectForKey:@"adduser"];
        self.addtime = [aDecoder decodeObjectForKey:@"addtime"];
        self.department_id = [aDecoder decodeObjectForKey:@"department_id"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.unioncode = [aDecoder decodeObjectForKey:@"unioncode"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.loginname = [aDecoder decodeObjectForKey:@"loginname"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.is_delete = [aDecoder decodeObjectForKey:@"is_delete"];
        self.isDefault = [aDecoder decodeObjectForKey:@"isDefault"];
    }
    return self;
}

@end


@implementation LoginInfoModel

@end


@implementation HospitalModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.addtime forKey:@"addtime"];
    [aCoder encodeObject:self.adduser forKey:@"adduser"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.cost_money forKey:@"cost_money"];
    [aCoder encodeObject:self.depname forKey:@"depname"];
    [aCoder encodeObject:self.drug_source forKey:@"drug_source"];
    [aCoder encodeObject:self.flag forKey:@"flag"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.hospital_code forKey:@"hospital_code"];
    [aCoder encodeObject:self.hospital_id forKey:@"hospital_id"];
    [aCoder encodeObject:self.hospitaladdress forKey:@"hospitaladdress"];
    [aCoder encodeObject:self.hospitalname forKey:@"hospitalname"];
    [aCoder encodeObject:self.hospitaltel forKey:@"hospitaltel"];
    [aCoder encodeObject:self.is_delete forKey:@"is_delete"];
    [aCoder encodeObject:self.parent forKey:@"parent"];
    [aCoder encodeObject:self.pharmacy_id forKey:@"pharmacy_id"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.scale forKey:@"scale"];
    [aCoder encodeObject:self.short_name forKey:@"short_name"];
    [aCoder encodeObject:self.total_money forKey:@"total_money"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.addtime  = [aDecoder decodeObjectForKey:@"addtime"];
        self.adduser  = [aDecoder decodeObjectForKey:@"adduser"];
        self.area  = [aDecoder decodeObjectForKey:@"area"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.cost_money = [aDecoder decodeObjectForKey:@"cost_money"];
        self.depname = [aDecoder decodeObjectForKey:@"depname"];
        self.drug_source = [aDecoder decodeObjectForKey:@"drug_source"];
        self.flag = [aDecoder decodeObjectForKey:@"flag"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.hospital_code = [aDecoder decodeObjectForKey:@"hospital_code"];
        self.hospital_id = [aDecoder decodeObjectForKey:@"hospital_id"];
        self.hospitaladdress = [aDecoder decodeObjectForKey:@"hospitaladdress"];
        self.hospitalname = [aDecoder decodeObjectForKey:@"hospitalname"];
        self.hospitaltel = [aDecoder decodeObjectForKey:@"hospitaltel"];
        self.is_delete = [aDecoder decodeObjectForKey:@"is_delete"];
        self.parent = [aDecoder decodeObjectForKey:@"parent"];
        self.pharmacy_id = [aDecoder decodeObjectForKey:@"pharmacy_id"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.scale = [aDecoder decodeObjectForKey:@"scale"];
        self.short_name = [aDecoder decodeObjectForKey:@"short_name"];
        self.total_money = [aDecoder decodeObjectForKey:@"total_money"];
    }
    return self;
}

@end



@implementation UserInfoModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.pwdStatus forKey:@"pwdStatus"];
    [aCoder encodeObject:self.myInviteCode forKey:@"myInviteCode"];
    [aCoder encodeObject:self.inviteUrl forKey:@"inviteUrl"];
    [aCoder encodeObject:self.promoteUrl forKey:@"promoteUrl"];
    [aCoder encodeObject:self.agent forKey:@"agent"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.userId  = [aDecoder decodeObjectForKey:@"userId"];
        self.userName  = [aDecoder decodeObjectForKey:@"userName"];
        self.userType  = [aDecoder decodeObjectForKey:@"userType"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.pwdStatus = [aDecoder decodeObjectForKey:@"pwdStatus"];
        self.myInviteCode = [aDecoder decodeObjectForKey:@"myInviteCode"];
        self.inviteUrl = [aDecoder decodeObjectForKey:@"inviteUrl"];
        self.promoteUrl = [aDecoder decodeObjectForKey:@"promoteUrl"];
        self.agent = [aDecoder decodeObjectForKey:@"agent"];
    }
    return self;
}
@end
