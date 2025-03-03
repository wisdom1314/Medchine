//
//  ComputeTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/25.
//

#import "ComputeTableViewCell.h"

@interface ComputeTableViewCell()

@end

@implementation ComputeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    
    ComputeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComputeTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ComputeTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight{
    return 60;
    
}

- (void)setModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath {
    if([model.recipe_type integerValue] == 0) {
        if(indexPath.row == 0) {
            self.valueLab.text = [NSString stringWithFormat:@"%.0ld", model.drugArr.count];
        }else if(indexPath.row  == 1) {
            /// 颗粒总剂量
            if(model.drugArr.count == 0) {
                self.valueLab.text = @"";
                return;
            }
            CGFloat totalKeliNum = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4;
            formatter.minimumFractionDigits = 4;
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] / [drugModel.useful_value floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalKeliNum += roundedValue;
            }
            model.total_granule_dose = [formatter stringFromNumber:@(totalKeliNum)];
            self.valueLab.text = [formatter stringFromNumber:@(totalKeliNum*[model.recipe_no integerValue])];
        
            model.totalKeli = self.valueLab.text;
            
            NSLog(@"sdsdsaaaaaaaadsd %@", [formatter stringFromNumber:@(totalKeliNum*[model.recipe_no integerValue])]);
            
        }else if(indexPath.row == 2) {
            if(model.drugArr.count == 0) {
                self.valueLab.text = @"";
                return;
            }
            /// 颗粒总价
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4; // 设置最多四位小数
            formatter.minimumFractionDigits = 4; // 设置最少四位小数
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice += roundedValue;
                
            }
            model.sell_price = [formatter stringFromNumber:@(totalPrice)]; ///单副
            totalPrice = totalPrice*[model.recipe_no  integerValue];
            self.valueLab.text = [formatter stringFromNumber:@(totalPrice)];
            
            if([model.is_secret integerValue] == 1) { /// 加密药方
                self.valueLab.text = [NSString stringWithFormat:@"%.2f",[model.totalSellPrice floatValue]];
            }
            
            model.sell_price_total = self.valueLab.text;
            
            
            /// 计算供货价格
            CGFloat totalPrice1 = 0;
            NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
            formatter1.numberStyle = NSNumberFormatterDecimalStyle;
            formatter1.maximumFractionDigits = 4; // 设置最多四位小数
            formatter1.minimumFractionDigits = 4; // 设置最少四位小数
            formatter1.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.supply_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice1 += roundedValue;
            }
            model.price = [formatter1 stringFromNumber:@(totalPrice1)]; ///单副
            totalPrice1 = totalPrice1*[model.recipe_no  integerValue];
            model.price_total = [formatter1 stringFromNumber:@(totalPrice1)];
            
            
            
            /// 颗粒总剂量
            CGFloat totalKeliNum = 0;
            NSNumberFormatter *formatter2 = [[NSNumberFormatter alloc] init];
            formatter2.numberStyle = NSNumberFormatterDecimalStyle;
            formatter2.maximumFractionDigits = 4;
            formatter2.minimumFractionDigits = 4;
            formatter2.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] / [drugModel.useful_value floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalKeliNum += roundedValue;
            }
            model.total_granule_dose = [formatter2 stringFromNumber:@(totalKeliNum)];

            
            model.totalKeli = [formatter stringFromNumber:@(totalKeliNum*[model.recipe_no integerValue])];
            
        }else if(indexPath.row == 3) {
            if(model.drugArr.count == 0) {
                self.valueLab.text = @"";
                return;
            }
            /// 运费
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4; // 设置最多四位小数
            formatter.minimumFractionDigits = 4; // 设置最少四位小数
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice += roundedValue;
            }
            totalPrice = totalPrice*[model.recipe_no  integerValue];
            if([model.delivery_mode integerValue] == 1 || totalPrice>150) {
                model.fee = @"0";
            }else {
                model.fee = @"10";
            }
            self.valueLab.text = model.fee;
        }else if(indexPath.row == 4) {
            if(model.drugArr.count == 0) {
                self.valueLab.text = @"";
                return;
            }
            /// 实收金额
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4; // 设置最多四位小数
            formatter.minimumFractionDigits = 4; // 设置最少四位小数
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice += roundedValue;
            }
            totalPrice = totalPrice*[model.recipe_no  integerValue];
            
          
            CGFloat fee = 0;
            if([model.delivery_mode integerValue] == 1 || totalPrice>150) {
               
                model.fee = @"0";
                fee = 0;
            }else {
                model.fee = @"10";
                fee = 10;
            }
            
            CGFloat finalPrice = totalPrice  + fee;
            
            
            self.valueLab.text = [NSString stringWithFormat:@"%.2f",finalPrice];
            model.recipe_sale_price = self.valueLab.text;
        }
    }else { /// 膏方
        if(indexPath.row == 0) {
            /// 处方味数
            self.valueLab.text = [NSString stringWithFormat:@"%ld", model.drugArr.count];
            
        }else if(indexPath.row == 1) {
            /// 颗粒总剂量
            CGFloat totalKeliNum = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4;
            formatter.minimumFractionDigits = 4;
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] / [drugModel.useful_value floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalKeliNum += roundedValue;
            }
            model.total_granule_dose = [formatter stringFromNumber:@(totalKeliNum)];
            self.valueLab.text = [formatter stringFromNumber:@(totalKeliNum*[model.recipe_no integerValue])];
            
            if([model.is_secret integerValue] == 1) { /// 加密药方
                self.valueLab.text = [formatter stringFromNumber:[NSNumber numberWithFloat:[model.recipeGranuleDose floatValue]*[model.recipe_no integerValue]]] ;
            }
            model.totalKeli = self.valueLab.text;

            
        }else if(indexPath.row == 2) {
            /// 颗粒总价
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4; // 设置最多四位小数
            formatter.minimumFractionDigits = 4; // 设置最少四位小数
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
              
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice += roundedValue;
            }
            model.sell_price = [formatter stringFromNumber:@(totalPrice)]; ///单副

            totalPrice = totalPrice*[model.recipe_no  integerValue];
            self.valueLab.text = [formatter stringFromNumber:@(totalPrice)];
            
            if([model.is_secret integerValue] == 1) { /// 加密药方
                self.valueLab.text = [NSString stringWithFormat:@"%.2f",[model.totalSellPrice floatValue]];
            }
            model.sell_price_total = self.valueLab.text;
            
            
            /// 计算供货价格
            CGFloat totalPrice1 = 0;
            NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
            formatter1.numberStyle = NSNumberFormatterDecimalStyle;
            formatter1.maximumFractionDigits = 4; // 设置最多四位小数
            formatter1.minimumFractionDigits = 4; // 设置最少四位小数
            formatter1.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.supply_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice1 += roundedValue;
            }
            model.price = [formatter1 stringFromNumber:@(totalPrice1)]; ///单副
            totalPrice1 = totalPrice1*[model.recipe_no  integerValue];
            model.price_total = [formatter1 stringFromNumber:@(totalPrice1)];
        
        }else if(indexPath.row == 3) {
            /// 运费
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4; // 设置最多四位小数
            formatter.minimumFractionDigits = 4; // 设置最少四位小数
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice += roundedValue;
            }
            totalPrice = totalPrice*[model.recipe_no  integerValue];
            if([model.delivery_mode integerValue] == 1 || totalPrice>150) {
                model.fee = @"0";
            }else {
                model.fee = @"10";
            }
            self.valueLab.text = model.fee;
            
        }else if(indexPath.row == 4) {
            /// 辅料总价
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            formatter.minimumFractionDigits = 2;
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (ExcipientItemModel *subModel in model.excipentArr) {
                CGFloat value = subModel.num * [subModel.price floatValue];
                CGFloat roundedValue = round(value * 100) / 100.0;
                totalPrice += roundedValue;
            }
            self.valueLab.text = [formatter stringFromNumber:@(totalPrice)];
            
        }else if(indexPath.row == 5) {
            /// 工本费
            self.valueLab.text = model.cost;
        }else if(indexPath.row == 6) {
            /// 实收金额
            CGFloat totalPrice = 0;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 4; // 设置最多四位小数
            formatter.minimumFractionDigits = 4; // 设置最少四位小数
            formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (DrugItemModel *drugModel in model.drugArr) {
                drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
                CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
                CGFloat roundedValue = round(value * 10000) / 10000.0;
                totalPrice += roundedValue;
            }
            totalPrice = totalPrice*[model.recipe_no  integerValue];
            
            CGFloat totalPrice1 = 0;
            NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
            formatter1.numberStyle = NSNumberFormatterDecimalStyle;
            formatter1.maximumFractionDigits = 2;
            formatter1.minimumFractionDigits = 2;
            formatter1.usesGroupingSeparator = NO; // 禁止千位分隔符
            for (ExcipientItemModel *subModel in model.excipentArr) {
                CGFloat value = subModel.num * [subModel.price floatValue];
                CGFloat roundedValue = round(value * 100) / 100.0;
                totalPrice1 += roundedValue;
            }
            
            CGFloat fee = 0;
            if([model.delivery_mode integerValue] == 1 || totalPrice>150) {
                fee = 0;
            }else {
                fee = 10;
            }
            
            CGFloat finalPrice = totalPrice + totalPrice1 + fee + [model.cost floatValue];
            
            self.valueLab.text = [NSString stringWithFormat:@"%.2f",finalPrice];
            model.recipe_sale_price = self.valueLab.text;
        }
    }
    
}


- (void)setMyModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        self.valueLab.text = [NSString stringWithFormat:@"%.0ld", model.drugArr.count];
    }else if(indexPath.row == 1) {
        if(model.drugArr.count == 0) {
            self.valueLab.text = @"";
            return;
        }
        /// 颗粒总价
        CGFloat totalPrice = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 4; // 设置最多四位小数
        formatter.minimumFractionDigits = 4; // 设置最少四位小数
        formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
        for (DrugItemModel *drugModel in model.drugArr) {
            CGFloat value = drugModel.num * [drugModel.sell_price floatValue];
            CGFloat roundedValue = round(value * 10000) / 10000.0;
            totalPrice += roundedValue;
        }
        model.sell_price = [formatter stringFromNumber:@(totalPrice)]; ///单副
        totalPrice = totalPrice*[model.recipe_no  integerValue];
        self.valueLab.text = [formatter stringFromNumber:@(totalPrice)];

        model.sell_price_total = self.valueLab.text;
        
    }else {
        if(model.drugArr.count == 0) {
            self.valueLab.text = @"";
            return;
        }
        /// 实收金额
        CGFloat totalPrice = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 4; // 设置最多四位小数
        formatter.minimumFractionDigits = 4; // 设置最少四位小数
        formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
        for (DrugItemModel *drugModel in model.drugArr) {
            CGFloat value = drugModel.num * [drugModel.sell_price floatValue];
            CGFloat roundedValue = round(value * 10000) / 10000.0;
            totalPrice += roundedValue;
        }
        totalPrice = totalPrice*[model.recipe_no  integerValue];
        
      
        CGFloat fee = 0;
       
        CGFloat finalPrice = totalPrice  + fee;
        
        
        self.valueLab.text = [NSString stringWithFormat:@"%.2f",finalPrice];
        model.recipe_sale_price = self.valueLab.text;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
