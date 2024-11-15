//
//  UITableViewCell+Configure.h
//  SimiBao
//
//  Created by 张智慧 on 2020/8/5.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Configure)
/// 创建cell
+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
