//
//  PersonalDetailCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/29.
//

#import "PersonalDetailCell.h"

@implementation PersonalDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"PersonalDetailCellFristId";
    if(indexPath.section == 0) {
        selectTag = 0;
        identifier = @"PersonalDetailCellFristId";
    }else  {
        selectTag = 1;
        identifier = @"PersonalDetailCellSecondId";
    }
    PersonalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalDetailCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 85;
    }else {
        return 210;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
