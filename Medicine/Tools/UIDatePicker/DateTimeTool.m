//
//  DateTimeTool.m
//  MirrorAdjacent
//
//  Created by 张智慧 on 2020/9/25.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "DateTimeTool.h"

@implementation DateTimeTool

/// 获取年月日对象
+(NSDateComponents *)getDateComponents:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setFirstWeekday:2]; //设置每周的开始是星期一
    //    [calendar setMinimumDaysInFirstWeek:7]; //设置一周至少需要几天
    return [calendar components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekOfYear|
            NSCalendarUnitQuarter fromDate:date];
}

//获得某年的周数
+ (NSInteger)getWeek_AccordingToYear:(NSInteger)year {
    
    NSDateComponents *comps = [DateTimeTool getDateComponents:[DateTimeTool dateFromString:[NSString stringWithFormat:@"%ld-12-31",year] DateFormat:@"yyyy-MM-dd"]];
    NSInteger week = [comps weekOfYear];
    if (week == 1) {
        return 52;
    }else {
        return week;
    }
}


/**
 *  获取某年某周的范围日期
 *
 *  @param year       年份
 *  @param weekofYear year里某个周
 *
 *  @return 时间范围字符串
 */


+(NSString*)getWeekRangeDate_Year:(NSInteger)year WeakOfYear:(NSInteger)weekofYear
{
    NSString *weekDate = @"";
    NSString *timeAxis = [NSString stringWithFormat:@"%ld-06-01 12:00:00",(long)year];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeAxis];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**这两个参数的设置影响着周次的个数和划分*****************/
    [calendar setFirstWeekday:2]; //设置每周的开始是星期一
    //    [calendar setMinimumDaysInFirstWeek:7]; //设置一周至少需要几天
    NSDateComponents *comps = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                          fromDate:date];
    //时间轴是当前年的第几周
    NSInteger todayIsWeek = [comps weekOfYear];
    if ([DateTimeTool getWeek_AccordingToYear:year] == 53) {
        todayIsWeek += 1;
    }
    //获取时间轴是星期几 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger todayIsWeekDay = [comps weekday];
    // 计算当前日期和这周的星期一和星期天差的天数
    //firstDiff 星期一相差天数 、 lastDiff 星期天相差天数
    long firstDiff,lastDiff;
    if (todayIsWeekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else
    {
        firstDiff = [calendar firstWeekday] - todayIsWeekDay;
        lastDiff = 8 - todayIsWeekDay;
    }
    
    NSDate *firstDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*firstDiff sinceDate:date];
    NSDate *lastDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*lastDiff sinceDate:date];
    
    long weekdifference = weekofYear - todayIsWeek;
    
    firstDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*7*weekdifference sinceDate:firstDayOfWeek];
    lastDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*7*weekdifference sinceDate:lastDayOfWeek];
    
    weekDate = [NSString stringWithFormat:@"第%ld周(%@-%@)",weekofYear,[DateTimeTool stringFromDate:firstDayOfWeek DateFormat:@"yyyy年M月d号"],[DateTimeTool stringFromDate:lastDayOfWeek DateFormat:@"yyyy年M月d号"]];
    
    return weekDate;
}

/**************************当前时间********************************/
+(NSDateComponents *)getCurrentDateComponents {
    return [DateTimeTool getDateComponents:[NSDate date]];
}
+(NSInteger)getCurrentWeek {
    NSInteger week = [[DateTimeTool stringFromDate:[NSDate date] DateFormat:@"w"] intValue];
    return week;
}
+(NSInteger)getCurrentYear{
    NSInteger year = [[DateTimeTool stringFromDate:[NSDate date] DateFormat:@"y"] intValue];
    return year;
}

+(NSInteger)getCurrentQuarter{
    NSInteger quarter = [[DateTimeTool stringFromDate:[NSDate date] DateFormat:@"q"] intValue];
    return quarter;
}

+(NSInteger)getCurrentMonth{
    NSInteger month = [[DateTimeTool stringFromDate:[NSDate date] DateFormat:@"M"] intValue];
    return month;
}

+(NSInteger)getCurrentDay{
    NSInteger day = [[DateTimeTool stringFromDate:[NSDate date] DateFormat:@"d"] intValue];
    return day;
}



+ (NSString *)beforeMonth {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    return [DateTimeTool stringFromDate:newdate DateFormat:@"yyyy-MM"];
}

+ (NSString *)afterMonth {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:+1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    return [DateTimeTool stringFromDate:newdate DateFormat:@"yyyy-MM"];
}

+ (NSString *)beforeYear {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setYear:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    return [DateTimeTool stringFromDate:newdate DateFormat:@"yyyy-MM-dd"];
}

//NSString转NSDate
+(NSDate *)dateFromString:(NSString *)dateString DateFormat:(NSString *)DateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormat];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//NSDate转NSString
+(NSString *)stringFromDate:(NSDate *)date DateFormat:(NSString *)DateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DateFormat];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//时间追加
+(NSString *)dateByAddingTimeInterval:(NSTimeInterval)TimeInterval DataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat{
    NSString *str = nil;
    NSDate *date = [self dateFromString:dateStr DateFormat:DateFormat];
    NSDate * newDate = [date dateByAddingTimeInterval:TimeInterval];
    str = [self stringFromDate:newDate DateFormat:DateFormat];
    return str;
}



//日期字符串格式化
+(NSString *)getDataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat {
    return [self getDataTime:dateStr DateFormat:DateFormat oldDateFormat:nil];
}


+(NSString *)getDataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat oldDateFormat:(NSString *)oldDateFormat{
    
    if (!dateStr || [dateStr isEqualToString:@"—"]) {
        return @"—";
    }
    
    if ([dateStr isEqualToString:@"0"]) {
        return @"0";
    }
    
    if ([dateStr rangeOfString:@"+"].location != NSNotFound) {
        NSArray *strarray = [dateStr componentsSeparatedByString:@"+"];
        dateStr = strarray[0];
    }
    
    if ([dateStr rangeOfString:@"."].location != NSNotFound) {
        NSArray *strarray = [dateStr componentsSeparatedByString:@"."];
        dateStr = strarray[0];
    }
    
    if ([dateStr rangeOfString:@"T"].location != NSNotFound) {
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    [newDateFormatter setDateFormat:DateFormat];
    
    NSDateFormatter *oldDateFormatter = [[NSDateFormatter alloc] init];
    
    if (oldDateFormat) {
        [oldDateFormatter setDateFormat:oldDateFormat];
    }else {
        [oldDateFormatter setDateFormat:[self getFormat:dateStr]];
    }
    
    NSDate *date = [oldDateFormatter dateFromString:dateStr];
    
    return [newDateFormatter stringFromDate:date];
}

+(int)getNumberOfCharactersInString:(NSString *)str c:(char)c {
    int count = 0;
    if ([str rangeOfString:[NSString stringWithFormat:@"%c",c]].location != NSNotFound){
        for (int i=0;i<str.length;i++){
            if ([str characterAtIndex:i] == c){
                count++;
            }
        }
    }
    return count;
}

+(NSString *)getFormat:(NSString *)dateString {
    NSString *str = [NSString new];
    int size = [self getNumberOfCharactersInString:dateString c:'-'];
    if (size == 0){
        str = [str stringByAppendingString:@"yyyy"];
    }else if (size == 1){
        str = [str stringByAppendingString:@"yyyy-MM"];
    }else if (size == 2){
        str = [str stringByAppendingString:@"yyyy-MM-dd"];
    }
    size = [self getNumberOfCharactersInString:dateString c:':'];
    if (size == 0 && [dateString rangeOfString:@" "].location != NSNotFound){
        str = [str stringByAppendingString:@" HH"];
    }else if (size == 1){
        str = [str stringByAppendingString:@" HH:mm"];
    }else if (size == 2){
        str = [str stringByAppendingString:@" HH:mm:ss"];
    }
    return str;
}


/**
 *  json日期转iOS时间
 *
 *  @param string /Date()
 *
 *  @return
 */
+(NSString *)interceptTimeStampFromStr:(NSString *)string DateFormat:(NSString *)DateFormat{
    if (!string || [string length] == 0 ) // 传入时间戳为空 返回
    {
        return @"—";
    }
    NSMutableString * mutableStr = [NSMutableString stringWithString:string];
    NSString * timeStampString = [NSString string];
    //  遍历取出括号内的时间戳
    for (int i = 0; i < string.length; i ++) {
        NSRange startRang = [mutableStr rangeOfString:@"("];
        NSRange endRang = [mutableStr rangeOfString:@")"];
        if (startRang.location != NSNotFound) {
            // 左边括号位置
            NSInteger leftLocation = startRang.location;
            // 右边括号距离左边括号的长度
            NSInteger rightLocation = endRang.location - startRang.location;
            // 截取括号时间戳内容
            timeStampString = [mutableStr substringWithRange:NSMakeRange(leftLocation + 1,rightLocation - 1)];
        }
    }
    
    // 把时间戳转化成时间
    NSTimeInterval interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:DateFormat];//年月日时分秒
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    return timeStr;
}


// 获取当前月的第一天
+ (NSDate *)getFirstDayOfCurrentMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    components.day = 1;
    return [calendar dateFromComponents:components];
}


// 获取当前月的最后一天
+ (NSDate *)getLastDayOfCurrentMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:now];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    components.day = range.length;
    return [calendar dateFromComponents:components];
}


+ (NSDate *)getFirstDayOfCurrentYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:now];
    components.month = 1;
    components.day = 1;
    return [calendar dateFromComponents:components];
}

// 获取当前年的最后一天
+ (NSDate *)getLastDayOfCurrentYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:now];
    components.month = 12;
    components.day = 31;
    return [calendar dateFromComponents:components];
}


+ (NSDate *)getYesterday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *yesterday = [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:-1
                                             toDate:now
                                            options:0];
    return yesterday;
}


+ (NSDictionary *)getLast7DaysRange {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];

    // 计算结束日期（即今天）
    NSDate *endDate = [calendar startOfDayForDate:now];

    // 计算开始日期（即 7 天前）
    NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:-6 // 7天的范围，-6天为开始日期
                                             toDate:endDate
                                            options:0];
    
    return @{@"startDate": startDate, @"endDate": endDate};
}


+ (NSDictionary *)getLast30DaysRange {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];

    // 计算结束日期（即今天）
    NSDate *endDate = [calendar startOfDayForDate:now];

    // 计算开始日期（即 30 天前）
    NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                              value:-29 // 30天的范围，-29天为开始日期
                                             toDate:endDate
                                            options:0];
    
    return @{@"startDate": startDate, @"endDate": endDate};
}

@end
