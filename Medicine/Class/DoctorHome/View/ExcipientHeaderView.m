//
//  ExcipientHeaderView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/25.
//

#import "ExcipientHeaderView.h"

@implementation ExcipientHeaderView

- (void)setModel:(RecipeModel *)model {
    _model = model;
    /// 单幅颗粒总剂量
    CGFloat totalKeliNum = 0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 4; // 设置最多四位小数
    formatter.minimumFractionDigits = 4; // 设置最少四位小数

    for (DrugItemModel *drugModel in model.drugArr) {
        drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
        CGFloat value = [drugModel.herb_dose floatValue] / [drugModel.useful_value floatValue];
        // 格式化结果为四位小数
        NSString *formattedValueString = [formatter stringFromNumber:@(value)];
        CGFloat formattedValue = [formattedValueString floatValue];
        // 将格式化后的值累加到 totalKeliNum
        totalKeliNum += formattedValue;
    }
//    辅料总量
    CGFloat totalFlNum =  round(totalKeliNum * [model.excipient_proportion floatValue]) * [model.recipe_no integerValue];
    self.totalLab.text = [NSString stringWithFormat:@"辅料总用量%.0f",totalFlNum];
    model.excipentTotal = [NSString stringWithFormat:@"%.0f",totalFlNum];
    NSLog(@"******** %@", model.excipentTotal);
               
}

- (RACSubject *)subject {
    if(!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
