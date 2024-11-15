//
//  AssistantHeaderView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/14.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssistantHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *tgNumLab;

@property (weak, nonatomic) IBOutlet UILabel *inviateNumLab;
@property (nonatomic, strong) PromoteUserModel *model;
@end

NS_ASSUME_NONNULL_END
