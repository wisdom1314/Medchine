//
//  RecipePicCollectionViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2025/2/17.
//

#import "RecipePicCollectionViewCell.h"

@implementation RecipePicCollectionViewCell

- (void)setModel:(UploadImgModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"accountPlace"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
