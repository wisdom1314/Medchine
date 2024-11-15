//
//  PayQrcodeView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayQrcodeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImagView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic, strong) RACSubject *subject;

@end

NS_ASSUME_NONNULL_END
