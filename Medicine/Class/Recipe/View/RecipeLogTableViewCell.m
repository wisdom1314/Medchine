//
//  RecipeLogTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "RecipeLogTableViewCell.h"

@interface RecipeLogTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headWidth;

@end

@implementation RecipeLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    
    RecipeLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeLogTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeLogTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(ExpressItemModel *)model {
    return 60 + [ClassMethod sizeText:model.context font:[UIFont systemFontOfSize:12] limitWidth:WIDE - 53].height;
}

+ (CGFloat)getCellHeightWithModel:(RecipeLogItemModel *)model {
    return 60 + [ClassMethod sizeText:model.remark font:[UIFont systemFontOfSize:12] limitWidth:WIDE - 133].height;
}

- (void)setModel:(RecipeLogItemModel *)model {
    _model = model;
    self.headLab.hidden = NO;
    self.headWidth.constant = 80;
    self.headLab.text = model.action;
    self.timeLab.text = model.operatorTime;
    self.detailLab.text = model.remark;
    if(model.isLast) {
        self.line.hidden = YES;
    }else {
        self.line.hidden = NO;
    }
}

- (void)setExpressModel:(ExpressItemModel *)expressModel {
    _expressModel = expressModel;
    self.headLab.hidden = YES;
    self.headWidth.constant = 0;
    self.timeLab.text = expressModel.time;
    self.detailLab.text = expressModel.context;
    if(expressModel.isLast) {
        self.line.hidden = YES;
    }else {
        self.line.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
