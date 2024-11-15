//
//  UITableViewCell+Configure.m
//  SimiBao
//
//  Created by 张智慧 on 2020/8/5.
//  Copyright © 2020 张智慧. All rights reserved.
//

#import "UITableViewCell+Configure.h"

@implementation UITableViewCell (Configure)

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


@end
