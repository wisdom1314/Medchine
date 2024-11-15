//
//  RecipeOrderTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import "RecipeOrderTableViewCell.h"
@interface RecipeOrderTableViewCell()
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnHeight;

@end

@implementation RecipeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    RecipeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeOrderTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeOrderTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith: (RecipeOrderItemModel* )model{
    if([model.payment_status isEqualToString:@"WAIT"] && [model.is_self_support integerValue] == 0) {
        return 230;
    }
    return 190;
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
    /// 精度丢失
//    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
//    NSString *doubleString  = [NSString stringWithFormat:@"%lf", [model.recipe_sale_price doubleValue]];
//    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
//    NSNumber *numberrra = [multiplierNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    self.recipe_sale_priceLab.text = [NSString stringWithFormat:@"%.2f", [model.recipe_sale_price doubleValue]];
   
    self.bottomBtn.hidden = NO;
    self.topBtn.hidden = NO;
    self.centerBtn.hidden = YES;
    self.centerBtnTop.constant = 0;
    self.centerBtnHeight.constant =0;
    self.centerBtnWidth.constant = 60;
    self.topBtnWidth.constant = 60;
    if([model.payment_status isEqualToString:@"WAIT"]) {
        if([model.is_self_support integerValue] == 0) {
            [self.topBtn setTitle:@"扫码缴费" forState:UIControlStateNormal];
            self.topBtnWidth.constant = 90;
            self.centerBtnTop.constant = 10;
        }else {
            self.topBtnHeight.constant = 0;
            self.topBtn.hidden = YES;
        }
        self.centerBtn.hidden = NO;
        [self.centerBtn setTitle:@"余额缴费" forState:UIControlStateNormal];
        self.centerBtnHeight.constant =27;
        self.centerBtnWidth.constant = 90;
        [self.bottomBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else if([model.payment_status isEqualToString:@"PAYED"]) {
        [self.topBtn setTitle:@"已缴费" forState:UIControlStateNormal];
        if(model.tag == 1) {
            [self.bottomBtn setTitle:@"取消" forState:UIControlStateNormal];
        }else {
            self.bottomBtn.hidden = YES;
        }
        
    }else if([model.payment_status isEqualToString:@"REFUND"]) {
        [self.topBtn setTitle:@"已退单" forState:UIControlStateNormal];
        self.bottomBtn.hidden = YES;
    }else if([model.payment_status isEqualToString:@"CANCEL"]) {
        [self.topBtn setTitle:@"已取消" forState:UIControlStateNormal];
        if(model.tag == 0) {
            [self.bottomBtn setTitle:@"删除" forState:UIControlStateNormal];
        }else {
            self.bottomBtn.hidden = YES;
        }
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
