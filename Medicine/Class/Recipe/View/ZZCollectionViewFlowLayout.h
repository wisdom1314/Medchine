//
//  ZZCollectionViewFlowLayout.h
//  GreatSecond
//
//  Created by GOOT on 2018/1/18.
//  Copyright © 2018年 wisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ZZCollectionViewFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
@end

@interface ZZCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<ZZCollectionViewFlowLayoutDelegate> delegate;


@end
