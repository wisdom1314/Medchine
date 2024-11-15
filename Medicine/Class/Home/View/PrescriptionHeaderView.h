//
//  PrescriptionHeaderView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrescriptionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;

@end

NS_ASSUME_NONNULL_END
