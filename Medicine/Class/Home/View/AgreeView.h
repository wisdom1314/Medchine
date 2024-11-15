//
//  AgreeView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgreeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *commitLab;
@end

NS_ASSUME_NONNULL_END
