//
//  DealCategoryView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface DealCategoryView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *numTextF;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) RACSubject *subject;

@property (nonatomic, strong) CategoryModel *model;

@end

NS_ASSUME_NONNULL_END
