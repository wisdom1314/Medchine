//
//  NSString+Filter.m
//  ALAMHCustomer
//
//  Created by 张智慧 on 2019/7/2.
//  Copyright © 2019 张智慧. All rights reserved.
//

#import "NSString+Filter.h"

@implementation NSString (Filter)

+ (BOOL)isEmpty:(NSString *)text {
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    }
    return NO;
}

+ (NSString *)cancelEmpty:(NSString *)text {
    if ([text isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (text == nil){
        return @"";
    }
    return text;
}

@end
