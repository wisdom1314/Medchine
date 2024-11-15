//
//  NSString+Regex.h
//  uliaobao
//
//  Created by FishYu on 16/7/1.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 常用正则表达式判断
@interface NSString (Regex)

/**
 *  @author YWC, 16-07-01 12:07:53
 *
 *  是否字符串中全是数字(不包含小数点)
 *
 *  @param string 需要判断的字符串
 *
 *  @return YES OR NO
 *
 *  @since 5.2.0
 */
+ (BOOL)validateNumberByRegExp:(NSString *)string;


/**
 *  @author YWC, 16-07-01 15:07:25
 *
 *  匹配字符串中是否全是汉字
 *
 *  @param string 需要判断的字符串
 *
 *  @return YES OR NO
 *
 *  @since 5.2.0
 */
+ (BOOL)validateChineseByRegExp:(NSString *)string;


/**
 *  @author YWC, 16-07-01 16:07:16
 *
 *  判断面料输入的单个字符串是否符合规则
 *
 *  @param string 输入的单个字符串
 *
 *  @return YES OR NO
 *
 *  @since 5.2.0
 */
+ (BOOL)validateFabricNameByRegExp:(NSString *)string;


+ (BOOL)validatephoneNumbByRegExp:(NSString *)string;


+ (BOOL)validateFabricMemo:(NSString *)string;


/**
 有效的2位小数数字
 
 @param string 判断字符

 @return YES OR NO
 */
+ (BOOL)validateTwoDecimalsNum:(NSString *)string;

@end
