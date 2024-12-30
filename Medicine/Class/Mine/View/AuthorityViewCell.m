//
//  AuthorityViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/29.
//

#import "AuthorityViewCell.h"

@implementation AuthorityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    AuthorityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthorityViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AuthorityViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight{
    return 70;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
