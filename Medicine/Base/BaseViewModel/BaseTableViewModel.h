//
//  BaseTableViewModel.h
//  SimiBao
//
//  Created by 张智慧 on 2020/8/7.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>


- (void)handleWithTableView:(UITableView *)tableView;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;


@end

NS_ASSUME_NONNULL_END
