//
//  MedicineURL.h
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicineURL : NSObject

FOUNDATION_EXTERN NSString *const BaseURL;

FOUNDATION_EXTERN NSString *const LoginURL;
FOUNDATION_EXTERN NSString *const UserInfoURL;
FOUNDATION_EXTERN NSString *const LoopImagesURL;
FOUNDATION_EXTERN NSString *const GenReportURL;
FOUNDATION_EXTERN NSString *const SelectDoctorURL;
FOUNDATION_EXTERN NSString *const GetConfigURL;
FOUNDATION_EXTERN NSString *const GetRegionsURL;
FOUNDATION_EXTERN NSString *const GetDrugListURL;
/// 历史处方
FOUNDATION_EXTERN NSString *const RecipeListURL;
/// 加常用医嘱
FOUNDATION_EXTERN NSString *const SaveAttentionURL;
/// 自提点
FOUNDATION_EXTERN NSString *const SelfPickListURL;
/// 常用医嘱
FOUNDATION_EXTERN NSString *const SelectAttentionListURL;
/// 删除医嘱
FOUNDATION_EXTERN NSString *const DeleteAttentionURL;
/// 处方模板列表
FOUNDATION_EXTERN NSString *const RecipesamplelistURL;
/// 删除处方模板
FOUNDATION_EXTERN NSString *const DeleteRecipesampleURL;
/// 分类管理
FOUNDATION_EXTERN NSString *const RecipeCategoryListURL;
/// 删除分类
FOUNDATION_EXTERN NSString *const DeleteCategoryURL;
/// 添加分类
FOUNDATION_EXTERN NSString *const AddCategoryURL;
/// 编辑分类
FOUNDATION_EXTERN NSString *const EditCategroyURL;
/// 创建处方模板
FOUNDATION_EXTERN NSString *const SaveRecipeSampleURL;
/// 获取模板详情
FOUNDATION_EXTERN NSString *const GetRecipeSampleURL;
/// 编辑处方模板
FOUNDATION_EXTERN NSString *const EditRecipeSampleURL;
/// 我的药房
FOUNDATION_EXTERN NSString *const RecipeHosListURL;
/// 确定缴费
FOUNDATION_EXTERN NSString *const PayMoneyURL;
/// 删除处方订单
FOUNDATION_EXTERN NSString *const DelRecipeURL;
/// 取消处方订单
FOUNDATION_EXTERN NSString *const CancelRecipeURL;
/// 查看处方订单详情
FOUNDATION_EXTERN NSString *const SeeRecipeURL;
/// 查看我的药房订单详情
FOUNDATION_EXTERN NSString *const RecipeHosDetailURL;
/// 查看物流详情
FOUNDATION_EXTERN NSString *const ExpressDetailURL;
/// 处方模板
FOUNDATION_EXTERN NSString *const CategorySampleListURL;

/// 上传图片
FOUNDATION_EXTERN NSString *const UploadImageURL;
/// 辅料列表
FOUNDATION_EXTERN NSString *const ExcipientListURL;
/// 占比
FOUNDATION_EXTERN NSString *const GetDicsURL;

///
FOUNDATION_EXTERN NSString *const SaveRecipeURL;

FOUNDATION_EXTERN NSString *const GetInfoForHistoryURL;

FOUNDATION_EXTERN NSString *const SelectDrugPkgURL;
FOUNDATION_EXTERN NSString *const CreateHosRecipeURL;


///--- 我的模块相关 ---

FOUNDATION_EXTERN NSString *const AccountDecURL;
FOUNDATION_EXTERN NSString *const GetOrgTransLogListURL;
FOUNDATION_EXTERN NSString *const GetOrgPayListURL;
FOUNDATION_EXTERN NSString *const CreateOrderURL;
/// 帮助中心
FOUNDATION_EXTERN NSString *const HelpCenterURL;
/// 修改密码
FOUNDATION_EXTERN NSString *const UpdatePasswordURL;
FOUNDATION_EXTERN NSString *const CancelAccountURL;

FOUNDATION_EXTERN NSString *const RelatedPharmacyURL;



FOUNDATION_EXTERN NSString *const PromoteRecipeListURL;
FOUNDATION_EXTERN NSString *const PromoteAgentCountURL;
FOUNDATION_EXTERN NSString *const PromoteInviteCountURL;
FOUNDATION_EXTERN NSString *const PromoteRecipeAmountSumURL;
FOUNDATION_EXTERN NSString *const RecipePayQrcodeURL;
FOUNDATION_EXTERN NSString *const RecipeDailyAmountURL;
FOUNDATION_EXTERN NSString *const PromoteAgentsListURL;
FOUNDATION_EXTERN NSString *const HospitalsListURL;
FOUNDATION_EXTERN NSString *const PromoteAgentDetail;
FOUNDATION_EXTERN NSString *const HospotalDetailURL;
FOUNDATION_EXTERN NSString *const PharmacyListURL;
FOUNDATION_EXTERN NSString *const AgentReviewURL;
/// 初审核
FOUNDATION_EXTERN NSString *const HospitalReviewURL;
/// 复审
FOUNDATION_EXTERN NSString *const HospitalNextReviewURL;

FOUNDATION_EXTERN NSString *const HospitalEditURL;

FOUNDATION_EXTERN NSString *const QueryPriceBySampleURL;

FOUNDATION_EXTERN NSString *const CheckLastAgreementURL;

FOUNDATION_EXTERN NSString *const AgreementListURL;

FOUNDATION_EXTERN NSString *const AgreeURL;
@end

NS_ASSUME_NONNULL_END
