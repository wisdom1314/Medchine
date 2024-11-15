//
//  DoctorGridCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/18.
//

#import "DoctorGridCell.h"



@implementation DoctorGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    DoctorGridCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorGridCellId"];
    if(!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DoctorGridCell" owner:self options:nil].lastObject;
    }
    return cell;
}
- (IBAction)chooseType:(UIButton *)sender {
    if(self.typeBlock) {
        self.typeBlock(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
