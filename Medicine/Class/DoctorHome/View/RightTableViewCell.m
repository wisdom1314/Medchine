//
//  RightTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RightTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight {
    return 70;
}

- (void)setModel:(RecipesampleSymptomsModel *)model {
    _model = model;
    self.nameLab.text = model.recipesampleName;
    self.timeLab.text = model.addtime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
