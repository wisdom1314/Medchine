//
//  LeftTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeftTableViewCell : UITableViewCell
+ (CGFloat)getCellHeight;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
