//
//  ShowQrcodeView.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import "ShowQrcodeView.h"
#import "SGCreateCode.h"
@interface ShowQrcodeView()
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImgView;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, assign) BOOL isSubTG;

@end

@implementation ShowQrcodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    @weakify(self);
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        UIImageWriteToSavedPhotosAlbum([self combineFrameWith:CGSizeMake(200, 300) imageWith: self.qrcodeImgView.image  text: self.infoLab.text], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    [[self.changeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.isSubTG = !self.isSubTG;
        [self reload];
    }];
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [ZZProgress showSuccessWithStatus:@"成功保存到相册"];
    }else {
        [ZZProgress showSuccessWithStatus:[error description]];
    }
}

- (void)setIsTG:(BOOL)isTG {
    _isTG = isTG;
    
    self.isSubTG = isTG;
   
    [self reload];
}

- (void)reload {
    if(self.isSubTG) {
        [self.changeBtn setTitle:@"切换邀请码" forState:UIControlStateNormal];
        self.userNameLab.text = [NSString stringWithFormat:@"%@推广码",[MedicineManager sharedInfo].customModel.nickName];
        self.qrcodeImgView.image = [SGCreateCode createQRCodeWithData:[MedicineManager sharedInfo].customModel.promoteUrl size:200];
        self.infoLab.text = @"医疗机构注册扫码";
        
    }else {
        [self.changeBtn setTitle:@"切换推广码" forState:UIControlStateNormal];
        self.userNameLab.text = [NSString stringWithFormat:@"%@邀请码",[MedicineManager sharedInfo].customModel.nickName];
        self.qrcodeImgView.image = [SGCreateCode createQRCodeWithData:[MedicineManager sharedInfo].customModel.inviteUrl size:200];
        self.infoLab.text = @"医助注册扫码";
    }
}

- (UIImage *)combineFrameWith:(CGSize)size imageWith:(UIImage *)oneImage text:(NSString *)logoText {
    // 获取图片宽高
    CGFloat width = oneImage.size.width;
    CGFloat height = oneImage.size.height;
    
    // 设置字体并计算文字大小
    UIFont *font = [UIFont systemFontOfSize:10 * (width / size.width)];
    NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName : [UIColor blackColor]};
    CGSize textSize = [logoText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attr
                                             context:nil].size;
    
    CGFloat spacing = 10; // 图片和文字之间的间距
    CGSize resultSize = CGSizeMake(width, height + textSize.height + spacing);
    UIGraphicsBeginImageContextWithOptions(resultSize, NO, 0.0);
    
    // 绘制图片
    CGRect imageRect = CGRectMake(0, 0, width, height);
    [oneImage drawInRect:imageRect];
    
    // 绘制居中的文字（在图片下方）
    CGRect textRect = CGRectMake((width - textSize.width) / 2, height + spacing, textSize.width, textSize.height);
    [logoText drawInRect:textRect withAttributes:attr];
    
    // 生成最终图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
