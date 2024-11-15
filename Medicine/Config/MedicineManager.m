//
//  MedicineManager.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "MedicineManager.h"

@implementation MedicineManager

/// 单例创建
+ (instancetype)sharedInfo{
    static dispatch_once_t onceToken;
    static MedicineManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[MedicineManager alloc] init];
    });
    return manager;
}


@end
