//
//  MedchineTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/25.
//

#import "MedchineTableViewCell.h"

@interface MedchineTableViewCell ()
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

@end

@implementation MedchineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numtextF addTopBorderWithColor:COLOR_E2C8A9 width:1];
    [self.numtextF addBottomBorderWithColor:COLOR_E2C8A9 width:1];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath dataArrayWith:(NSArray *)drugArr{
    
    NSInteger selectTag = 0;
    NSString *identifier = @"";
    
    if(drugArr.count == 0) {
        if(indexPath.row == 0) {
            selectTag = 2;
            identifier = @"MedchineTableViewCellThridId";
        }else {
            selectTag = 1;
            identifier = @"MedchineTableViewCellSecondId";
        }
    }else {
        if(indexPath.row == drugArr.count) {
            selectTag = 1;
            identifier = @"MedchineTableViewCellSecondId";
        }else {
            selectTag = 0;
            identifier = @"MedchineTableViewCellFristId";
        }
    }
    
    
    MedchineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MedchineTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath dataArrayWith:(nonnull NSArray *)drugArr {
    if(drugArr.count == 0) {
        if(indexPath.row == 0) {
            return 115;
        }else {
            return 65;
        }
    }else {
        if(indexPath.row == drugArr.count) {
            return 65;
        }else {
            DrugItemModel *model = drugArr[indexPath.row];
            CGFloat height = model.isExpand? 100 : 45;
            if([ClassMethod sizeText:model.drugname font:[UIFont systemFontOfSize:15] limitWidth:WIDE - 239].height > 30) {
                height = height - 30 + [ClassMethod sizeText:model.drugname font:[UIFont systemFontOfSize:15] limitWidth:WIDE - 239].height;
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
    self.keliLab.text = [NSString stringWithFormat:@"%.3f",model.num/[model.useful_value floatValue]];
    self.salePriceLab.text = [NSString stringWithFormat:@"%.4f", model.num * [model.sell_price floatValue]];
    if(model.num == 0) {
        self.numtextF.text = @"0";
    }else {
        self.numtextF.text = [NSString stringWithFormat:@"%.ld", model.num];
    }
    
    if(model.isExpand) {
        self.viewHeight.constant = 55;
        self.subView.hidden = NO;
    }else {
        self.viewHeight.constant = 0;
        self.subView.hidden = YES;
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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
