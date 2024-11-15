//
//  DoctorWelcomeCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/18.
//

#import "DoctorWelcomeCell.h"

@interface DoctorWelcomeCell()
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLab;

@end

@implementation DoctorWelcomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    DoctorWelcomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorWelcomeCellId"];
    if(!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DoctorWelcomeCell" owner:self options:nil].lastObject;
    }
    cell.topLab.text = [NSString stringWithFormat:@"欢迎您，%@【%@】",[MedicineManager sharedInfo].doctorModel.doctorname, [MedicineManager sharedInfo].doctorModel.loginname];
    cell.hospitalLab.text = [MedicineManager sharedInfo].hospitalModel.hospitalname;
    return cell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
