//
//  StatementTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import "StatementTableViewCell.h"
@interface StatementTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *granuleLab;
@property (weak, nonatomic) IBOutlet UILabel *sumherbDoseLab;

@end

@implementation StatementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    StatementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatementTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StatementTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

- (void)setModel:(ReportDrugModel *)model {
    _model = model;
    self.granuleLab.text = model.granule_name;
    self.sumherbDoseLab.text = model.sum_herb_dose;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
