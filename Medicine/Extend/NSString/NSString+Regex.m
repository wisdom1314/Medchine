//
//  NSString+Regex.m
//  uliaobao
//
//  Created by FishYu on 16/7/1.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

+ (BOOL)validateNumberByRegExp:(NSString *)string{
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}
+ (BOOL)validatephoneNumbByRegExp:(NSString *)string{
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9_]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}


+ (BOOL)validateChineseByRegExp:(NSString *)string{
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[\u4e00-\u9fa5]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}


+ (BOOL)validateFabricNameByRegExp:(NSString *)string{
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[\u4E00-\u9FA5A-Za-z0-9_\\s]{0,30}$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}


+ (BOOL)validateFabricMemo:(NSString *)string{

    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[\u4E00-\u9FA5A-Za-z0-9_\\s]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;

}

+ (BOOL)validateTwoDecimalsNum:(NSString *)string{
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"^[0-9]+(\\.[0-9]{0,2})?$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}
@end
