//
//  ExcipentTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/25.
//

#import "ExcipentTableViewCell.h"
@interface ExcipentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *namLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation ExcipentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    
    ExcipentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExcipentTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ExcipentTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight{
    return 95;
}

- (void)setModel:(ExcipientItemModel *)model {
    _model = model;
    self.namLab.text = model.name;
    self.priceLab.text = [NSString stringWithFormat:@"%.4f元/克",[model.price floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
