//
//  MedicineURL.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/9.
//

#import "MedicineURL.h"

@implementation MedicineURL

#ifdef DEBUG

NSString *const BaseURL = @"https://zhyf-test.jingpai.com";
//NSString *const BaseURL = @"https://zhyf.jingpai.com";

#else

//NSString *const BaseURL = @"http://zhyf.sfrog.cn/prod-api";
//NSString *const BaseURL = @"https://zhyf-test.jingpai.com";
NSString *const BaseURL = @"https://zhyf.jingpai.com";

#endif

NSString *const LoginURL = @"/app/login/login_do";
NSString *const UserInfoURL = @"/app/login/user_info";
NSString *const LoopImagesURL = @"/app/login/loop_images";
NSString *const GenReportURL = @"/app/report/gen_report";
NSString *const SelectDoctorURL = @"/app/report/select_doctor";
NSString *const GetConfigURL = @"/app/common/getConfigs";
NSString *const GetRegionsURL = @"/app/regions/select_regions";
NSString *const GetDrugListURL = @"/app/drug/v2.0/selectdrug";
NSString *const RecipeListURL = @"/app/recipe/recipelist";
NSString *const SaveAttentionURL = @"/app/attention/save_attention";
NSString *const SelfPickListURL = @"/app/recipe/selfPickList";
NSString *const SelectAttentionListURL = @"/app/attention/select_attentionlist";
NSString *const DeleteAttentionURL  = @"/app/attention/del_attention";
NSString *const RecipesamplelistURL = @"/app/recipesample/recipesamplelist";
NSString *const DeleteRecipesampleURL = @"/app/recipesample/del_recipesample";
NSString *const RecipeCategoryListURL = @"/app/recipeCategory/list";
NSString *const DeleteCategoryURL = @"/app/recipeCategory/delCate";
NSString *const AddCategoryURL = @"/app/recipeCategory/addCate";
NSString *const EditCategroyURL = @"/app/recipeCategory/editCate";
NSString *const SaveRecipeSampleURL = @"/app/recipesample/save_recipesample";
NSString *const GetRecipeSampleURL = @"/app/recipesample/pull_recipesample";
NSString *const EditRecipeSampleURL = @"/app/recipesample/edit_recipesample";
NSString *const RecipeHosListURL = @"/app/recipeHos/recipelist";
NSString *const PayMoneyURL = @"/app/recipe/pay_money";
NSString *const DelRecipeURL = @"/app/recipe/del_recipe";
NSString *const CancelRecipeURL = @"/app/recipeHos/cancel_recipe";
NSString *const SeeRecipeURL = @"/app/recipe/see_recipe";
NSString *const RecipeHosDetailURL = @"/app/recipeHos/see_recipe";
NSString *const ExpressDetailURL = @"/app/recipe/expressDetail";
NSString *const CategorySampleListURL = @"/app/recipesample/categorySampleList";
NSString *const UploadImageURL = @"/app/common/upload";
NSString *const ExcipientListURL = @"/app/excipient/excipientList";
NSString *const GetDicsURL = @"/app/common/getDicts";
NSString *const SaveRecipeURL = @"/app/recipe/save_recipe";
NSString *const GetInfoForHistoryURL = @"/app/recipe/getInfoForHistory";
NSString *const SelectDrugPkgURL = @"/app/drug/selectDrugPkglist";
NSString *const CreateHosRecipeURL = @"/app/recipeHos/save_recipe_hos";

NSString *const AccountDecURL = @"/app/account/accountDesc";
NSString *const GetOrgTransLogListURL = @"/app/account/getOrgTransLogList";
NSString *const GetOrgPayListURL = @"/app/account/getOrgPayLogList";
NSString *const CreateOrderURL = @"/app/account/createPayOrder";
NSString *const HelpCenterURL = @"/app/version/get_help";
NSString *const UpdatePasswordURL = @"/app/login/update_password";
NSString *const CancelAccountURL = @"/app/login/cancelAccount";

NSString *const RelatedPharmacyURL= @"/app/recipe/relatedPharmacy";



/// 医助端
NSString *const PromoteRecipeListURL = @"/app/v3.0/promote/recipe/list";
NSString *const PromoteAgentCountURL = @"/app/v3.0/promote/agentCount";
NSString *const PromoteInviteCountURL = @"/app/v3.0/promote/inviteCount";
NSString *const PromoteRecipeAmountSumURL = @"/app/v3.0/promote/recipeAmountSum";
NSString *const RecipePayQrcodeURL = @"/app/recipe/pay_qrcode";
NSString *const RecipeDailyAmountURL = @"/app/v3.0/promote/recipeDailyAmounts";
NSString *const PromoteAgentsListURL = @"/app/v3.0/promote/agents/list";
NSString *const HospitalsListURL  = @"/app/v3.0/promote/hospitals/list";
NSString *const PromoteAgentDetail = @"/app/v3.0/promote/agents/detail";
NSString *const HospotalDetailURL = @"/app/v3.0/hospitals/detail";
NSString *const PharmacyListURL = @"/app/v3.0/pharmacy/list";
NSString *const AgentReviewURL = @"/app/v3.0/agents/review1";
/// 初审核
NSString *const HospitalReviewURL = @"/app/v3.0/hospitals/review1";
/// 复审
NSString *const HospitalNextReviewURL = @"/app/v3.0/hospitals/review2";

NSString *const HospitalEditURL = @"/app/v3.0/hospitals/edit";

NSString *const QueryPriceBySampleURL = @"/app/recipesample/queryPriceBySample";

NSString *const CheckLastAgreementURL = @"/app/agreement/checkLastAgreement";

NSString *const AgreementListURL = @"/app/agreement/agreementList";

NSString *const AgreeURL = @"/app/agreement/acceptAgreement";
@end
