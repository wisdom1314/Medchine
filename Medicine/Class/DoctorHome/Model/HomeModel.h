//
//  HomeModel.h
//  Medicine
//
//  Created by 张智慧 on 2024/10/15.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : BaseModel

@end


@interface BannerModel : BaseModel
@property (nonatomic, copy) NSArray *images;
@end

@interface BannerPicModel : BaseModel
@property (nonatomic, copy) NSString *picurl;
@end

@interface RegionsListModel : BaseModel
@property (nonatomic, copy) NSArray *regions_list;
@end

@interface RegionItemModel : BaseModel
@property (nonatomic, copy) NSString *regions_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *hospitaladdress;
@property (nonatomic, copy) NSString *isComplete;
@property (nonatomic, copy) NSString *qrcodeCompleteUrl;
@property (nonatomic, copy) NSString *userId;
@end

@interface RecipeModel : BaseModel
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *doctor;
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, assign) BOOL force_stock_create;
@property (nonatomic, copy) NSString *hospital_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_total;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *recipe_no;
@property (nonatomic, copy) NSString *recipe_sale_price;
@property (nonatomic, copy) NSString *recipedetail_list;
@property (nonatomic, copy) NSString *sell_price;
@property (nonatomic, copy) NSString *sell_price_total;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *symptoms;
@property (nonatomic, copy) NSString *times_day;
@property (nonatomic, copy) NSString *total_granule_dose;
@property (nonatomic, copy) NSString *excipient_proportion;
@property (nonatomic, copy) NSString *recipe_excipient_list;
@property (nonatomic, copy) NSString *recipe_sample_id;
@property (nonatomic, copy) NSString *recipe_sample;
@property (nonatomic, copy) NSString *delivery_mode;
@property (nonatomic, copy) NSString *fileIds;
@property (nonatomic, copy) NSArray *fileArr;
@property (nonatomic, copy) NSString *recipe_type;
/// 常用医嘱
@property (nonatomic, assign) BOOL isCommon;

@property (nonatomic, copy) NSArray *drugArr;
@property (nonatomic, copy) NSArray *excipentArr;

@property (nonatomic, copy) NSString *excipentTotal;
@property (nonatomic, copy) NSString *cost;
@property (nonatomic, assign) BOOL isCustom;
@property (nonatomic, copy) NSString *recipesample_name;
@property (nonatomic, copy) NSString *recipesample_symptoms;
@property (nonatomic, copy) NSString *categoryId;



@property (nonatomic, copy) NSString *totalKeli;

@property (nonatomic, copy) NSString *recipdetailListJSON;
@property (nonatomic, copy) NSString *need_factor;

@property (nonatomic, assign) BOOL isMy;
@property (nonatomic, copy) NSString *is_secret;
@property (nonatomic, copy) NSString *recipeGranuleDose;
@property (nonatomic, copy) NSString *totalSellPrice;
@property (nonatomic, copy) NSString *totalSupplePrice;

@end

@class PageListModel;
@interface PageBaseModel : BaseModel
@property (nonatomic, copy) NSDictionary *list;
@property (nonatomic, strong) PageListModel *listModel;
@end


@interface PageListModel : BaseModel
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *per_page;
@property (nonatomic, copy) NSString *current_page;
@property (nonatomic, copy) NSString *last_page;
@property (nonatomic, copy) NSArray *data;
@end


@interface SelfPickModel : BaseModel
@property (nonatomic, copy) NSString *pick_id;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *simpleName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *selfPick;
@property (nonatomic, copy) NSString *drugSource;
@property (nonatomic, copy) NSString *isSelfSupport;
@property (nonatomic, assign) BOOL isSelect;
@end


@interface AttentionListModel : BaseModel
@property (nonatomic, copy) NSArray *list;
@end

@interface AttentionItemModel : BaseModel
@property (nonatomic, copy) NSString *attention_id;
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *careful;
@property (nonatomic, copy) NSString *doctor;
@property (nonatomic, copy) NSString *sign;
@end


@interface BaseDataModel : BaseModel
@property (nonatomic, copy) NSDictionary *data;
@end


@interface AccountInfoModel : BaseModel
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *costMoney;
@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, copy) NSString *creditLine;
@property (nonatomic, copy) NSString *hospitalCode;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *hospitaltel;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *hospitaladdress;
@end


@interface TemplateModel: BaseModel
@property (nonatomic, copy) NSString *recipesample_id;
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *recipesample_name;
@property (nonatomic, copy) NSString *recipesample_symptoms;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *doctor;
@property (nonatomic, copy) NSString *pharmacy_type;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@end


@interface CategoryModel: BaseModel
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *doctorId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *createTime;
@end

@interface DrugListModel : BaseModel
@property (nonatomic, copy) NSArray *list;
@end

@interface DrugItemModel : BaseModel
@property (nonatomic, copy) NSString *drugname;
@property (nonatomic, copy) NSString *useful_value;
@property (nonatomic, copy) NSString *supply_price;
@property (nonatomic, copy) NSString *guide_price;
@property (nonatomic, copy) NSString *sell_price;
@property (nonatomic, copy) NSString *drug_price;
@property (nonatomic, copy) NSString *hiscode;
@property (nonatomic, copy) NSString *stock_qty;
@property (nonatomic, copy) NSString *max_value;
@property (nonatomic, copy) NSString *herb_factor;
@property (nonatomic, copy) NSString *origin_herb_factor;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *recipesampledetail_id;
@property (nonatomic, copy) NSString *granule_name;
@property (nonatomic, copy) NSString *herb_dose;
@property (nonatomic, copy) NSString *equivalent;
@property (nonatomic, copy) NSString *granule_dose;
@property (nonatomic, copy) NSString *granule_sell_price;
@property (nonatomic, copy) NSString *granule_his;
@property (nonatomic, copy) NSString *drug_status;
@property (nonatomic, copy) NSString *old_herb_dose;
@property (nonatomic, assign) BOOL isEx;

@property (nonatomic, copy) NSString *need_factor;

@property (nonatomic, copy) NSString *isSecret;
@property (nonatomic, copy) NSString *recipe_sample_id;
@property (nonatomic, copy) NSString *recipe_sample;

@end

@class RecipeOrderItemModel;
@interface RecipeOrderDetailModel: BaseModel
@property (nonatomic, copy) NSDictionary *recipe;
@property (nonatomic, strong) RecipeOrderItemModel *recipeModel;
@property (nonatomic, copy) NSArray *recipedetail;
@property (nonatomic, copy) NSArray *recipeLogList;
@property (nonatomic, copy) NSArray *recipeExcipientList;
@property (nonatomic, assign) BOOL isExpand;
@end



@interface RecipeOrderItemModel : BaseModel
@property (nonatomic, copy) NSString *recipe_id;
@property (nonatomic, copy) NSString *hospital_id;
@property (nonatomic, copy) NSString *doctor_id;
@property (nonatomic, copy) NSString *recipe_name;
@property (nonatomic, copy) NSString *registry_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *symptoms;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *doctor;
@property (nonatomic, copy) NSString *recipe_no;
@property (nonatomic, copy) NSString *granule_total_no;
@property (nonatomic, copy) NSString *times_day;
@property (nonatomic, copy) NSString *factor;
@property (nonatomic, copy) NSString *attention;
@property (nonatomic, copy) NSString *recipe_sample;
@property (nonatomic, copy) NSString *recipe_sample_id;
@property (nonatomic, copy) NSString *recipe_time;
@property (nonatomic, copy) NSString *operator_name;
@property (nonatomic, copy) NSString *operation_time;
@property (nonatomic, copy) NSString *pricing_id;
@property (nonatomic, copy) NSString *pricing_cashie;
@property (nonatomic, copy) NSString *pricing_time;
@property (nonatomic, copy) NSString *total_granule_dose;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *sellPrice;
@property (nonatomic, copy) NSString *priceTotal;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *sell_price_total;
@property (nonatomic, copy) NSString *recipe_sale_price;
@property (nonatomic, copy) NSString *payment_type;
@property (nonatomic, copy) NSString *payment_status;
@property (nonatomic, copy) NSString *recipe_source;
@property (nonatomic, copy) NSString *machine_name;
@property (nonatomic, copy) NSString *bed;
@property (nonatomic, copy) NSString *recipe_description;
@property (nonatomic, copy) NSString *asyc;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *sych_status;
@property (nonatomic, copy) NSString *refundName;
@property (nonatomic, copy) NSString *patientId;
@property (nonatomic, copy) NSString *visitId;
@property (nonatomic, copy) NSString *mailingAddress;
@property (nonatomic, copy) NSString *pull_time;
@property (nonatomic, copy) NSString *hospitalname;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *express_no;
@property (nonatomic, copy) NSString *recipe_type;
@property (nonatomic, copy) NSString *delivery_mode;
@property (nonatomic, copy) NSString *excipient_cost;
@property (nonatomic, copy) NSString *excipient_price;
@property (nonatomic, copy) NSString *excipient_proportion;
@property (nonatomic, copy) NSString *excipient_weight;
@property (nonatomic, copy) NSString *is_secret;
@property (nonatomic, copy) NSArray *fileList;
@property (nonatomic, copy) NSString *recipe_status;
@property (nonatomic, copy) NSString *need_factor;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *payQrimage;
@property (nonatomic, copy) NSString *is_self_support;

@end


@interface RecipeLogItemModel: BaseModel
@property (nonatomic, copy) NSString *recipeLogId;
@property (nonatomic, copy) NSString *recipeName;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *log_operator;
@property (nonatomic, copy) NSString *operatorTime;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) BOOL isLast;

@end

@interface ExpressListModel: BaseModel
@property (nonatomic, copy) NSArray *logisticsTraceDetails;

@end

@interface ExpressItemModel: BaseModel
@property (nonatomic, copy) NSString *ftime;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL isLast;
@end


@interface RecipeExcipientModel : BaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *price;
@end


@interface CategoryTemplateListModel : BaseModel
@property (nonatomic, copy) NSArray *data;
@end

@interface CategoryTemplateItemModel : BaseModel
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSArray *recipeList;
@end

@interface RecipesampleSymptomsModel : BaseModel
@property (nonatomic, copy) NSString *recipesampleId;
@property (nonatomic, copy) NSString *recipesampleName;
@property (nonatomic, copy) NSString *recipesampleSymptoms;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *isSecret;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *parentName;
@end


@interface UploadImgModel : BaseModel
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *pic_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@end



@interface ExcipientModel : BaseModel
@property (nonatomic, copy) NSArray *data;
@end

@interface ExcipientItemModel : BaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *pyquery;
@property (nonatomic, assign) NSInteger num;

@end




@interface DictModel : BaseModel
@property (nonatomic, copy) NSArray *data;
@end

@interface DictItemModel : BaseModel

@property (nonatomic, copy) NSString *dictLabel;
@property (nonatomic, copy) NSString *dictValue;
@property (nonatomic, copy) NSString *dictType;

@end

@class PromoteUserModel;
@interface PromoteUserBaseModel : BaseModel
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *agentLevel;
@property (nonatomic, copy) NSString *manageAreaNames;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *promoteUserId;
@property (nonatomic, copy) NSString *reviewable;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) PromoteUserModel *promoteUser;


/// 医生
@property (nonatomic, copy) NSString *hospitalId;
@property (nonatomic, copy) NSString *managerName;
@property (nonatomic, copy) NSString *managerSex;
@property (nonatomic, copy) NSString *managerAvatar;
@property (nonatomic, copy) NSString *managerDeptCode;
@property (nonatomic, copy) NSString *managerTitleCode;
@property (nonatomic, copy) NSString *managerDoctorYears;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *hospitalname;
@property (nonatomic, copy) NSString *review2able;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *isSelfSupport;
@property (nonatomic, assign) BOOL isHos;
@end

@class idCardImgModel;
@class PharmacyModel;
@interface PromoteUserModel : BaseModel
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *parentAgentLevel;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *agentLevel;
@property (nonatomic, copy) NSString *agentLevelName;
/// 详情
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSDictionary *idcardImage1;
@property (nonatomic, copy) NSDictionary *idcardImage2;
@property (nonatomic, strong) idCardImgModel *idcardImageModel1;
@property (nonatomic, strong) idCardImgModel *idcardImageModel2;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *manageAreaNames;
@property (nonatomic, copy) NSString *addressDetail;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *reviewRemark;

/// 医生详情
@property (nonatomic, copy) NSString *hospitalId;
@property (nonatomic, copy) NSString *managerName;
@property (nonatomic, copy) NSString *managerSex;
@property (nonatomic, copy) NSString *managerSexName;
@property (nonatomic, copy) NSString *managerAvatar;
@property (nonatomic, copy) NSString *managerIdcard;
@property (nonatomic, copy) NSString *managerDeptCode;
@property (nonatomic, copy) NSString *managerDeptName;
@property (nonatomic, copy) NSString *managerTitleCode;
@property (nonatomic, copy) NSString *managerTitleName;
@property (nonatomic, copy) NSString *managerDoctorYears;
@property (nonatomic, copy) NSString *managerSignType;
@property (nonatomic, copy) NSString *managerSignUrl;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *hospitalname;
@property (nonatomic, copy) NSString *hospitaladdress;
@property (nonatomic, copy) NSString *reviewable;
@property (nonatomic, copy) NSString *review2able;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSDictionary *businessLicenseFile;
@property (nonatomic, strong) idCardImgModel *businessLicenseFileModel;
@property (nonatomic, copy) NSDictionary *hospitalLicenseFile;
@property (nonatomic, strong) idCardImgModel *hospitalLicenseFileModel;
@property (nonatomic, copy) NSDictionary *doctorLicenseFile;
@property (nonatomic, strong) idCardImgModel *doctorLicenseFileModel;
@property (nonatomic, copy) NSArray *attachFiles;
@property (nonatomic, copy) NSString *managerUserId;
@property (nonatomic, copy) NSDictionary *pharmacy;
@property (nonatomic, strong) PharmacyModel *pharmacyModel;
@property (nonatomic, copy) NSString *certType;
@property (nonatomic, copy) NSString *certTypeName;
@property (nonatomic, copy) NSString *certNo;

@end


@interface idCardImgModel : BaseModel
@property (nonatomic, copy) NSString *file_id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileSize;
@end

@interface PharmacyModel : BaseModel
@property (nonatomic, copy) NSString *pharmacy_id;
@property (nonatomic, copy) NSString *simpleName;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *selfPick;
@property (nonatomic, copy) NSString *drugSource;
@property (nonatomic, copy) NSString *isSelfSupport;
@property (nonatomic, copy) NSString *payQrimage;
@end


@interface RecipeDailyModel : BaseModel
@property (nonatomic, copy) NSArray *data;
@end

@interface RecipeDailyItemModel : BaseModel
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *amount;
@end


@interface SecrectRecipeModel : BaseModel
@property (nonatomic, copy) NSString *recipeGranuleDose;
@property (nonatomic, copy) NSString *totalSellPrice;
@property (nonatomic, copy) NSString *totalSupplePrice;
@end

@interface PrivacyRuleModel: BaseModel
@property (nonatomic, copy) NSArray *data;
@end


@interface PrivacyRuleItemModel : BaseModel
@property (nonatomic, copy) NSString *agreementId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *acceptTime;
@end

NS_ASSUME_NONNULL_END
