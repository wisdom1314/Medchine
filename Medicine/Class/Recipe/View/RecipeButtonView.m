//
//  RecipeButtonView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import "RecipeButtonView.h"

@implementation RecipeButtonView


- (void)setBtnSelected: (NSInteger)tag {
    if(tag == 1) {
        self.myBtn.selected = YES;
        self.shareBtn.selected = NO;
    }else {
        self.shareBtn.selected = YES;
        self.myBtn.selected = NO;
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
