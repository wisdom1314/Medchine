//
//  InfoTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoTableViewCell : UITableViewCell
+ (CGFloat)getCellHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *textLab;

@end

NS_ASSUME_NONNULL_END
