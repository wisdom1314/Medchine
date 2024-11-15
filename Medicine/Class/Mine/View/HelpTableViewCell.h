//
//  HelpTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

+ (CGFloat)getCellHeightWith:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
