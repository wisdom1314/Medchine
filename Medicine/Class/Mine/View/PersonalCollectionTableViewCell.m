//
//  PersonalCollectionTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/26.
//

#import "PersonalCollectionTableViewCell.h"

@implementation PersonalCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)infoClickk:(UIButton *)sender {
    if(self.subject) {
        [self.subject sendNext:@(sender.tag)];
    }
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"PersonalCollectionTableViewCellFristIId";
    if(indexPath.section == 0) {
        selectTag = 0;
        identifier = @"PersonalCollectionTableViewCellFristIId";
    }else if(indexPath.section == 1) {
        selectTag = 1;
        identifier = @"PersonalCollectionTableViewCellSecondId";
    }else if(indexPath.section == 2) {
        selectTag = 2;
        identifier = @"PersonalCollectionTableViewCellThridId";
    }else  {
        selectTag = 3;
        identifier = @"PersonalCollectionTableViewCellForthIId";
    }
    PersonalCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalCollectionTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 145;
    }else if(indexPath.section == 1) {
        return 375;
    }else if(indexPath.section == 2) {
        return 200;
    }else {
        return 140;
    }
}

- (RACSubject *)subject {
    if(!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
