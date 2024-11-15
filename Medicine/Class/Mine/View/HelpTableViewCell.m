//
//  HelpTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import "HelpTableViewCell.h"

@implementation HelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HelpTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSString *)content {
    return [ClassMethod sizeText:content font:[UIFont systemFontOfSize:14] limitWidth:WIDE - 30].height + 35;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
