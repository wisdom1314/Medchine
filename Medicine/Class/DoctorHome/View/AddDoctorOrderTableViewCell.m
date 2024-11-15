//
//  AddDoctorOrderTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "AddDoctorOrderTableViewCell.h"

@interface AddDoctorOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end

@implementation AddDoctorOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    
    AddDoctorOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDoctorOrderTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddDoctorOrderTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(AttentionItemModel *)model{
    
    return [ClassMethod sizeText:model.careful font:[UIFont systemFontOfSize:14] limitWidth:WIDE-75].height + 55;
}

- (void)setModel:(AttentionItemModel *)model {
    _model = model;
    self.detailLab.text = model.careful;
}



@end
