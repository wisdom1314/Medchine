//
//  AssistantHeaderView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/14.
//

#import "AssistantHeaderView.h"

@interface AssistantHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *roleImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

@implementation AssistantHeaderView

- (void)setModel:(PromoteUserModel *)model {
    _model = model;
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.userNameLab.text = model.name;
    self.addressLab.text = [NSString stringWithFormat:@"所属地区：%@", model.manageAreaNames];
    self.phoneLab.text = model.phonenumber;
    if([model.agentLevel integerValue] == 1) {
        /// 合伙人
        self.roleImgView.image = [UIImage imageNamed:@"partner_tag"];
    }else if([model.agentLevel integerValue] == 2) {
        /// 地级医助
        self.roleImgView.image = [UIImage imageNamed:@"prefecture_tag"];
    }else if([model.agentLevel integerValue] == 3) {
        /// 县级医助
        self.roleImgView.image = [UIImage imageNamed:@"country_tag"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
