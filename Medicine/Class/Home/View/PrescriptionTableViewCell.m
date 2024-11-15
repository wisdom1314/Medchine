//
//  PrescriptionTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import "PrescriptionTableViewCell.h"

@implementation PrescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)getCellHeight {
    return 45;
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    PrescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrescriptionTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PrescriptionTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

- (void)setModel:(RecipeDailyItemModel *)model {
    _model = model;
    self.priceLab.text = model.amount;
    self.dateStr.text = model.date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
