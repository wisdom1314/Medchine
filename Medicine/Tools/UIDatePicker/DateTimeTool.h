//
//  DateTimeTool.h
//  MirrorAdjacent
//
//  Created by 张智慧 on 2020/9/25.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateTimeTool : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString DateFormat:(NSString *)DateFormat;
+ (NSString *)stringFromDate:(NSDate *)date DateFormat:(NSString *)DateFormat;
+ (NSString *)dateByAddingTimeInterval:(NSTimeInterval)TimeInterval DataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat;
+ (NSInteger)getCurrentYear;
+ (NSInteger)getCurrentMonth;
+ (NSString *)beforeMonth;
+ (NSString *)afterMonth;
+ (NSString *)beforeYear;
+ (NSDate *)getFirstDayOfCurrentMonth;
+ (NSDate *)getLastDayOfCurrentMonth;
+ (NSDate *)getFirstDayOfCurrentYear;
+ (NSDate *)getLastDayOfCurrentYear;
+ (NSDate *)getYesterday;
+ (NSDictionary *)getLast7DaysRange;
+ (NSDictionary *)getLast30DaysRange;

@end

NS_ASSUME_NONNULL_END
