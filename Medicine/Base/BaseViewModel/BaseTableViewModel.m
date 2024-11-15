//
//  BaseTableViewModel.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/7.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "BaseTableViewModel.h"

@implementation BaseTableViewModel

- (void)handleWithTableView:(UITableView *)tableView {
    tableView.delegate = self;
    tableView.dataSource = self;
    if(@available(iOS 11.0,*)) {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:@"抽象方法未实现"
      reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
    userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"抽象方法未实现"
      reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
    userInfo:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end


