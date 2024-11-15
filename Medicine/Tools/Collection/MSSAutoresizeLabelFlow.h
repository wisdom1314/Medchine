//
//  MSSAutoresizeLabelFlow.h
//  MSSAutoresizeLabelFlow
//
//  Created by Mrss on 15/12/26.
//  Copyright © 2015年 expai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedHandler)(NSUInteger index,NSString *title);

@interface MSSAutoresizeLabelFlow : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
              selectedHandler:(selectedHandler)handler
                         rows:(NSInteger)tableRow;;

- (void)insertLabelWithTitle:(NSString *)title
                     atIndex:(NSUInteger)index
                    animated:(BOOL)animated;

- (void)insertLabelsWithTitles:(NSArray *)titles
                     atIndexes:(NSIndexSet *)indexes
                      animated:(BOOL)animated;

- (void)deleteLabelAtIndex:(NSUInteger)index
                  animated:(BOOL)animated;

- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes
                     animated:(BOOL)animated;

- (void)reloadAllWithTitles:(NSArray *)titles;

@property (nonatomic ,assign) NSInteger myRow;

@property (nonatomic ,copy) selectedHandler handerBlock;

@property (nonatomic, assign) CGFloat collectionHeight;
@end




