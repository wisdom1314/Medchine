//
//  MedchineReduceTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/5.
//

#import "MedchineReduceTableViewCell.h"

@interface MedchineReduceTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *drugname;
@property (weak, nonatomic) IBOutlet UILabel *usefulLab;
@property (weak, nonatomic) IBOutlet UILabel *keliLab;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomView;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLab;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLab;
@property (weak, nonatomic) IBOutlet UILabel *rigntTopLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actualHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sercetViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *secrectDrugNameLab;
@property (weak, nonatomic) IBOutlet UILabel *secrectPriceLab;
@property (weak, nonatomic) IBOutlet UIView *secrectSubView;



@end

@implementation MedchineReduceTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numtextF addTopBorderWithColor:COLOR_E2C8A9 width:1];
    [self.numtextF addBottomBorderWithColor:COLOR_E2C8A9 width:1];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath modelWith:(RecipeModel *)model{
    
    NSInteger selectTag = 0;
    NSString *identifier = @"";
    
    if(model.drugArr.count == 0) {
        if(indexPath.row == 0) {
            selectTag = 2;
            identifier = @"MedchineReduceTableViewCellThridId";
        }else {
            selectTag = 1;
            identifier = @"MedchineReduceTableViewCellSecondId";
        }
    }else {
        if(indexPath.row == model.drugArr.count) {
            selectTag = 1;
            identifier = @"MedchineReduceTableViewCellSecondId";
        }else {
            if([model.is_secret integerValue] == 1) {
                selectTag = 3;
                identifier = @"MedchineReduceTableViewCellLastId";
            }else {
                selectTag = 0;
                identifier = @"MedchineReduceTableViewCellFristId";
            }
            
        }
    }
    
    
    MedchineReduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MedchineReduceTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(RecipeModel *)model {
    if(model.drugArr.count == 0) {
        if(indexPath.row == 0) {
            return 115;
        }else {
            return 65;
        }
    }else {
        if(indexPath.row == model.drugArr.count) {
            return 65;
        }else {
            DrugItemModel *subModel = model.drugArr[indexPath.row];
            CGFloat height = 0;
            if(subModel.isExpand) {
                height = [model.is_secret integerValue] ==1 ?75: 100;
            }else {
                height =  45;
            }
            
            if([model.is_secret integerValue] != 1) {
                height = [subModel.need_factor integerValue] == 1? height+20: height;
            }
            if([ClassMethod sizeText:subModel.drugname font:[UIFont systemFontOfSize:15] limitWidth:WIDE - 239].height > 30) {
                height = height - 30 + [ClassMethod sizeText:subModel.drugname font:[UIFont systemFontOfSize:15] limitWidth:WIDE - 239].height;
            }
            return height;
        }
    }
}


+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(RecipeModel *)model isDetail:(BOOL)isDetail {
    if(model.drugArr.count == 0) {
        if(indexPath.row == 0) {
            return 115;
        }else {
            return 65;
        }
    }else {
        if(indexPath.row == model.drugArr.count) {
            return 65;
        }else {
            DrugItemModel *subModel = model.drugArr[indexPath.row];
            CGFloat height = 0;
            if(subModel.isExpand) {
                height = [model.is_secret integerValue] ==1 ?75: 100;
            }else {
                height =  45;
            }
            
            if([model.is_secret integerValue] != 1) {
                height = ([subModel.need_factor integerValue] == 1 && !isDetail)? height+20: height;
            }
           
            return height;
        }
    }
}

- (void)setModel:(DrugItemModel *)model {
    _model = model;
    self.drugname.text = model.drugname;
    self.usefulLab.text = model.useful_value; /// 剂量
    self.pricelab.text = model.sell_price; /// 单价
    self.expandBtn.selected = model.isExpand;
  
    self.secrectDrugNameLab.text = model.drugname;
    self.secrectPriceLab.text = model.sell_price;
   
    if(model.num == 0) {
        self.numtextF.text = @"0";
    }else {
        self.numtextF.text = [NSString stringWithFormat:@"%.ld", model.num];
    }
    
    if(model.isExpand) {
        self.viewHeight.constant = 55;
        self.subView.hidden = NO;
        self.sercetViewHeight.constant = 25;
        self.secrectSubView.hidden = NO;
        self.expandBtn.selected = YES;
        self.secrectExpandBtn.selected = YES;
    }else {
        self.viewHeight.constant = 0;
        self.subView.hidden = YES;
        self.sercetViewHeight.constant = 0;
        self.secrectSubView.hidden = YES;
        self.expandBtn.selected = NO;
        self.secrectExpandBtn.selected = NO;
    }
    
    if([model.need_factor integerValue] == 0) {
        self.actualLab.hidden = YES;
        self.orginalLab.hidden = YES;
        self.actualHeight.constant = 0;
        model.herb_dose = [NSString stringWithFormat:@"%ld", model.num];
        self.keliLab.text = [NSString stringWithFormat:@"%.4f",model.num/[model.useful_value floatValue]];
        self.salePriceLab.text = [NSString stringWithFormat:@"%.4f", model.num * [model.sell_price floatValue]];
    }else {
        self.actualLab.hidden = NO;
        self.orginalLab.hidden = NO;
        self.actualHeight.constant = 20;
        model.herb_dose = [ClassMethod formatNumberWithCustomRounding:model.num*[model.herb_factor floatValue]];
        self.keliLab.text = [NSString stringWithFormat:@"%.4f", [model.herb_dose floatValue]/[model.useful_value floatValue]];
        self.salePriceLab.text = [NSString stringWithFormat:@"%.4f",[model.herb_dose floatValue] * [model.sell_price floatValue]];
        self.actualLab.text = [NSString stringWithFormat:@"现 %@g", model.herb_dose];
    }

   
}


- (void)setMyModel:(DrugItemModel *)myModel {
    _myModel = myModel;
    self.leftTopLab.text = @"每袋相当于饮片：";
    self.rigntTopLab.text = @"袋装单价：";
    self.leftBottomLab.text = @"总价：";
    self.rightBottomView.hidden = YES;
    self.drugname.text = myModel.drugname;
    self.usefulLab.text = [NSString stringWithFormat:@"%@g", myModel.equivalent];

    self.pricelab.text = [NSString stringWithFormat:@"%.3f元",[myModel.sell_price floatValue]*myModel.num];
    self.expandBtn.selected = myModel.isExpand;
    
    self.keliLab.text = [NSString stringWithFormat:@"%@元/袋",myModel.sell_price];
   
    if(myModel.num == 0) {
        self.numtextF.text = @"0";
    }else {
        self.numtextF.text = [NSString stringWithFormat:@"%.ld", myModel.num];
    }
    
    if(myModel.isExpand) {
        self.viewHeight.constant = 55;
        self.subView.hidden = NO;
    }else {
        self.viewHeight.constant = 0;
        self.subView.hidden = YES;
    }
    
    self.unitLab.text = @"袋";
    
    self.actualLab.hidden = YES;
    self.orginalLab.hidden = YES;
    self.actualHeight.constant = 0;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
