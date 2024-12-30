//
//  AuthorityViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorityViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UILabel *detaiInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *permissionLab;
+ (CGFloat)getCellHeight;
@end

NS_ASSUME_NONNULL_END
