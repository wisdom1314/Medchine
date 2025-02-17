//
//  RecipeTablesView.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipeTablesView : UIView

@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, copy) NSString *recipesampleName;
@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
