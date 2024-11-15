//
//  PatientTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/19.
//

#import "PatientTableViewCell.h"
@interface PatientTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *thridLeftLab;
@property (weak, nonatomic) IBOutlet UILabel *forthLeftLab;


@end

@implementation PatientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"PatientTableViewCellFristId";
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"PatientTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 1;
        identifier = @"PatientTableViewCellSecondId";
    }else if(indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5) {
        selectTag = 2;
        identifier = @"PatientTableViewCellThridId";
    }else if(indexPath.row == 3 || indexPath.row == 6) {
        selectTag = 3;
        identifier = @"PatientTableViewCellForthId";
    }else {
        selectTag = 4;
        identifier = @"PatientTableViewCellFifthId";
    }
    PatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PatientTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    
    [[cell rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if([textView.text isEqualToString:@"请输入地址"]) {
            textView.text = @"";
            textView.textColor = COLOR_333333;
        }
    }];
    
    if(indexPath.row == 2) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"*患者姓名："];
        [attri addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        cell.thridLeftLab.attributedText = attri;
        cell.textF.placeholder = @"请输入姓名";
        cell.textF.keyboardType = UIKeyboardTypeDefault;
    }else if(indexPath.row == 4) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"*患者年龄："];
        [attri addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        cell.thridLeftLab.attributedText = attri;
        cell.textF.placeholder = @"请输入年龄";
        cell.textF.keyboardType = UIKeyboardTypeNumberPad;
    }else if(indexPath.row == 5) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"*手机："];
        [attri addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        cell.thridLeftLab.attributedText = attri;
        cell.textF.placeholder = @"请输入手机号";
        cell.textF.keyboardType = UIKeyboardTypePhonePad;
        
    }else if(indexPath.row == 3) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"*患者性别："];
        [attri addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        cell.forthLeftLab.attributedText = attri;
        [cell.leftBtn setTitle:@" 男" forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@" 女" forState:UIControlStateNormal];
        [cell.leftBtn setTitle:@" 男" forState:UIControlStateSelected];
        [cell.rightBtn setTitle:@" 女" forState:UIControlStateSelected];
    }else if(indexPath.row == 6) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"*配送方式："];
        [attri addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, 1)];
        cell.forthLeftLab.attributedText = attri;
        [cell.leftBtn setTitle:@" 邮寄" forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@" 自提" forState:UIControlStateNormal];
        [cell.leftBtn setTitle:@" 邮寄" forState:UIControlStateSelected];
        [cell.rightBtn setTitle:@" 自提" forState:UIControlStateSelected];
    }
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 65;
    }else if(indexPath.row == 7) {
        return 155;
    }else {
        return 55;
    }
}

- (void)setRegionItemModel:(RecipeModel *)regionItemModel indexPathWith:(NSIndexPath *)indexPath {
    _regionItemModel = regionItemModel;
    if(regionItemModel.province.length>0) {
        [self.chooseAreaBtn setTitle:[NSString stringWithFormat:@"%@%@%@", regionItemModel.province, regionItemModel.city, regionItemModel.area] forState:UIControlStateNormal];
        [self.chooseAreaBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    }else {
        [self.chooseAreaBtn setTitle:@"请选择省市区" forState:UIControlStateNormal];
        [self.chooseAreaBtn setTitleColor:COLOR_D0D0D1 forState:UIControlStateNormal];
    }
    self.textView.text = regionItemModel.address;
    if([regionItemModel.address isEqualToString:@"请输入地址"]) {
        self.textView.textColor =  COLOR_CDCDCF;
    }else {
        self.textView.textColor = COLOR_333333;
    }
    
    if([regionItemModel.delivery_mode integerValue] == 1) {
        self.chooseAreaBtn.enabled = NO;
        self.textView.userInteractionEnabled = NO;
    }else {
        self.chooseAreaBtn.enabled = YES;
        self.textView.userInteractionEnabled = YES;
    }
    if(indexPath.row == 2) {
        self.textF.text = regionItemModel.name;
    }else if(indexPath.row == 4) {
        self.textF.text = regionItemModel.age;
    }else if(indexPath.row == 5) {
        self.textF.text = regionItemModel.phone;
    }
    
    if(indexPath.row == 3) {
        if([regionItemModel.sex isEqualToString:@"女"]) {
            self.rightBtn.selected = YES;
            self.leftBtn.selected = NO;
        }else {
            self.rightBtn.selected = NO;
            self.leftBtn.selected = YES;
        }
    }else if(indexPath.row == 6) {
        if([regionItemModel.delivery_mode integerValue] == 1) { /// 自提
            self.rightBtn.selected = YES;
            self.leftBtn.selected = NO;
        }else {
            self.rightBtn.selected = NO;
            self.leftBtn.selected = YES;
        }
    }
    
}

- (void)setRegionItemModel:(RecipeModel *)regionItemModel {
    _regionItemModel = regionItemModel;
    if(regionItemModel.province.length>0) {
        [self.chooseAreaBtn setTitle:[NSString stringWithFormat:@"%@%@%@", regionItemModel.province, regionItemModel.city, regionItemModel.area] forState:UIControlStateNormal];
        [self.chooseAreaBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
    }else {
        [self.chooseAreaBtn setTitle:@"请选择省市区" forState:UIControlStateNormal];
        [self.chooseAreaBtn setTitleColor:COLOR_D0D0D1 forState:UIControlStateNormal];
    }
    self.textView.text = regionItemModel.address;
    if([regionItemModel.address isEqualToString:@"请输入地址"]) {
        self.textView.textColor =  COLOR_CDCDCF;
    }else {
        self.textView.textColor = COLOR_333333;
    }
    
    if([regionItemModel.delivery_mode integerValue] == 1) {
        self.chooseAreaBtn.enabled = NO;
        self.textView.userInteractionEnabled = NO;
    }else {
        self.chooseAreaBtn.enabled = YES;
        self.textView.userInteractionEnabled = YES;
    }
    
    
    
}


- (void)setMyRegionItemModel:(RecipeModel *)regionItemModel indexPathWith:(NSIndexPath *)indexPath {
    _regionItemModel = regionItemModel;

    self.textView.text = regionItemModel.address;
    if([regionItemModel.address isEqualToString:@"请输入地址"]) {
        self.textView.textColor =  COLOR_CDCDCF;
    }else {
        self.textView.textColor = COLOR_333333;
    }
    

    if(indexPath.row == 2) {
        self.textF.text = regionItemModel.name;
    }else if(indexPath.row == 4) {
        self.textF.text = regionItemModel.age;
    }else if(indexPath.row == 5) {
        self.textF.text = regionItemModel.phone;
    }
    
    if(indexPath.row == 3) {
        if([regionItemModel.sex isEqualToString:@"女"]) {
            self.rightBtn.selected = YES;
            self.leftBtn.selected = NO;
        }else {
            self.rightBtn.selected = NO;
            self.leftBtn.selected = YES;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
