//
//  RecipeTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/19.
//

#import "RecipeTableViewCell.h"

@interface RecipeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *headLab;

@end

@implementation RecipeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.numTextF addTopBorderWithColor:COLOR_E2C8A9 width:1];
    [self.numTextF addBottomBorderWithColor:COLOR_E2C8A9 width:1];
    // Initialization code
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"RecipeTableViewCellFristId";
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"RecipeTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 1;
        identifier = @"RecipeTableViewCellSecondId";
    }else if(indexPath.row == 2) {
        selectTag = 4;
        identifier = @"RecipeTableViewCellSixthId";
    }else if(indexPath.row == 3 || indexPath.row == 4) {
        selectTag = 2;
        identifier = @"RecipeTableViewCellForthId";
    }else {
        selectTag = 3;
        identifier = @"RecipeTableViewCellFifthId";
    }
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    if(indexPath.row == 3 || indexPath.row == 4) {
        cell.headLab.text = indexPath.row == 3? @"每日服用次数" : @"药剂副数";
    }
    [[cell rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if(textView.tag == 0) {
            if([textView.text isEqualToString:@"请输入症状"]) {
                textView.text = @"";
                textView.textColor = COLOR_333333;
            }
        }else {
            if([textView.text isEqualToString:@"请输入"]) {
                textView.text = @"";
                textView.textColor = COLOR_333333;
            }
        }
        
    }];
    
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath columWith:(NSInteger)colum {
    if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
        return 55;
    }else if(indexPath.row == 1) {
        return 185;
    }else if(indexPath.row == 2) {
        if(colum > 0) {
            return colum * (ceil((WIDE - 50)/4.0)+ 10) + 10 + 45;
        }else {
            return ceil((WIDE - 50)/4.0)+ 20 + 45;
        }
    }else {
        return 160;
    }
}

- (void)setModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath{
    if([model.recipe_type integerValue] == 0) {
        self.rightBtn.selected = NO;
        self.leftBtn.selected = YES;
    }else {
        self.rightBtn.selected = YES;
        self.leftBtn.selected = NO;
    }
    if(model.symptoms.length > 0) {
        self.symptomTextView.text = model.symptoms;
        self.symptomTextView.textColor = COLOR_333333 ;
    }else {
        self.symptomTextView.text = @"请输入症状";
        self.symptomTextView.textColor = COLOR_CDCDCF;
    }
    
    if(model.attention.length > 0) {
        self.attentionTextView.text = model.attention;
        self.attentionTextView.textColor = COLOR_333333 ;
    }else {
        self.attentionTextView.text = @"请输入";
        self.attentionTextView.textColor = COLOR_CDCDCF;
    }
    
    if(indexPath.row == 3) {
        self.numTextF.text =  model.times_day;
    }else {
        self.numTextF.text = model.recipe_no;
    }
    
    self.addDoctorOrderBtn.selected = model.isCommon;
    
    self.imgTopLab.text = [NSString stringWithFormat:@"症状图片（%ld/8）", model.fileArr.count];
}



+ (instancetype)getAutoTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"RecipeTableViewCellFristId";
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"RecipeTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 5;
        identifier = @"RecipeTableViewCellLastId";
    }else if(indexPath.row == 2 || indexPath.row == 3) {
        selectTag = 2;
        identifier = @"RecipeTableViewCellForthId";
    }else {
        selectTag = 3;
        identifier = @"RecipeTableViewCellFifthId";
    }
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    if(indexPath.row == 2 || indexPath.row == 3) {
        cell.headLab.text = indexPath.row == 2? @"每日服用次数" : @"药剂副数";
    }
    [[cell rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if(textView.tag == 0) {
            if([textView.text isEqualToString:@"请输入症状"]) {
                textView.text = @"";
                textView.textColor = COLOR_333333;
            }
        }else {
            if([textView.text isEqualToString:@"请输入"]) {
                textView.text = @"";
                textView.textColor = COLOR_333333;
            }
        }
        
    }];
    
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath {
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        return 55;
    }else if(indexPath.row == 1) {
        return 155;
    }else {
        return 160;
    }
}

- (void)setMyModel:(RecipeModel *)model indexPathWith:(NSIndexPath *)indexPath {
  
    if(model.symptoms.length > 0) {
        self.symptomTextView.text = model.symptoms;
        self.symptomTextView.textColor = COLOR_333333 ;
    }else {
        self.symptomTextView.text = @"请输入症状";
        self.symptomTextView.textColor = COLOR_CDCDCF;
    }
    
    if(model.attention.length > 0) {
        self.attentionTextView.text = model.attention;
        self.attentionTextView.textColor = COLOR_333333 ;
    }else {
        self.attentionTextView.text = @"请输入";
        self.attentionTextView.textColor = COLOR_CDCDCF;
    }
    
    if(indexPath.row == 2) {
        self.numTextF.text =  model.times_day;
    }else {
        self.numTextF.text = model.recipe_no;
    }
    
    self.addDoctorOrderBtn.selected = model.isCommon;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
