//
//  StatementModel.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/15.
//

#import "StatementModel.h"

@implementation StatementModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"report_drug_list" : @"ReportDrugModel"
             };
}
@end


@implementation ReportDrugModel

@end



@implementation DoctorListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"doctor_list" : @"BaseUserInfoModel"
             };
}

@end
