//
//  PersonalCollectionTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCollectionTableViewCell : UITableViewCell

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath;

@property (nonatomic, strong) RACSubject *subject;

@end

NS_ASSUME_NONNULL_END
