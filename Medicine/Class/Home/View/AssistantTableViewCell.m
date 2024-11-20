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
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowImgWidth;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRightImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UILabel *roleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabWdith;

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
    
    [[cell rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if([textView.text isEqualToString:@"请输入详细地址"]) {
            textView.text = @"";
            textView.textColor = COLOR_562306;
        }
    }];
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model{
    if(indexPath.row == 0) {
        if([model.status integerValue] == 30) {
            return [ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height>16?90+[ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height:90;
        }
        return 90;
    }else {
        return  [ClassMethod sizeText:model.addressDetail font:[UIFont systemFontOfSize:14] limitWidth:WIDE - 130].height >28? [ClassMethod sizeText:model.addressDetail font:[UIFont systemFontOfSize:14] limitWidth:WIDE - 130].height + 557 : 585 ;
    }
}

- (void)setModel:(PromoteUserModel *)model {
    _model = model;
    if([model.status integerValue] == 30) {
        self.statusImgView.image = [UIImage imageNamed:@"close-circle-filled"];
        self.statusLab.text = @"已拒绝";
        self.detailLab.text = model.reviewRemark;
        
    }
    if([model.status integerValue] != 10 || [model.reviewable boolValue] == NO) {
        self.arrowRightImgView.hidden = YES;
        self.arrowImgWidth.constant = 0;
        self.arrowRightWidth.constant = 0;
    }else {
        self.arrowRightImgView.hidden = NO;
        self.arrowImgWidth.constant = 20;
        self.arrowRightWidth.constant = 20;
    }
    
    self.nameLab.text = model.name;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.sexLab.text = [model.sex integerValue] == 0?@"男":@"女";
    self.phoneLab.text = model.phonenumber;
    self.idcardLab.text = model.idcard;
    [self.idcardImgView1 sd_setImageWithURL:[NSURL URLWithString:model.idcardImageModel1.url]];
    [self.idcardImgView2 sd_setImageWithURL:[NSURL URLWithString:model.idcardImageModel2.url]];
    self.parenLab.text = model.nickName;
  
    self.roleLab.hidden = NO;
    self.roleLabWdith.constant = 35;
    if([model.parentAgentLevel integerValue] == 1) {
        /// 合伙人
        self.roleLab.text = @"服务商";
    }else if([model.parentAgentLevel integerValue] == 2) {
        /// 地级医助
        self.roleLab.text = @"地级";
    }else if([model.parentAgentLevel integerValue] == 3) {
        /// 县级医助
        self.roleLab.text = @"县级";
    }else {
        self.roleLab.hidden = YES;
        self.roleLabWdith.constant = 0;
    }
    
    if(model.manageAreaNames.length>0) {
        [self.chosseAreaBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
        [self.chosseAreaBtn setTitle:model.manageAreaNames forState:UIControlStateNormal];
    }else {
        if([model.status integerValue] == 10 && [model.reviewable boolValue] == YES) {
            [self.chosseAreaBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.chosseAreaBtn setTitle:@"请选择所属地区" forState:UIControlStateNormal];
        }else {
            [self.chosseAreaBtn setTitle:@"" forState:UIControlStateNormal];
        }
        
    }
    
    if([[MedicineManager sharedInfo].customModel.userType integerValue] == 50 && [model.status integerValue] == 10 && [model.reviewable boolValue] == YES) {
        self.chooseLevelBtn.hidden = NO;
        if(model.agentLevel.length>0) {
            [self.chooseLevelBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
            [self.chooseLevelBtn setTitle:model.agentLevelName forState:UIControlStateNormal];
        }else {
            [self.chooseLevelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.chooseLevelBtn setTitle:@"请选择医助等级" forState:UIControlStateNormal];
        }
    }else {
        self.chooseLevelBtn.hidden = YES;
        if([model.agentLevel integerValue] == 1) {
            /// 合伙人
            self.arrowImgView.image = [UIImage imageNamed:@"partner_tag"];
        }else if([model.agentLevel integerValue] == 2) {
            /// 地级医助
            self.arrowImgView.image = [UIImage imageNamed:@"prefecture_tag"];
        }else if([model.agentLevel integerValue] == 3) {
            /// 县级医助
            self.arrowImgView.image = [UIImage imageNamed:@"country_tag"];
        }
        self.arrowImgWidth.constant = 35;
    }
    

    if([model.status integerValue] == 10 && [model.reviewable boolValue] == YES) {
        self.addressTextView.userInteractionEnabled = YES;
       
    }else {
        self.addressTextView.userInteractionEnabled = NO;
    }
    
    self.addressTextView.text = model.addressDetail;
    if(model.addressDetail.length>0) {
        self.addressTextView.textColor = COLOR_562306;
    }
    
    self.bottomHeight.constant = [ClassMethod sizeText:model.addressDetail font:[UIFont systemFontOfSize:14] limitWidth:WIDE - 130].height >28? [ClassMethod sizeText:model.addressDetail font:[UIFont systemFontOfSize:14] limitWidth:WIDE - 130].height + 10 : 38;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
