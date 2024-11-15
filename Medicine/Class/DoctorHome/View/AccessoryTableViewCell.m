//
//  AccessoryTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/25.
//

#import "AccessoryTableViewCell.h"

@interface AccessoryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *drugname;


@end

@implementation AccessoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numtextF addTopBorderWithColor:COLOR_E2C8A9 width:1];
    [self.numtextF addBottomBorderWithColor:COLOR_E2C8A9 width:1];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath dataArrayWith:(NSArray *)excipentArr {
    
    NSInteger selectTag = 0;
    NSString *identifier = @"";
    
    if(excipentArr.count == 0) {
        if(indexPath.row == 0) {
            selectTag = 2;
            identifier = @"AccessoryTableViewCellThridId";
        }else {
            selectTag = 1;
            identifier = @"AccessoryTableViewCellSecondId";
        }
    }else {
        if(indexPath.row == excipentArr.count) {
            selectTag = 1;
            identifier = @"AccessoryTableViewCellSecondId";
        }else {
            selectTag = 0;
            identifier = @"AccessoryTableViewCellFristId";
        }
    }
    
    AccessoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AccessoryTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath dataArrayWith:(NSArray *)excipentArr {
    if(excipentArr.count == 0) {
        if(indexPath.row == 0) {
            return 115;
        }else {
            return 65;
        }
    }else {
        if(indexPath.row == excipentArr.count) {
            return 65;
        }else {
            return 45;
        }
    }
}


- (void)setModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath {
    /// 单幅颗粒总剂量
    CGFloat totalKeliNum = 0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 4; // 设置最多四位小数
    formatter.minimumFractionDigits = 4; // 设置最少四位小数

    for (DrugItemModel *drugModel in model.drugArr) {
        drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
        CGFloat value = [drugModel.herb_dose floatValue] / [drugModel.useful_value floatValue];
        // 格式化结果为四位小数
        NSString *formattedValueString = [formatter stringFromNumber:@(value)];
        CGFloat formattedValue = [formattedValueString floatValue];
        // 将格式化后的值累加到 totalKeliNum
        totalKeliNum += formattedValue;
    }
//    辅料总量
    CGFloat totalFlNum =  round(totalKeliNum * [model.excipient_proportion floatValue]) * [model.recipe_no integerValue];
    model.excipentTotal = [NSString stringWithFormat:@"%.0f",totalFlNum];
    
    
    if(model.excipentArr.count == 1 && indexPath.row == 0) {
        ExcipientItemModel *subModel = model.excipentArr[indexPath.row];
        self.drugname.text = subModel.name;
        if(!model.isCustom) {
            subModel.num = [model.excipentTotal integerValue];
        }
        self.numtextF.text =  [NSString stringWithFormat:@"%ld", (long)subModel.num];
        NSLog(@"xxxxxxxxx %ld",subModel.num);
    }else if(model.excipentArr.count > 1) {
        ExcipientItemModel *subModel = model.excipentArr[indexPath.row];
        self.drugname.text = subModel.name;
        
        NSLog(@"aaaaaaaaaa %@",model.excipentTotal);
        if(!model.isCustom) { /// 初始化
            if(indexPath.row == 0) {
                subModel.num = ceil([model.excipentTotal integerValue]/2.0)  ;
            }else {
                subModel.num = [model.excipentTotal integerValue]- ceil([model.excipentTotal integerValue]/2.0);
            }
        }
        self.numtextF.text = [NSString stringWithFormat:@"%ld", (long)subModel.num];
        NSLog(@"sd2222sd %ld",subModel.num);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
