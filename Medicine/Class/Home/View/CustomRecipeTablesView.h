//
//  CustomRecipeTablesView.h
//  Medicine
//
//  Created by 张智慧 on 2024/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomRecipeTablesView : UIView
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *date2;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isDoctor;
@end

NS_ASSUME_NONNULL_END
