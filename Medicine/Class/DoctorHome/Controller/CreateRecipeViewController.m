//
//  CreateRecipeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/18.
//

#import "CreateRecipeViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "PatientTableViewCell.h"
#import "RecipeTableViewCell.h"
#import "MedchineReduceHeaderView.h"
#import "MedchineReduceTableViewCell.h"
#import "ComputeTableViewCell.h"
#import "UIAreaPickView.h"
#import "AddRecipeTemplateView.h"
#import "HomeModel.h"
#import "ExcipientHeaderView.h"
#import "AccessoryTableViewCell.h"
#import "StatementPickView.h"
#import "RecipeLastView.h"
@interface CreateRecipeViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *addTemplateBtn;
@property (nonatomic, strong) UIAreaPickView *areaView;
@property (nonatomic, strong) RecipeModel *model;
@property (nonatomic, strong) RegionItemModel *regionModel;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, strong) NSMutableArray *drugArr;
@property (nonatomic, strong) NSMutableArray *excipentArr;
@property (nonatomic, strong) StatementPickView *pickView;
@property (nonatomic, strong) NSMutableArray *dicArray;
@property (nonatomic, copy) NSArray *bottomArr;
@property (nonatomic, copy) NSArray *gfBottomArr;


@end

@implementation CreateRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"创建处方";
    self.bottomArr = @[@[@"处方味数", @"味"],@[@"颗粒总剂量", @"g"],@[@"颗粒总价", @"元"],@[@"运费", @"元"],@[@"实收金额", @"元"]];
    self.gfBottomArr = @[@[@"处方味数", @"味"],@[@"颗粒总剂量", @"g"],@[@"颗粒总价", @"元"],@[@"运费", @"元"],@[@"辅料总价", @"元"],@[@"工本费", @"元"],@[@"实收金额", @"元"]];
    self.column = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"MedchineReduceHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MedchineReduceHeaderViewId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ExcipientHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ExcipientHeaderViewId"];
    [self requestAddressInfo];
    
    @weakify(self);
    [[self.addTemplateBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.drugArr.count == 0) {
            [ZZProgress showErrorWithStatus:@"请添加药品"];
            return;
        }
        
        for (DrugItemModel *subModel in self.drugArr) {
            if(subModel.num  == 0) {
                [ZZProgress showErrorWithStatus:[NSString stringWithFormat:@"请编辑%@用量",subModel.drugname]];
                return;
            }
        }
        
        AddRecipeTemplateView *templateView = [AddRecipeTemplateView createViewFromNib];
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:templateView preferredStyle:TYAlertControllerStyleAlert];
        alertVC.backgoundTapDismissEnable = YES;
        [self presentViewController:alertVC animated:YES completion:nil];
        [[templateView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [templateView.subject subscribeNext:^(id  _Nullable x) {
            NSDictionary *dic = x;
            self.model.recipesample_name = [dic valueForKey:@"recipesample_name"];
            self.model.recipesample_symptoms = [dic valueForKey:@"recipesample_symptoms"];
            self.model.categoryId = [dic valueForKey:@"categoryId"];
            [self saveTemplate];
            [alertVC dismissViewControllerAnimated:YES];
        }];
    }];
    
    [self requestDics];
    [self requestConfig];
    
    if([[self.param allKeys]containsObject:@"model"] && ![[self.param allKeys]containsObject:@"isBack"]) {
        RecipeOrderItemModel *itemModel = self.param[@"model"];
        [self requestHistoryInfoWith:itemModel.recipe_id];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[self.param allKeys]containsObject:@"model"] && [[self.param allKeys]containsObject:@"isBack"]) {
        RecipeOrderItemModel *itemModel = self.param[@"model"];
        [self requestHistoryInfoWith:itemModel.recipe_id];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.addTemplateBtn addTopBorderWithColor:COLOR_B72E26 width:1];
    [self.addTemplateBtn addBottomBorderWithColor:COLOR_B72E26 width:1];
}

- (IBAction)lastSaveClick:(id)sender {
    
    [self.tableView reloadData];
    
    if(self.model.name.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入患者姓名"];
        return;
    }
    if(self.model.age.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入患者年龄"];
        return;
    }
    if(self.model.phone.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入患者手机号"];
        return;
    }
    
    if(self.model.address.length == 0) {
        [ZZProgress showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    
    if(self.drugArr.count == 0) {
        [ZZProgress showErrorWithStatus:@"请添加药品"];
        return;
    }

    for (DrugItemModel *subModel in self.drugArr) {
        if(subModel.num  == 0) {
            [ZZProgress showErrorWithStatus:[NSString stringWithFormat:@"请编辑%@用量",subModel.drugname]];
            return;
        }
    }
    
    if([self.model.recipe_type integerValue] == 1) {
        if([self.model.totalKeli floatValue]<300){
            [ZZProgress showErrorWithStatus:@"颗粒总剂量不能小于300g"];
            return;
        }
    }
    if(self.model.isCommon) {
        [self addAttention]; /// 常用医嘱
    }
  
    RecipeLastView *lastView = [RecipeLastView createViewFromNib];
    TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:lastView preferredStyle:TYAlertControllerStyleAlert];
    lastView.model = self.model;
    alertVC.backgoundTapDismissEnable = YES;
    [[lastView.cacelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [alertVC dismissViewControllerAnimated:YES];
    }];
    [[lastView.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self saveRecipeLast];
        [alertVC dismissViewControllerAnimated:YES];
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)saveRecipeLast {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *recipedetail_list = [NSMutableArray array];
    for (DrugItemModel *subModel in self.model.drugArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:subModel.drugname forKey:@"granule_name"];
        [dic setValue:@"" forKey:@"granule_no"];
        /// 减量相关
        subModel.herb_dose = [self.model.need_factor integerValue] ==1?  [ClassMethod formatNumberWithCustomRounding:subModel.num*[subModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld",subModel.num];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.herb_dose  floatValue]/[subModel.useful_value floatValue]] forKey:@"granule_dose"];
        [dic setValue:subModel.herb_dose forKey:@"herb_dose"];
        [dic setValue:@(subModel.num) forKey:@"old_herb_dose"];
        subModel.origin_herb_factor = subModel.herb_factor;
        [dic setValue:subModel.origin_herb_factor forKey:@"origin_herb_factor"];
        [dic setValue: [self.model.need_factor integerValue] == 1? subModel.herb_factor: @"1" forKey:@"herb_factor"];
        ///
        [dic setValue:subModel.useful_value forKey:@"equivalent"];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.supply_price floatValue]*subModel.num] forKey:@"granule_price"];
        [dic setValue:subModel.supply_price forKey:@"supply_price"];
        [dic setValue:subModel.sell_price forKey:@"sell_price"];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.sell_price floatValue]*subModel.num] forKey:@"granule_sell_price"];
        [dic setValue:subModel.hiscode forKey:@"granule_his"];
        [recipedetail_list addObject:dic];
    }
    self.model.recipedetail_list = [ClassMethod arrayToJSONString:recipedetail_list];
    
    NSMutableArray *recipe_excipient_list = [NSMutableArray array];
    for (ExcipientItemModel *subModel in self.model.excipentArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:subModel.name forKey:@"name"];
        [dic setValue:@(subModel.num) forKey:@"weight"];
        [dic setValue:subModel.code forKey:@"code"];
        [dic setValue:subModel.price forKey:@"price"];
        [recipe_excipient_list addObject:dic];
    }
    self.model.recipe_excipient_list = [ClassMethod arrayToJSONString:recipe_excipient_list];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (UploadImgModel *imgModel in self.model.fileArr) {
        [imgArr addObject:imgModel.pic_id];
    }
    self.model.fileIds = [imgArr componentsJoinedByString:@","];
    
    /// 再说
//    self.model.recipe_sample_id = @"";
//    self.model.recipe_sample = @"";
    self.model.recipdetailListJSON =@"";
    
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:[MedicineManager sharedInfo].hospitalModel.hospital_id forKey:@"hospital_id"];
    [dic addEntriesFromDictionary:[self.model mj_keyValues]];
    NSLog(@"sdsdsd %@",dic);
    
    self.model.force_stock_create = false;
    [[RequestManager shareInstance]requestWithMethod:POST url:SaveRecipeURL dict:dic hasHeader:YES finished:^(id request) {
        if([request[@"state"] isEqualToString:@"A4101"]) {
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"%@是否确定创建", request[@"msg"]]];
            alertView.buttonHeight = 35;
            alertView.layer.masksToBounds = YES;
            alertView.layer.cornerRadius = 2.0f;
            [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
            }]];
            [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                self.model.force_stock_create = true; /// 超出库存是否强制创建处方
                [self saveRecipeLast];
                
               
            }]];
            [alertView showInController:self];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)saveTemplate {
    NSMutableArray *sampleArr = [NSMutableArray array];
    for (DrugItemModel *subModel in self.drugArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       
        [dic setValue:subModel.hiscode forKey:@"granule_his"];
        [dic setValue:subModel.drugname forKey:@"granule_name"];
        /// 减量相关
        subModel.herb_dose = [self.model.need_factor integerValue] ==1?  [ClassMethod formatNumberWithCustomRounding:subModel.num*[subModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld",subModel.num];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.herb_dose floatValue]/[subModel.useful_value floatValue]] forKey:@"granule_dose"];
        [dic setValue:subModel.herb_dose forKey:@"herb_dose"];
        [dic setValue:@(subModel.num) forKey:@"old_herb_dose"];
        subModel.origin_herb_factor = subModel.herb_factor;
        [dic setValue:subModel.origin_herb_factor forKey:@"origin_herb_factor"];
        [dic setValue: [self.model.need_factor integerValue] == 1? subModel.herb_factor: @"1" forKey:@"herb_factor"];
        ///
    
        [dic setValue:subModel.useful_value forKey:@"equivalent"];
        [sampleArr addObject:dic];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.model.recipesample_name forKey:@"recipesample_name"];
    [dic setValue:self.model.categoryId forKey:@"categoryId"];
    [dic setValue:self.model.recipesample_symptoms forKey:@"recipesample_symptoms"];
    [dic setValue:@"SHARE"   forKey:@"pharmacy_type"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:[ClassMethod arrayToJSONString:sampleArr] forKey:@"recipesampledetail_list"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SaveRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {

    }];
    
}


- (void)requestAddressInfo {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [[RequestManager shareInstance]requestWithMethod:GET url:UserInfoURL dict:dic finished:^(id request) {
        RegionItemModel *regionModel = [RegionItemModel mj_objectWithKeyValues:request];
        self.model.province = regionModel.province;
        self.model.city = regionModel.city;
        self.model.area = regionModel.area;
        self.model.address = regionModel.hospitaladdress;
        self.regionModel = regionModel;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failed:^(NSError *error) {
        
    }];
}


- (void)requestDics {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"excipient_proportion" forKey:@"dictType"];
    [[RequestManager shareInstance]requestWithMethod:GET url:GetDicsURL dict:dic hasHeader:YES finished:^(id request) {
        DictModel *model = [DictModel mj_objectWithKeyValues:request];
        
        for (DictItemModel *subModel in model.data) {
            [self.dicArray addObject:@{
                @"id": subModel.dictValue,
                @"value": subModel.dictLabel
            }];
            if([subModel.dictValue isEqualToString:@"0.5"]) {
                self.model.excipient_proportion = subModel.dictLabel;
            }
        }
        self.pickView.dataArray = self.dicArray;
        self.pickView.defaultValue = @"0.5";
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)requestConfig {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"excipient_cost" forKey:@"configKey"];
    [[RequestManager shareInstance]requestWithMethod:GET url:GetConfigURL dict:dic hasHeader:YES finished:^(id request) {
        self.model.cost = request[@"data"];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)addAttention {
    if(self.model.attention.length == 0) {
        return;
    }
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:self.model.attention forKey:@"careful"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SaveAttentionURL dict:dic finished:^(id request) {
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestHistoryInfoWith:(NSString *)recipeId {
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:recipeId forKey:@"recipeId"];
    
    [[RequestManager shareInstance]requestWithMethod:GET url:GetInfoForHistoryURL   dict:dic hasHeader:YES finished:^(id request) {
        RecipeOrderDetailModel *model = [RecipeOrderDetailModel mj_objectWithKeyValues:request];
        model.recipeModel = [RecipeOrderItemModel mj_objectWithKeyValues:model.recipe];
        
        self.model = [RecipeModel mj_objectWithKeyValues:[model.recipeModel mj_keyValues]] ;
        self.model.fileArr = model.recipeModel.fileList;
        
        [self requestConfig];
        [self requestDics];
        
        [self.drugArr removeAllObjects];
        for (DrugItemModel *itemModel in model.recipedetail) {
            itemModel.useful_value = itemModel.equivalent;
            itemModel.drugname = itemModel.granule_name;
            itemModel.hiscode = itemModel.granule_his;
            itemModel.herb_factor = itemModel.origin_herb_factor;
            itemModel.num = [itemModel.old_herb_dose integerValue];
            [self.drugArr addObject:itemModel];
        }
        self.model.drugArr = self.drugArr;
        
        [self.excipentArr removeAllObjects];
        for (RecipeExcipientModel *subModel in model.recipeExcipientList) {
            ExcipientItemModel *itemModel = [ExcipientItemModel mj_objectWithKeyValues:[subModel mj_keyValues]];
            itemModel.num = [subModel.weight integerValue];
            NSLog(@"sdsdsds %@ , %ld",subModel.weight, itemModel.num);
            [self.excipentArr addObject:itemModel];
        }
        self.model.excipentArr = self.excipentArr;
        self.model.cost = model.recipeModel.excipient_cost;
        self.model.isCustom = NO;
        [self.tableView reloadData];
        
        if([self.model.is_secret integerValue] == 1) {
            [self requestQueryPrice];
        }
    } failed:^(NSError *error) {
        
    }];

}


#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.model.recipe_type integerValue] == 1) {
        return 5;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 8;
    }else if(section == 1) {
        return 6;
    }else if(section == 2){
        if(self.model.drugArr.count == 0) {
            return 2;
        }
        return [self.model.is_secret integerValue] == 1 ? self.model.drugArr.count:  self.model.drugArr.count + 1;
    }else {
        if(section == 3 && [self.model.recipe_type integerValue] == 1) {
            if(self.excipentArr.count == 0) {
                return 2;
            }
            return self.excipentArr.count + 1;
        }
        return [self.model.recipe_type integerValue] == 0? self. self.bottomArr.count : self.gfBottomArr.count;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2) {
        return 125;
    }
    if([self.model.recipe_type integerValue] == 1 && section == 3) {
        return 85;
    }
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 2) {
        MedchineReduceHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MedchineReduceHeaderViewId"];
        @weakify(self);
        headerView.model = self.model;
        [[[headerView.trueBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.model.need_factor = @"1";
            [self.tableView reloadData];
            
            if([self.model.is_secret integerValue] == 1) {
                [self requestQueryPrice];
            }
            
            [ClassMethod setString:self.model.need_factor key:@"need_factor"];
        }];
        [[[headerView.falseBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.model.need_factor = @"0";
            [self.tableView reloadData];
            
            if([self.model.is_secret integerValue] == 1) {
                [self requestQueryPrice];
            }
            
            [ClassMethod setString:self.model.need_factor key:@"need_factor"];
        }];
        [[[headerView.historyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"HistoryDoctorOrderListVC" param:@{@"type": @0} backBlock:^(NSDictionary * _Nonnull dic) {
                RecipeOrderItemModel *itemModel = dic[@"model"];
                [self requestHistoryInfoWith:itemModel.recipe_id];
            } animated:YES];
        }];
        
        [[[headerView.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"CreateRecipeTemplateListVC" param:nil backBlock:^(NSDictionary * _Nonnull dic) {
                NSArray *drugArr = dic[@"drugArr"];
                [self.drugArr removeAllObjects];
                NSMutableArray *outArr = [NSMutableArray array];
                for (DrugItemModel *itemModel in drugArr) {
                    if([itemModel.drug_status integerValue] == 1) {
                        /// 模板
                        self.model.is_secret = itemModel.isSecret;
                        self.model.recipe_sample_id = itemModel.recipe_sample_id;
                        self.model.recipe_sample = itemModel.recipe_sample;
                        ///
                        itemModel.useful_value = itemModel.equivalent;
                        itemModel.drugname = itemModel.granule_name;
                        itemModel.origin_herb_factor = itemModel.herb_factor;
                        itemModel.num = [itemModel.old_herb_dose integerValue];
                        itemModel.hiscode = itemModel.granule_his;
                        [self.drugArr addObject:itemModel];
                    }else {
                        [outArr addObject:itemModel.granule_name];
                    }
                }
                self.model.drugArr = self.drugArr;
                self.model.isCustom = NO;
                [self.tableView reloadData];
                
                if(outArr.count>0) {
                    NSString *outStr = [outArr componentsJoinedByString:@","];
                    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"请注意，以下药品已禁用：%@",outStr]];
                    alertView.buttonHeight = 35;
                    alertView.layer.masksToBounds = YES;
                    alertView.layer.cornerRadius = 2.0f;
                    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    }]];
                    [alertView showInWindow];
                }
                if([self.model.is_secret integerValue] == 1) {
                    [self requestQueryPrice];
                }
            } animated:YES];
        }];
        return headerView;
    }else {
        if([self.model.recipe_type integerValue] == 1 && section == 3)  {
            ExcipientHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ExcipientHeaderViewId"];
            [headerView.zbBtn setTitle:self.model.excipient_proportion forState:UIControlStateNormal];
            headerView.model = self.model;

            @weakify(self);
            [[[headerView.zbBtn rac_signalForControlEvents:UIControlEventTouchUpInside ]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                self.pickView.dataArray = self.dicArray;
                TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.pickView preferredStyle:TYAlertControllerStyleActionSheet];
                alertVC.backgoundTapDismissEnable = YES;
                [self.pickView.commitSubject subscribeNext:^(id  _Nullable x) {
                    @strongify(self);
                    if(x) {
                        NSString *value = [x valueForKey:@"value"];
                        NSString *dictValue = [x valueForKey:@"id"];
                        self.model.excipient_proportion = dictValue;         /// 辅料占比
                        self.model.isCustom = NO;
                        [self.tableView reloadData];
                    }
                    [alertVC dismissViewControllerAnimated:YES];
                }];
                [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
            }];
            return headerView;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return [PatientTableViewCell getCellHeightWith:indexPath];
    }else if(indexPath.section == 1){
        return [RecipeTableViewCell  getCellHeightWith:indexPath columWith:self.column];
    }else if(indexPath.section == 2){
        return [MedchineReduceTableViewCell getCellHeightWith:indexPath modelWith:self.model];
    }else {
        if(indexPath.section == 3 && [self.model.recipe_type integerValue] == 1) {
            return [AccessoryTableViewCell getCellHeightWith:indexPath dataArrayWith:self.excipentArr];
        }
        return [ComputeTableViewCell getCellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        PatientTableViewCell *cell = [PatientTableViewCell getTableView:tableView indexPathWith:indexPath];
        [cell setRegionItemModel:self.model indexPathWith:indexPath];
        
        @weakify(self);
        [[[cell.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.name = @"";
            self.model.sex = @"男";
            self.model.age = @"";
            self.model.phone = @"";
            self.model.delivery_mode = @"0";
            self.model.province = self.regionModel.province;
            self.model.city =self.regionModel.city;
            self.model.area = self.regionModel.area;
            self.model.address = self.regionModel.hospitaladdress;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [[[cell.chooseAreaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.areaView preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            @weakify(self);
            [self.areaView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
                    RegionItemModel *itemModel = x;
                    self.model.province = itemModel.province;
                    self.model.city = itemModel.city;
                    self.model.area  = itemModel.area;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                }
                [alertVC dismissViewControllerAnimated:YES];
            }];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
        [[[cell.textView rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.model.address = x;
        }];
    
        
        [[[cell.textF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            switch (indexPath.row) {
                case 2:
                    self.model.name = x;
                    break;
                case 4:
                    self.model.age = x;
                    break;
                case 5:
                    self.model.phone = x;
                    break;
             
                default:
                    break;
            }
        }];
        
        [[[cell.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(indexPath.row == 3) {
                self.model.sex  = @"男";
            }else if(indexPath.row == 6) {
                self.model.delivery_mode  = @"0";
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(indexPath.row == 3) {
                self.model.sex  = @"女";
            }else if(indexPath.row == 6) {
                self.model.delivery_mode  = @"1";
                /// 自提去选择地址
                @WeakSelf(self);
                [self pushVC:@"ChoosePickupAddressVC" param:nil backBlock:^(NSDictionary * _Nonnull dic) {
                    SelfPickModel *subModel = dic[@"selfPickModel"];
                    weakSelf.model.province = subModel.province;
                    weakSelf.model.city = subModel.city;
                    weakSelf.model.area = subModel.area;
                    weakSelf.model.address = subModel.address;
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                } animated:YES];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
       
        return cell;
    }else if(indexPath.section == 1){
        RecipeTableViewCell *cell = [RecipeTableViewCell getTableView:tableView indexPathWith:indexPath];
        
        
        [cell setModel:self.model indexPathWith:indexPath];
        ///  图片
        cell.takeView.orginalArr = self.model.fileArr.mutableCopy;
        cell.takeView.collectionView.height = self.column * (ceil((WIDE - 50)/4.0)+ 10) + 55;
        @WeakSelf(self);
        cell.takeView.getImgBlock = ^(NSMutableArray *urlArray) {
            if(urlArray.count >= 8) {
                weakSelf.column  = 2;
            }else {
                weakSelf.column = [[NSString stringWithFormat:@"%f",ceil((urlArray.count + 1)/4.0)] integerValue];
            }
            weakSelf.model.fileArr = urlArray;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        };
        @weakify(self)
        [[[cell.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.recipe_type = @"0";
            self.model.symptoms = @"";
            self.model.times_day=@"1";
            self.model.recipe_no = @"1";
            self.model.attention = @"";
            [self.drugArr removeAllObjects];
            [self.excipentArr removeAllObjects];
            self.model.drugArr = self.drugArr;
            self.model.excipentArr = self.excipentArr;
            [self.tableView reloadData];
            
            if([self.model.is_secret integerValue] == 1) {
                [self requestQueryPrice];
            }
        }];
        [[[cell.doctorOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"AddDoctorOrderViewController" param:@{@"isChoose": @"1"} backBlock:^(NSDictionary * _Nonnull dic) {
                AttentionItemModel *itemModel = [dic valueForKey:@"attentionItemModel"];
                self.model.attention = itemModel.careful;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            } animated:YES];
        }];
        
        [[[cell.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.recipe_type = @"0";
            [self.tableView reloadData];
        }];
        
        [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.recipe_type = @"1";
            [self.tableView reloadData];
        }];
        
        [[[cell.symptomTextView rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if(![x isEqualToString:@"请输入症状"]) {
                self.model.symptoms = x;
            }
            
        }];
        
        [[[cell.attentionTextView rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if(![x isEqualToString:@"请输入"]) {
                self.model.attention = x;
            }
            
        }];
        
        [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(indexPath.row == 3) {
                NSInteger current = [self.model.times_day integerValue] + 1;
                self.model.times_day = [NSString stringWithFormat:@"%ld", current];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }else {
                self.model.isCustom = NO;
                NSInteger current = [self.model.recipe_no integerValue] + 1;
                self.model.recipe_no = [NSString stringWithFormat:@"%ld", current];
                [self.tableView reloadData];
                if([self.model.is_secret integerValue] == 1) {
                    [self requestQueryPrice];
                }

            }
            
        }];
        
        [[[cell.numTextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            
            if(indexPath.row == 3) {
                if([x integerValue] == 0) {
                    [ZZProgress showErrorWithStatus:@"最小为1"];
                    self.model.times_day =@"1";
                }else {
                    self.model.times_day = x;
                }
            }else {
                if([x integerValue] == 0) {
                    [ZZProgress showErrorWithStatus:@"最小为1"];
                    self.model.recipe_no =@"1";
                }else {
                    self.model.recipe_no = x;
                }
            }
        }];
        

        
        [[cell rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            self.model.isCustom = NO;
            [self.tableView reloadData];
            
            if([self.model.is_secret integerValue] == 1) {
                [self requestQueryPrice];
            }
        }];
        
        
        [[[cell.reduceBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(indexPath.row == 3) {
                if([self.model.times_day integerValue] >1) {
                    NSInteger current = [self.model.times_day integerValue] - 1;
                    self.model.times_day = [NSString stringWithFormat:@"%ld", current];
                }else {
                    [ZZProgress showErrorWithStatus:@"最小为1"];
                }
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }else {
                if([self.model.recipe_no integerValue] >1) {
                    NSInteger current = [self.model.recipe_no integerValue] - 1;
                    self.model.recipe_no = [NSString stringWithFormat:@"%ld", current];
                    self.model.isCustom = NO;
                    
                    [self.tableView reloadData];
                }else {
                    [ZZProgress showErrorWithStatus:@"最小为1"];
                }
                
                
                if([self.model.is_secret integerValue] == 1) {
                    [self requestQueryPrice];
                }
                
            }
            
            
        }];
        
        [[[cell.addDoctorOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(self.model.attention.length == 0 &&  !self.model.isCommon) {
                [ZZProgress showErrorWithStatus:@"请输入医嘱"];
            }else {
                self.model.isCommon = ! self.model.isCommon;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }];

        return cell;
    }else if(indexPath.section == 2){
        MedchineReduceTableViewCell *cell = [MedchineReduceTableViewCell getTableView:tableView indexPathWith:indexPath modelWith:self.model];
        @weakify(self);
        if(self.model.drugArr.count>0 && indexPath.row <self.model.drugArr.count) {
            DrugItemModel *model = self.model.drugArr[indexPath.row];
            model.need_factor = self.model.need_factor;
            cell.model = model;
            [[[cell.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                model.isExpand = !model.isExpand;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            [[[cell.secrectExpandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                model.isExpand = !model.isExpand;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            [[[cell.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if(model.num>0) {
                    model.num --;
                    self.model.isCustom = NO;
                }
                [self.tableView reloadData];
            }];
            
            [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                model.num ++;
                self.model.isCustom = NO;
                [self.tableView reloadData];
            }];
            
            [[[cell.numtextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
                model.num = [x integerValue];
            }];
            
            [[cell rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
                @strongify(self);
                self.model.isCustom = NO;
                [self.tableView reloadData];
            }];
            
            [[[cell.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self.drugArr removeObjectAtIndex:indexPath.row];
                self.model.drugArr = self.drugArr;
                self.model.isCustom = NO;
                [self.tableView reloadData];
            }];
        }
      
        [[[cell.addMedchineBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"AddMedchineViewController" param:nil backBlock:^(NSDictionary * _Nonnull dic) {
                if([dic valueForKey:@"model"]) {
                    DrugItemModel *selecModel=[dic valueForKey:@"model"];
                    BOOL isHave = NO;
                    for (DrugItemModel *subModel in self.drugArr) {
                        if([subModel.hiscode isEqualToString:selecModel.hiscode]) {
                            isHave = YES;
                        }
                    }
                    if(!isHave) {
                        [self.drugArr addObject:dic[@"model"]];
                        self.model.drugArr = self.drugArr;
                        self.model.isCustom = NO;
                        [self.tableView reloadData];
                    }
                }
                
            } animated:YES];
        }];
        return cell;
    }else {
        
        if([self.model.recipe_type integerValue] == 1  && indexPath.section == 3) {
            AccessoryTableViewCell *cell = [AccessoryTableViewCell getTableView:tableView indexPathWith:indexPath dataArrayWith:self.excipentArr];
            @weakify(self);
            if(self.excipentArr.count>0 && indexPath.row <self.excipentArr.count) {
                ExcipientItemModel *model = self.excipentArr[indexPath.row];
                [cell setModel:self.model indexPathWith:indexPath];
                [[[cell.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                    @strongify(self);
                    if(model.num>0) {
                        model.num --;
                        self.model.isCustom = YES;
                    }
                    [self.tableView reloadData];
            
                }];
                
                [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                    @strongify(self);
                    model.num ++;
                    self.model.isCustom = YES;
                    [self.tableView reloadData];
                }];
                
                [[[cell.numtextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
                    model.num = [x integerValue];
                }];
                
                [[cell rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
                    @strongify(self);
                    [self.tableView reloadData];
                }];
                
                [[cell rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
                    @strongify(self);
                    self.model.isCustom = YES;
                }];
                
                
                [[[cell.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                    @strongify(self);
                    [self.excipentArr removeObjectAtIndex:indexPath.row];
                    self.model.excipentArr = self.excipentArr;
                    [self.tableView reloadData];
                }];
            }
          
            [[[cell.addMedchineBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if(self.drugArr.count == 0) {
                    [ZZProgress showErrorWithStatus:@"请先添加药品"];
                    return;
                }
                if(self.excipentArr.count >=2) {
                    [ZZProgress showErrorWithStatus:@"最多添加两味辅料"];
                    return;
                }
                [self pushVC:@"AddExciientViewController" param:nil backBlock:^(NSDictionary * _Nonnull dic) {
                    if([dic valueForKey:@"model"]) {
                        ExcipientItemModel *selecModel=[dic valueForKey:@"model"];
                        BOOL isHave = NO;
                        for (ExcipientItemModel *subModel in self.excipentArr) {
                            if([subModel.code isEqualToString:selecModel.code]) {
                                isHave = YES;
                            }
                        }
                        if(!isHave) {
                            [self.excipentArr addObject:dic[@"model"]];
                            self.model.excipentArr = self.excipentArr;
                            self.model.isCustom = NO;
                            [self.tableView reloadData];

                        }
                    }
                    
                } animated:YES];
                
            }];
            return cell;
        }else {
            ComputeTableViewCell *cell = [ComputeTableViewCell getTableView:tableView indexPathWith:indexPath];
            if([self.model.recipe_type integerValue] == 1) {
                cell.beforeLab.text = self.gfBottomArr[indexPath.row][0];
                cell.unitLab.text = self.gfBottomArr[indexPath.row][1];
            }else {
                cell.beforeLab.text = self.bottomArr[indexPath.row][0];
                cell.unitLab.text = self.bottomArr[indexPath.row][1];
            }

            [cell setModel:self.model indexPathWith:indexPath];
            return cell;
        }
       
    }
   
}

- (void)requestQueryPrice {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.model.recipe_sample_id forKey:@"recipesampleId"];
    [dic setValue:self.model.recipe_no forKey:@"recipeNo"];
    [dic setValue:self.model.need_factor forKey:@"needFactor"];
    [dic setValue:[MedicineManager sharedInfo].token forKey:@"APP_TOKEN"];
    [[RequestManager shareInstance]requestWithMethod:GET url:QueryPriceBySampleURL dict:dic hasHeader:YES finished:^(id request) {
        SecrectRecipeModel *recipeModel = [SecrectRecipeModel mj_objectWithKeyValues:request[@"data"]];
        self.model.recipeGranuleDose = recipeModel.recipeGranuleDose;
        self.model.totalSellPrice = recipeModel.totalSellPrice;
        self.model.totalSupplePrice = recipeModel.totalSupplePrice;
        NSLog(@"sdsdsd %@", [self.model mj_keyValues]);
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (UIAreaPickView *)areaView {
    if(!_areaView) {
        _areaView = [[UIAreaPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _areaView;
}

- (RecipeModel *)model {
    if(!_model) {
        _model = [[RecipeModel alloc]init];
        _model.sex = @"男";
        _model.delivery_mode = @"0";
        _model.recipe_type = @"0";
        _model.times_day = @"1";
        _model.recipe_no = @"1";
        if([ClassMethod getStringBy:@"need_factor"]) {
            _model.need_factor = [ClassMethod getStringBy:@"need_factor"];
        }else {
            _model.need_factor = @"1";
        }
        
    }
    return _model;
}

- (NSMutableArray *)drugArr {
    if(!_drugArr) {
        _drugArr = [NSMutableArray array];
    }
    return _drugArr;
}

- (NSMutableArray *)excipentArr {
    if(!_excipentArr) {
        _excipentArr = [NSMutableArray array];
    }
    return _excipentArr;
}

- (StatementPickView *)pickView {
    if(!_pickView) {
        _pickView = [[StatementPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _pickView;
}

- (NSMutableArray *)dicArray {
    if(!_dicArray) {
        _dicArray = [NSMutableArray array];
    }
    return _dicArray;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
