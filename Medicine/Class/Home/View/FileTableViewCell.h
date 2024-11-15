//
//  FileTableViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *downBtn;

+ (CGFloat)getCellHeight;

@property (nonatomic, strong) idCardImgModel *model;

@end

NS_ASSUME_NONNULL_END
