//
//  AddRecipeTemplateTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "AddRecipeTemplateTableViewCell.h"

@implementation AddRecipeTemplateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath typeWith:(nonnull NSString *)type{
    
    NSInteger selectTag = 0;
    NSString *identifier = @"AddRecipeTemplateTableViewCellFristId";
    if(indexPath.row == 1 && ![type isEqualToString:@"SELF"]) {
        selectTag = 1;
        identifier = @"AddRecipeTemplateTableViewCellSecondId";
    }else if((indexPath.row == 2 && ![type isEqualToString:@"SELF"]) || (indexPath.row == 1 && [type isEqualToString:@"SELF"])) {
        selectTag = 2;
        identifier = @"AddRecipeTemplateTableViewCellThridId";
    }
    
    AddRecipeTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddRecipeTemplateTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    [[cell rac_signalForSelector:@selector(textViewDidBeginEditing:) fromProtocol:@protocol(UITextViewDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UITextView *textView) = x;
        if([textView.text isEqualToString:@"请输入"]) {
            textView.text = @"";
            textView.textColor = COLOR_333333;
        }
    }];
    return cell;
}

+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath  typeWith:(nonnull NSString *)type{
    if((indexPath.row == 2 && ![type isEqualToString:@"SELF"]) || (indexPath.row == 1 && [type isEqualToString:@"SELF"]))  {
        return 130;
    }else {
   
        return 80;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
