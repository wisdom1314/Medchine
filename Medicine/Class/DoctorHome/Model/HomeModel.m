//
//  HomeModel.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/15.
//

#import "HomeModel.h"

@implementation HomeModel

@end

@implementation BannerModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"images" : @"BannerPicModel"
             };
}
@end

@implementation BannerPicModel

@end

@implementation  RegionsListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"regions_list" : @"RegionItemModel"
             };
}
@end

@implementation  RegionItemModel

@end

@implementation  RecipeModel

@end

@implementation PageBaseModel

@end

@implementation PageListModel

@end

@implementation SelfPickModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"pick_id":@"id"};
    
}

@end


@implementation AttentionListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"AttentionItemModel"
             };
}
@end

@implementation AttentionItemModel

@end

@implementation BaseDataModel

@end


@implementation AccountInfoModel


@end

@implementation TemplateModel


@end


@implementation CategoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"category_id":@"id"};
    
}
@end



@implementation DrugListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"DrugItemModel"
             };
}

@end
@implementation DrugItemModel

@end


@implementation RecipeOrderDetailModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"recipedetail" : @"DrugItemModel",
             @"recipeLogList" : @"RecipeLogItemModel",
             @"recipeExcipientList": @"RecipeExcipientModel"
             };
}

@end


@implementation RecipeOrderItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"recipe_description":@"description"};
    
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"fileList" : @"UploadImgModel",
             };
}

@end


@implementation RecipeLogItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"log_operator":@"operator"};
    
}
@end


@implementation ExpressListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"logisticsTraceDetails" : @"ExpressItemModel",
             };
}

@end

@implementation ExpressItemModel


@end


@implementation RecipeExcipientModel


@end


@implementation CategoryTemplateListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"CategoryTemplateItemModel",
             };
}

@end

@implementation CategoryTemplateItemModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"recipeList" : @"RecipesampleSymptomsModel",
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if(oldValue == [NSNull null]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
           return  @[];
        }
        if([oldValue isKindOfClass:[NSDictionary class]]){
          return @{};
        }
    }
    return oldValue;
}

@end

@implementation RecipesampleSymptomsModel

@end

@implementation UploadImgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"pic_id":@"id"};
    
}
@end


@implementation ExcipientModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"ExcipientItemModel",
             };
}
@end

@implementation ExcipientItemModel


@end


@implementation DictModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"DictItemModel",
             };
}
@end

@implementation DictItemModel

@end


@implementation PromoteUserBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"user_id":@"id",  @"promoteUser": @"promoteUser"};
    
}

@end


@implementation PromoteUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"user_id":@"id"};
    
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"attachFiles" : @"idCardImgModel",
             };
}

@end



@implementation idCardImgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"file_id":@"id"};
    
}

@end

@implementation PharmacyModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"pharmacy_id":@"id"};
    
}
@end


@implementation RecipeDailyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"RecipeDailyItemModel",
             };
}

@end




@implementation RecipeDailyItemModel

@end
