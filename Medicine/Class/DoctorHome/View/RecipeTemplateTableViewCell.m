//
//  RecipeTemplateTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "RecipeTemplateTableViewCell.h"

@interface RecipeTemplateTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation RecipeTemplateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TemplateModel *)model {
    _model = model;
    self.nameLab.text = model.recipesample_name;
}

- (void)setCategoryModel:(CategoryModel *)categoryModel {
    _categoryModel = categoryModel;
    self.nameLab.text = categoryModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
   
    
    RecipeTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeTemplateTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeTemplateTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight{
    return 75;
}

@end
