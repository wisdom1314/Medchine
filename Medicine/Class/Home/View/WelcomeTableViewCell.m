//
//  WelcomeTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import "WelcomeTableViewCell.h"
#import "SGCreateCode.h"

@interface WelcomeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;

@end

@implementation WelcomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
    self.nameLab.text = [NSString stringWithFormat:@"欢迎您，%@",[MedicineManager sharedInfo].customModel.nickName];
    self.jobLab.text = [[MedicineManager sharedInfo].customModel.userType integerValue] == 11 ?@"机构员工": [[MedicineManager sharedInfo].customModel.userType integerValue] == 50?@"营销经理": @"医助";
    
   
//    [self.recommandBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    WelcomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WelcomeTableViewCellId"];
    if(!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WelcomeTableViewCell" owner:self options:nil].lastObject;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
