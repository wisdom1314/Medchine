//
//  MineModel.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/18.
//

#import "BaseModel.h"
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineModel : BaseModel

@end

@interface TransLogModel : BaseModel
@property (nonatomic, copy) NSString *payLogId;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *orgFullName;
@property (nonatomic, copy) NSString *hospitalId;
@property (nonatomic, copy) NSString *hospitalName;
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *log_operator;
@property (nonatomic, copy) NSString *operatorTime;
@property (nonatomic, copy) NSString *recipeName;
@property (nonatomic, copy) NSString *paymentSn;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, copy) NSString *afterBalance;

@end

@interface PayModel : BaseModel
@property (nonatomic, copy) NSString *form;
@property (nonatomic, copy) NSString *paymentSn;
@end

NS_ASSUME_NONNULL_END
