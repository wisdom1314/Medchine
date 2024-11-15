//
//  StatementPickView.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatementPickView : UIView

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *commitSubject;

@property (nonatomic, copy) NSString *defaultValue;

@end

NS_ASSUME_NONNULL_END
