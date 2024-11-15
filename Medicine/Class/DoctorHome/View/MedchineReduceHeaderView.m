//
//  MedchineReduceHeaderView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/5.
//

#import "MedchineReduceHeaderView.h"
@interface MedchineReduceHeaderView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trueBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *falseHeight;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@end

@implementation MedchineReduceHeaderView

- (void)setModel:(RecipeModel *)model {
    _model = model;
    if([model.need_factor integerValue] == 1) {
        self.trueBtn.selected = YES;
        self.falseBtn.selected = NO;
    }else {
        self.trueBtn.selected = NO;
        self.falseBtn.selected = YES;
    }
}

- (void)setHide:(BOOL)hide {
    _hide = hide;
    if(hide) {
        self.topLab.hidden = YES;
        self.falseBtn.hidden = YES;
        self.trueBtn.hidden = YES;
        self.labelHight.constant = 0;
        self.trueBtnHeight.constant = 0;
        self.falseHeight.constant = 0;
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
