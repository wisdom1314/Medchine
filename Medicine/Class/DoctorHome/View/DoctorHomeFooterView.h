//
//  DoctorHomeFooterView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/23.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoctorHomeFooterView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) RegionItemModel *model;
@end

NS_ASSUME_NONNULL_END
