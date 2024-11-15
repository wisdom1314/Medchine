//
//  CycleTakePhotoView.h
//  BlueBricks
//
//  Created by GOOT on 2018/10/24.
//  Copyright © 2018年 Wisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetImgURLBlock)(NSMutableArray *urlArray);

@interface CycleTakePhotoView : UIView

@property (nonatomic, copy) GetImgURLBlock getImgBlock;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *orginalArr;


@end
