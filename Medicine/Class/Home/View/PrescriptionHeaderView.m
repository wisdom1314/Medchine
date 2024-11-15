//
//  PrescriptionHeaderView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import "PrescriptionHeaderView.h"

@implementation PrescriptionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSDictionary *attributesDict = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:13],
                                         NSForegroundColorAttributeName:COLOR_562306
                                         };//还可以添加其他属性
    [self.segmentControll setTitleTextAttributes:attributesDict forState:UIControlStateNormal];
    [self.segmentControll setTitleTextAttributes:attributesDict forState:UIControlStateSelected];
    [self.segmentControll setBackgroundImage:[ClassMethod imageWithColor:COLOR_F2E7D6]
                          forState:UIControlStateNormal
                        barMetrics:UIBarMetricsDefault];
    [self.segmentControll setBackgroundImage:[ClassMethod imageWithColor:COLOR_FFFFFF]
                          forState:UIControlStateSelected
                        barMetrics:UIBarMetricsDefault];
    [self.segmentControll setDividerImage:[ClassMethod imageWithColor:COLOR_E2C8A9] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.segmentControll.layer.borderWidth = 0.5;
    self.segmentControll.layer.borderUIColor = COLOR_E2C8A9;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
