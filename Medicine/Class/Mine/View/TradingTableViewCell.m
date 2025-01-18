//
//  TradingTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/27.
//

#import "TradingTableViewCell.h"

@interface TradingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *categorylab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreHeight;
@property (weak, nonatomic) IBOutlet UILabel *moreLab;

@end

@implementation TradingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    
    TradingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradingTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TradingTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(TransLogModel *)logModel {
    //    if(logModel.remark.length == 0 || !logModel.isExpand) {
    //        return 88;
    //    }else {
    //        return 88 + [ClassMethod sizeText:logModel.remark font:[UIFont systemFontOfSize:10] limitWidth:WIDE-33].height + 20;
    //    }
    
    if(logModel.remark.length == 0 ) {
        return 88;
    }else {
        return 88 + [ClassMethod sizeText:logModel.remark font:[UIFont systemFontOfSize:10] limitWidth:WIDE-33].height + 20;
    }
    
}

- (void)setModel:(TransLogModel *)model {
    _model = model;
    
    
    if([model.type integerValue] == 0) { /// 充值
        if([model.channel isEqualToString:@"ALIPAY_APP"] || [model.channel isEqualToString:@"ALIPAY"]) {
            self.headImgView.image = [UIImage imageNamed:@"alipay"];
            self.categorylab.text = @"支付宝充值";
        }else if([model.channel isEqualToString:@"ADMIN"]) {
            self.headImgView.image = [UIImage imageNamed:@"recharge"];
            self.categorylab.text = @"后台充值";
        }else if([model.channel isEqualToString:@"WEPAY"] || [model.channel isEqualToString:@"WEPAY_APP"] || [model.channel isEqualToString:@"WEPAY_H5"]) {
            self.headImgView.image = [UIImage imageNamed:@"weixin"];
            self.categorylab.text = @"微信充值";
        }
        self.priceLab.text = [NSString stringWithFormat:@"+%@", model.pay];
        
    }else if( [model.type integerValue] == 1) { /// 缴费
        self.headImgView.image = [UIImage imageNamed:@"pay"];
        self.categorylab.text = @"处方缴费";
        self.priceLab.text = [NSString stringWithFormat:@"-%@", model.pay];
    }else if([model.type integerValue] == 2) { /// 退费
        self.headImgView.image = [UIImage imageNamed:@"reback"];
        self.categorylab.text = @"处方退费";
        self.priceLab.text = model.pay;
    }
    self.orderNoLab.text = model.paymentSn;
    self.timeLab.text = model.operatorTime;
    
    //    if(model.remark.length == 0 || !model.isExpand)
    if(model.remark.length == 0 ){
        self.moreView.hidden = YES;
        self.moreHeight.constant = 0;
    }else {
        self.moreView.hidden = NO;
        self.moreHeight.constant = [ClassMethod sizeText:self.model.remark font:[UIFont systemFontOfSize:10] limitWidth:WIDE-33].height + 20;
        
    }
    self.moreLab.text = self.model.remark;
    
    //    if(model.isExpand) {
    //        [self.expandBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    //    }else {
    //        [self.expandBtn setImage:[UIImage imageNamed:@"mine_arrow_right"] forState:UIControlStateNormal];
    //    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
