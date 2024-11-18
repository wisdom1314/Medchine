//
//  CustomRecipeTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import "CustomRecipeTableViewCell.h"

@interface CustomRecipeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *stausLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;

@property (weak, nonatomic) IBOutlet UILabel *ageLab;

@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *recipe_noLab;
@property (weak, nonatomic) IBOutlet UILabel *granule_total_noLab;
@property (weak, nonatomic) IBOutlet UILabel *recipe_sale_priceLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLab;
@end

@implementation CustomRecipeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)getCellHeight {
    return 185;
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    CustomRecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomRecipeTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomRecipeTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

- (void)setModel:(RecipeOrderItemModel *)model {
    _model = model;
    self.recipeNameLab.text = model.recipe_name;
    self.timeLab.text = [NSString stringWithFormat:@"%@ %@",model.doctor, model.recipe_time];
    if([model.recipe_status isEqualToString:@"NEW"]) {
        self.stausLab.text = @"新处方";
    }else if([model.recipe_status isEqualToString:@"AUDIT"]) {
        self.stausLab.text = @"已审方";
    }else if([model.recipe_status isEqualToString:@"DOWNLOAD"]) {
        self.stausLab.text = @"已下载";
    }else if([model.recipe_status isEqualToString:@"DELIVERY"]) {
        self.stausLab.text = @"已发货";
    }else if([model.recipe_status isEqualToString:@"FINISH"]) {
        self.stausLab.text = @"已完成";
    }else if([model.recipe_status isEqualToString:@"CANCEL"])  {
        self.stausLab.text = @"已取消";
    }
    self.nameLab.text = model.name;
    self.sexLab.text = model.sex;
    self.ageLab.text = model.age;
    self.phoneLab.text = model.phone;
    self.recipe_noLab.text = model.recipe_no;
    self.granule_total_noLab.text = model.granule_total_no;
    self.recipe_sale_priceLab.text = [NSString stringWithFormat:@"%.2f", [model.recipe_sale_price doubleValue]];
  
    self.doctorNameLab.text = [NSString stringWithFormat:@"医生：%@", model.doctor];
  
    if([model.payment_status isEqualToString:@"WAIT"]) {
        [self.payStatusBtn setTitle:@"待缴费" forState:UIControlStateNormal];
    }else if([model.payment_status isEqualToString:@"PAYED"]) {
        [self.payStatusBtn setTitle:@"已缴费" forState:UIControlStateNormal];
    }else if([model.payment_status isEqualToString:@"REFUND"]) {
        [self.payStatusBtn setTitle:@"已退单" forState:UIControlStateNormal];
    }else if([model.payment_status isEqualToString:@"CANCEL"]) {
        [self.payStatusBtn setTitle:@"已取消" forState:UIControlStateNormal];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
