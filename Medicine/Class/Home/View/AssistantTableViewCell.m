//
//  AssistantTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/13.
//

#import "AssistantTableViewCell.h"
@interface AssistantTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *idcardLab;
@property (weak, nonatomic) IBOutlet UIImageView *idcardImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *idcardImgView2;
@property (weak, nonatomic) IBOutlet UILabel *parenLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowImgWidth;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRightImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth;
@end

@implementation AssistantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"AssistantTableViewCellFristId";
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"AssistantTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 1;
        identifier = @"AssistantTableViewCellSecondId";
    }
    AssistantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AssistantTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model{
    if(indexPath.row == 0) {
        if([model.status integerValue] == 30) {
            return [ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height>16?90+[ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height:90;
        }
        return 90;
    }else {
        return 585;
    }
}

- (void)setModel:(PromoteUserModel *)model {
    _model = model;
    if([model.status integerValue] == 30) {
        self.statusImgView.image = [UIImage imageNamed:@"close-circle-filled"];
        self.statusLab.text = @"已拒绝";
        self.detailLab.text = model.reviewRemark;
        self.arrowRightImgView.hidden = YES;
        self.arrowImgView.hidden = YES;
        self.arrowImgWidth.constant = 0;
        self.arrowRightWidth.constant = 0;
    }
    self.nameLab.text = model.name;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.sexLab.text = [model.sex integerValue] == 0?@"男":@"女";
    self.phoneLab.text = model.phonenumber;
    self.idcardLab.text = model.idcard;
    [self.idcardImgView1 sd_setImageWithURL:[NSURL URLWithString:model.idcardImageModel1.url]];
    [self.idcardImgView2 sd_setImageWithURL:[NSURL URLWithString:model.idcardImageModel2.url]];
    self.parenLab.text = model.nickName;
    
    if(model.manageAreaNames.length>0) {
        [self.chosseAreaBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
        [self.chosseAreaBtn setTitle:model.manageAreaNames forState:UIControlStateNormal];
    }else {
        if([model.status integerValue] == 30) {
            [self.chosseAreaBtn setTitle:@"" forState:UIControlStateNormal];
        }else {
            [self.chosseAreaBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.chosseAreaBtn setTitle:@"请选择所属地区" forState:UIControlStateNormal];
        }
        
    }
    
    if(model.agentLevel.length>0) {
        [self.chooseLevelBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
        [self.chooseLevelBtn setTitle:model.agentLevelName forState:UIControlStateNormal];
        
    }else {
        if([model.status integerValue] == 30) {
            [self.chooseLevelBtn setTitle:@"" forState:UIControlStateNormal];
        }else {
            [self.chooseLevelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [self.chooseLevelBtn setTitle:@"请选择医助等级" forState:UIControlStateNormal];
        }
        
    }
    
    self.addressLab.text = model.addressDetail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
