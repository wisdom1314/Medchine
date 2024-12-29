//
//  PersonalDetailCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *secondDetailInfoLab;

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
