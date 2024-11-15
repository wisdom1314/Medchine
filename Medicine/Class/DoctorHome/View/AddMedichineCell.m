//
//  AddMedichineCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "AddMedichineCell.h"
@interface AddMedichineCell()
@property (weak, nonatomic) IBOutlet UILabel *namLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *headLab;

@end

@implementation AddMedichineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    
    AddMedichineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMedichineCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddMedichineCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight{
    return 95;
}

- (void)setModel:(DrugItemModel *)model  {
    _model = model;
   
    if(model.isEx) {
        self.unitLab.text = @"每袋相当于饮片:";
        self.namLab.text = model.drugname;
        self.headLab.text = @"袋装单价:";
        self.priceLab.text = [NSString stringWithFormat:@"%@元/袋",model.sell_price];
        self.amountLab.text = [NSString stringWithFormat:@"%@g",model.equivalent];
    }else {
        self.namLab.text = model.drugname;
        self.priceLab.text = [NSString stringWithFormat:@"%.4f", [model.sell_price floatValue]];
        self.amountLab.text = model.useful_value;
    }
    
}

@end
