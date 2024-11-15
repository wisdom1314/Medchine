//
//  PickupAddressCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PickupAddressCell : UITableViewCell
+ (CGFloat)getCellHeight;
@property (nonatomic, strong) SelfPickModel *model;
@end

NS_ASSUME_NONNULL_END
