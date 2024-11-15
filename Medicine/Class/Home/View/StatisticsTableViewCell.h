//
//  StatisticsTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seeDetailBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *tgNumLab;
@property (weak, nonatomic) IBOutlet UILabel *inviateLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@end

NS_ASSUME_NONNULL_END
