//
//  DoctorGridCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GRIDTYPE) {
    GRIDTYPE_SharePharmacy = 0,
    GRIDTYPE_MyPharmacy = 1,
    GRIDTYPE_RecipeModel = 2,
    GRIDTYPE_DoctorAdvice = 3
};

typedef void(^ChooseTypeBlock)(GRIDTYPE type);

@interface DoctorGridCell : UITableViewCell

@property (nonatomic, copy) ChooseTypeBlock typeBlock;

@end

NS_ASSUME_NONNULL_END
