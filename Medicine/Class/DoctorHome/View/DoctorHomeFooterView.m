//
//  DoctorHomeFooterView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/23.
//

#import "DoctorHomeFooterView.h"

@implementation DoctorHomeFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
}

- (void)setModel:(RegionItemModel *)model {
    _model = model;
    
    NSString *text = @"提示：您的医疗机构信息不完善，为了保障后续账户的正常使用，请尽快填写资料，立即填写";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置普通文本颜色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_999999
                             range:NSMakeRange(0, text.length)];
    NSRange range1 = [text rangeOfString:@"立即填写"];
   
    [attributedString addAttribute:NSLinkAttributeName
                             value:model.qrcodeCompleteUrl
                             range:range1];
//    self.textView.tintColor = MainColor;
    self.textView.attributedText = attributedString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
