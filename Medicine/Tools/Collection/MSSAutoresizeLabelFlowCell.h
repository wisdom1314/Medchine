//
//  MSSAutoresizeLabelFlowCell.h
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSAutoresizeLabelFlowCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;
- (void)configCellWithTitle:(NSString *)title;

@end



