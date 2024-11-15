//
//  PickupAddressCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/16.
//

#import "PickupAddressCell.h"
@interface PickupAddressCell()

@property (weak, nonatomic) IBOutlet UILabel *simpleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@end

@implementation PickupAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    PickupAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickupAddressCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PickupAddressCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight {
    return 90;
}

- (void)setModel:(SelfPickModel *)model {
    _model = model;
    self.simpleNameLab.text = model.simpleName;
    self.phoneLab.text = model.phone;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.address];
    if(model.isSelect) {
        self.selectImgView.image = [UIImage imageNamed:@"circle_selected"];
    }else {
        self.selectImgView.image = [UIImage imageNamed:@"circle_unselect"];
    }
}


@end
