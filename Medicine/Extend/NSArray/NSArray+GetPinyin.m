//
//  NSArray+GetPinyin.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/20.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "NSArray+GetPinyin.h"

@implementation NSArray (GetPinyin)

- (NSArray *)getKeysAndResults {
    NSMutableArray * mutableArr = [NSMutableArray array];
    NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < self.count; i ++) {
        id model = self[i];
        NSDictionary * dict = [model mj_keyValues];
        /// 获取到姓名的大写首字母
        NSString *firstLetterString =  [self firstCharactor:dict[@"toRealName"]];
        
        /// 如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
        if (addressBookDict[firstLetterString]) {
            [addressBookDict[firstLetterString] addObject:model];
        }
        /// 没有出现过该首字母，则在字典中新增一组key-value
        else {
            /// 创建新发可变数组存储该首字母对应的联系人模型 其他的作为#
            NSMutableArray *arrGroupNames = [NSMutableArray array];
            [arrGroupNames addObject:model];
            /// 将首字母-姓名数组作为key-value加入到字典中
            [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
        }
    }
    /// 将addressBookDict字典中的所有Key值进行排序: A~Z
    NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    /// 将 "#" 排列在 A~Z 的后面
    NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
    if ([nameKeys.firstObject isEqualToString:@"#"]) {
        [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
        [mutableNamekeys removeObjectAtIndex:0];
    }
    // 数组中第一个元素是最终的结果  第二个元素是键
    [mutableArr addObject:addressBookDict];
    [mutableArr addObject:mutableNamekeys];
    
    return mutableArr;
}

#pragma mark -- 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString {
    /// 转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    /// 先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    /// 再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    /// 转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    /// 获取并返回首字母
    if([self judgeString:[pinYin substringToIndex:1]]) {
        return [pinYin substringToIndex:1];
    }
    return @"#";
}


- (BOOL)judgeString:(NSString *)string{
    NSString *regex =@"[A-Za-z]+";
    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return[predicate evaluateWithObject:string];

}


@end
