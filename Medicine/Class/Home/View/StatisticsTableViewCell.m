//
//  StatisticsTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import "StatisticsTableViewCell.h"

@interface StatisticsTableViewCell()

@end

@implementation StatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.seeDetailBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
    
    NSDictionary *attributesDict = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:13],
                                         NSForegroundColorAttributeName:COLOR_562306
                                         };//还可以添加其他属性
    [self.segment setTitleTextAttributes:attributesDict forState:UIControlStateNormal];
    [self.segment setTitleTextAttributes:attributesDict forState:UIControlStateSelected];
    [self.segment setBackgroundImage:[ClassMethod imageWithColor:COLOR_F2E7D6]
                          forState:UIControlStateNormal
                        barMetrics:UIBarMetricsDefault];
    [self.segment setBackgroundImage:[ClassMethod imageWithColor:COLOR_FFFFFF]
                          forState:UIControlStateSelected
                        barMetrics:UIBarMetricsDefault];
    [self.segment setDividerImage:[ClassMethod imageWithColor:COLOR_F2E7D6] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    // Initialization code
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    StatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticsTableViewCellId"];
    if(!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"StatisticsTableViewCell" owner:self options:nil].lastObject;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
