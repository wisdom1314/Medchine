//
//  StatementModel.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/15.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatementModel : BaseModel
@property (nonatomic, copy) NSArray *report_drug_list;
@property (nonatomic, copy) NSString *sum_price_total;
@property (nonatomic, copy) NSString *sum_recipe_sale_price;
@end


@interface ReportDrugModel : BaseModel
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *drug_status;
@property (nonatomic, copy) NSString *equivalent;
@property (nonatomic, copy) NSString *granule_dose;
@property (nonatomic, copy) NSString *granule_his;
@property (nonatomic, copy) NSString *granule_name;
@property (nonatomic, copy) NSString *granule_no;
@property (nonatomic, copy) NSString *granule_price;
@property (nonatomic, copy) NSString *granule_sell_price;
@property (nonatomic, copy) NSString *herb_dose;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *max_value;
@property (nonatomic, copy) NSString *recipe_id;
@property (nonatomic, copy) NSString *recipe_name;
@property (nonatomic, copy) NSString *recipedetail_id;
@property (nonatomic, copy) NSString *sell_price;
@property (nonatomic, copy) NSString *stock_qty;
@property (nonatomic, copy) NSString *sum_herb_dose;
@property (nonatomic, copy) NSString *supply_price;
@end


@interface DoctorListModel : BaseModel
@property (nonatomic, copy) NSArray *doctor_list;
@end

NS_ASSUME_NONNULL_END
