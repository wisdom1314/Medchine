//
//  MemberInfoTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/12.
//

#import "MemberInfoTableViewCell.h"
@interface MemberInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *roleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *contactParentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *proleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proleWidth;

@end

@implementation MemberInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    MemberInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberInfoTableViewCellId"];
    if(!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MemberInfoTableViewCell" owner:self options:nil].lastObject;
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(PromoteUserBaseModel *)model {
    if([model.status integerValue] ==30 || [model.status integerValue] == 90 || [model.status integerValue] == 11) {
        return 170;
    }
    return 195;
    
}

- (void)setModel:(PromoteUserBaseModel *)model {
    _model = model;
    if(model.isHos) {
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:model.managerAvatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.userNameLab.text = model.managerName;
        self.timeLab.text = [NSString stringWithFormat:@"注册时间：%@", model.addtime];
        self.areaLab.text = [NSString stringWithFormat:@"所属地区：%@,%@,%@", model.province, model.city, model.area];
    }else {
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.userNameLab.text = model.nickName;
        self.timeLab.text = [NSString stringWithFormat:@"注册时间：%@", model.createTime];
        self.areaLab.text = [NSString stringWithFormat:@"所属地区：%@", model.manageAreaNames];
    }
   
    self.phoneLab.text = model.phonenumber;
    self.contactParentLab.text= [NSString stringWithFormat:@"关联上级：%@", model.promoteUser.nickName];
   
    
    if([model.status integerValue] ==10) {
        
        self.statusLab.text = model.isHos?@"待初审": @"待审核";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#FF784D"];
        self.rightBtn.hidden = NO;
        if(model.isHos) {
            [self.rightBtn setTitle:@"审核" forState:UIControlStateNormal];
        }
    }else if([model.status integerValue] ==11) {
        self.statusLab.text = @"待复核";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#FF784D"];
        self.rightBtn.hidden = YES;
    } else if([model.status integerValue] ==20) {
        self.statusLab.text = @"已通过";
        self.statusLab.textColor = COLOR_B72E26;
        self.rightBtn.hidden = NO;
        if(model.isHos) {
            [self.rightBtn setTitle:@"处方订单" forState:UIControlStateNormal];
        }
    }else if([model.status integerValue] ==30) {
        self.statusLab.text = @"已拒绝";
        self.statusLab.textColor = COLOR_333333;
        self.rightBtn.hidden = YES;
    }else {
        self.statusLab.text = @"已禁用";
        self.statusLab.textColor = COLOR_333333;
        self.rightBtn.hidden = YES;
    }
    if(model.agentLevel.length == 0) {
        self.roleLab.hidden = YES;
    }else {
        self.roleLab.hidden = NO;
        if([model.agentLevel integerValue] == 1) {
            self.roleLab.text = @"服务商";
            self.roleWidth.constant = 38;
        }else if([model.agentLevel integerValue] == 2) {
            self.roleLab.text = @"地级";
            self.roleWidth.constant = 28;
        }else if([model.agentLevel integerValue] == 3) {
            self.roleLab.text = @"县级";
            self.roleWidth.constant = 28;
        }
    }
    if(model.promoteUser.agentLevel.length == 0) {
        self.proleLab.hidden = YES;
    }else {
        self.proleLab.hidden = NO;
        if([model.promoteUser.agentLevel integerValue] == 1) {
            self.proleLab.text = @"服务商";
            self.proleWidth.constant = 38;
        }else if([model.promoteUser.agentLevel integerValue] == 2) {
            self.proleLab.text = @"地级";
            self.proleWidth.constant = 28;
        }else if([model.promoteUser.agentLevel integerValue] == 3) {
            self.proleLab.text = @"县级";
            self.proleWidth.constant = 28;
        }
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
