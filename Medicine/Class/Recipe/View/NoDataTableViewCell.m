//
//  NoDataTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/22.
//

#import "NoDataTableViewCell.h"

@implementation NoDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    
    NoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoDataTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NoDataTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
