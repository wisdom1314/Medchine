//
//  RecipePicCollectionViewCell.h
//  Medicine
//
//  Created by 张智慧 on 2025/2/17.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecipePicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UploadImgModel *model;
@end

NS_ASSUME_NONNULL_END
