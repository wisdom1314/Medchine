//
//  AddRecipeTemplateViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/9.
//

#import "AddRecipeTemplateViewController.h"
#import "MedchineReduceTableViewCell.h"
#import "MedchineHeaderView.h"
#import "AddRecipeTemplateTableViewCell.h"

#import "HomeModel.h"
#import "StatementPickView.h"

@interface AddRecipeTemplateViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) StatementPickView *pickView;
@property (nonatomic, copy) NSString *pharmacy_type;
@property (nonatomic, copy) NSString *recipesample_name;
@property (nonatomic, copy) NSString *recipesample_symptoms;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *recipesampledetail_list;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSMutableArray *drugArr;
@property (nonatomic, strong) TemplateModel *recipesampleModel;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isDetail;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (nonatomic, strong) RecipeModel *recipeModel;

@end

@implementation AddRecipeTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 120)];
    self.tableView.tableFooterView = footView;
    [self.tableView registerNib:[UINib nibWithNibName:@"MedchineHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MedchineHeaderViewId"];
    [self requestData];
    if([[self.param allKeys]containsObject:@"pharmacy_type"] && [[self.param allKeys]containsObject:@"recipesampleModel"] && [[self.param allKeys]containsObject:@"isDetail"]) {
        self.navTitle = @"处方模板详情";
        self.isDetail = YES;
        self.pharmacy_type = [self.param valueForKey:@"pharmacy_type"];
        self.recipeModel.need_factor = @"0";
        self.recipesampleModel = [self.param valueForKey:@"recipesampleModel"];
        if([self.pharmacy_type isEqualToString:@"SELF"]) {
            self.recipeModel.need_factor = @"0";
        }else {
            self.recipeModel.need_factor = @"1";
        }
    
        self.category_id = self.recipesampleModel.categoryId;
        self.recipesample_name = self.recipesampleModel.recipesample_name;
        self.recipesample_symptoms = self.recipesampleModel.recipesample_symptoms;
        self.categoryName = self.recipesampleModel.categoryName;
        [self getTemplateDetail];
        self.btnHeight.constant = 0;
        self.bottomBtn.hidden = YES;
    } else if([[self.param allKeys]containsObject:@"recipesampleModel"]) {
        self.pharmacy_type = [self.param valueForKey:@"pharmacy_type"];
        self.isEdit = YES;
        self.navTitle = @"编辑处方模板";
        [self.bottomBtn setTitle:@"保存处方模板" forState:UIControlStateNormal];
        self.recipesampleModel = [self.param valueForKey:@"recipesampleModel"];
        if([self.pharmacy_type isEqualToString:@"SELF"]) {
            self.recipeModel.need_factor = @"0";
        }else {
            self.recipeModel.need_factor = @"1";
        }
        self.category_id = self.recipesampleModel.categoryId;
        self.recipesample_name = self.recipesampleModel.recipesample_name;
        self.recipesample_symptoms = self.recipesampleModel.recipesample_symptoms;
        self.categoryName = self.recipesampleModel.categoryName;
        [self getTemplateDetail];
    }else {
        self.pharmacy_type = [self.param valueForKey:@"pharmacy_type"];
        self.navTitle = @"添加处方模板";
        if([self.pharmacy_type isEqualToString:@"SELF"]) {
            self.recipeModel.need_factor = @"0";
        }else {
            self.recipeModel.need_factor = @"1";
        }
    }
   
    // Do any additional setup after loading the view from its nib.
}

- (void)getTemplateDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.recipesampleModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:self.recipesampleModel.recipesample_id forKey:@"recipesample_id"];
    [[RequestManager shareInstance]requestWithMethod:POST url:GetRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        DrugListModel *model = [DrugListModel mj_objectWithKeyValues:request];
        NSMutableArray *drugList = [NSMutableArray array];
        for (DrugItemModel *subModel in model.list) {
            subModel.drugname = subModel.granule_name;
            subModel.useful_value = subModel.equivalent;
            subModel.hiscode = subModel.granule_his;
            subModel.herb_dose = subModel.old_herb_dose;
            subModel.num = [subModel.old_herb_dose integerValue];
            [drugList addObject:subModel];
        }
        self.drugArr = drugList;
        self.recipeModel.drugArr = self.drugArr;
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (void)saveTemplate {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.recipesample_name forKey:@"recipesample_name"];
    [dic setValue:self.category_id forKey:@"categoryId"];
    [dic setValue:self.recipesample_symptoms forKey:@"recipesample_symptoms"];
    [dic setValue:self.pharmacy_type   forKey:@"pharmacy_type"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:self.recipesampledetail_list forKey:@"recipesampledetail_list"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SaveRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{});
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {

    }];
    
}

- (void)editSaveTemplate {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.recipesampleModel.recipesample_id forKey:@"recipesampleId"];
    [dic setValue:self.recipesample_name forKey:@"recipesample_name"];
    [dic setValue:self.category_id forKey:@"categoryId"];
    [dic setValue:self.recipesample_symptoms forKey:@"recipesample_symptoms"];
    [dic setValue:self.pharmacy_type   forKey:@"pharmacy_type"];
    [dic setValue:self.recipesampleModel.doctor forKey:@"doctor"];
    [dic setValue:self.recipesampleModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:self.recipesampledetail_list forKey:@"recipesampledetail_list"];
    [[RequestManager shareInstance]requestWithMethod:POST url:EditRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{});
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {

    }];
}

- (IBAction)addRecipeSampleClick:(id)sender {
    if(self.recipesample_name.length == 0) {
        [ZZProgress showErrorWithStatus:@"请输入模板名称"];
        return;
    }
    if(self.drugArr.count == 0) {
        [ZZProgress showErrorWithStatus:@"请添加药品"];
        return;
    }
    BOOL canCommit = false;
    for (DrugItemModel *subModel in self.drugArr) {
        if(subModel.num>0) {
            canCommit = true;
        }
    }
    if(!canCommit) {
        [ZZProgress showErrorWithStatus:@"请设置药品剂量"];
        return;
    }
    NSMutableArray *sampleArr = [NSMutableArray array];
    for (DrugItemModel *subModel in self.drugArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:subModel.hiscode forKey:@"granule_his"];
        [dic setValue:subModel.drugname forKey:@"granule_name"];
        [dic setValue:subModel.useful_value forKey:@"equivalent"];
        /// 减量相关
        subModel.herb_dose = [self.recipeModel.need_factor integerValue] ==1?  [ClassMethod formatNumberWithCustomRounding:subModel.num*[subModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld",subModel.num];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.herb_dose floatValue]/[subModel.useful_value floatValue]] forKey:@"granule_dose"];
        [dic setValue:subModel.herb_dose forKey:@"herb_dose"];
        [dic setValue:@(subModel.num) forKey:@"old_herb_dose"];
        subModel.origin_herb_factor = subModel.herb_factor;
        [dic setValue:subModel.origin_herb_factor forKey:@"origin_herb_factor"];
        [dic setValue: [self.recipeModel.need_factor integerValue] == 1? subModel.herb_factor: @"1" forKey:@"herb_factor"];
        ///
        [sampleArr addObject:dic];
    }
    self.recipesampledetail_list = [ClassMethod arrayToJSONString:sampleArr];
    if(self.isEdit) {
        [self editSaveTemplate];
    }else {
        [self saveTemplate];
    }
    
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"" forKey:@"name"];
    [[RequestManager shareInstance]requestWithMethod:GET url:RecipeCategoryListURL dict:dic hasHeader:YES finished:^(id request) {
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [CategoryModel class]
            };
        }];
        model.listModel = [PageListModel mj_objectWithKeyValues:model.list];
        for (CategoryModel *subModel in model.listModel.data) {
            [self.categoryArr addObject:@{
                            @"id": subModel.category_id,
                            @"value": subModel.name
            }];
            
            self.pickView.dataArray = self.categoryArr;
        }
    } failed:^(NSError *error) {
        
    }];
    
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        if([self.pharmacy_type isEqualToString:@"SELF"]) {
            return 2;
        }
        return 3;
    }else {
        if(self.drugArr.count>0) {
            return self.drugArr.count + 1;
        }else {
            return 2;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        return 45;
    }
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1) {
        MedchineHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MedchineHeaderViewId"];
        headerView.rightBtn.hidden = YES;
        headerView.historyBtn.hidden = YES;
        return headerView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return [AddRecipeTemplateTableViewCell getCellHeightWith:indexPath typeWith:self.pharmacy_type];
    }else {
        return [MedchineReduceTableViewCell getCellHeightWith:indexPath modelWith:self.recipeModel isDetail:self.isDetail];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        AddRecipeTemplateTableViewCell *cell = [AddRecipeTemplateTableViewCell getTableView:tableView indexPathWith:indexPath typeWith:self.pharmacy_type];
        cell.textF.text = self.recipesample_name;
        if(self.recipesample_symptoms.length>0) {
            cell.textView.text = self.recipesample_symptoms;
            cell.textView.textColor = COLOR_333333;
        }
        if(self.categoryName.length>0) {
            [cell.chooseCategoryBtn setTitle:self.categoryName forState:UIControlStateNormal];
            [cell.chooseCategoryBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        }
        if(self.isEdit || self.isDetail) {
            if(self.isDetail) {
                cell.textF.enabled = NO;
                cell.hiddenView.hidden = NO;
                cell.chooseCategoryBtn.enabled = NO;
                if(self.recipesampleModel.categoryName.length == 0) {
                    [cell.chooseCategoryBtn setTitle:@"暂无分类" forState:UIControlStateNormal];
                    [cell.chooseCategoryBtn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
                }
                if(self.recipesample_symptoms.length == 0) {
                    cell.textView.text = @"";
                }
            }
        }
        
        @weakify(self);
        [[[cell.textView rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if(![x isEqualToString:@"请输入"]) {
                self.recipesample_symptoms = x;
            }
        }];
        
        [[[cell.textF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.recipesample_name = x;
        }];
        
        [[[cell.chooseCategoryBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.pickView.dataArray = self.categoryArr;
            TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.pickView preferredStyle:TYAlertControllerStyleActionSheet];
            alertVC.backgoundTapDismissEnable = YES;
            /// 选择缴费状态
            [self.pickView.commitSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                if(x) {
                    NSString *value = [x valueForKey:@"value"];
                    NSString *category_id = [x valueForKey:@"id"];
                    self.categoryName = value;
                    self.category_id = category_id;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                }
                [alertVC dismissViewControllerAnimated:YES];
            }];
            [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
                    
        }];
        return cell;
    }else {
        MedchineReduceTableViewCell *cell = [MedchineReduceTableViewCell getTableView:tableView indexPathWith:indexPath modelWith:self.recipeModel];
        @weakify(self);
        if(self.drugArr.count>0 && indexPath.row <self.drugArr.count) {
            DrugItemModel *model = self.drugArr[indexPath.row];
            model.need_factor = self.recipeModel.need_factor;
            if([self.pharmacy_type isEqualToString:@"SELF"]) {
                cell.myModel = model;
            }else {
                cell.model = model;
            }
            [[[cell.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                model.isExpand = !model.isExpand;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            [[[cell.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if(model.num>0) {
                    model.num --;
                }
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                model.num ++;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            [[[cell.numtextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
                model.num = [x integerValue];
            }];
            
    
            
            [[cell rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
                @strongify(self);
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            [[[cell.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self.drugArr removeObjectAtIndex:indexPath.row];
                self.recipeModel.drugArr = self.drugArr;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
            }];
        }
        
        if(self.isDetail) {
            cell.addMedchineBtn.hidden = YES;
            cell.dealViiew.hidden = YES;
            cell.delBtn.hidden = YES;
            cell.orginalLab.hidden = YES;
            cell.actualLab.hidden = YES;
            cell.expandBtn.hidden = YES;
            cell.unitLab.hidden = YES;
            cell.originalTextWidth.constant = 0;
            cell.subWidth.constant = 0;
        }
       
        [[[cell.addMedchineBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            NSDictionary *param  = [self.pharmacy_type isEqualToString:@"SELF"]?@{@"type": @"1"}: @{};
            [self pushVC:@"AddMedchineViewController" param:param backBlock:^(NSDictionary * _Nonnull dic) {
                if([dic valueForKey:@"model"]) {
                    DrugItemModel *selecModel=[dic valueForKey:@"model"];
                    NSLog(@"sdsdsd %@", [selecModel mj_keyValues]);
                    BOOL isHave = NO;
                    for (DrugItemModel *subModel in self.drugArr) {
                        if([subModel.hiscode isEqualToString:selecModel.hiscode]) {
                            isHave = YES;
                        }
                    }
                    if(!isHave) {
                        [self.drugArr addObject:dic[@"model"]];
                        self.recipeModel.drugArr = self.drugArr;
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
                
            } animated:YES];
        }];
        
       
        
        return cell;
    }
   
}

- (NSMutableArray *)categoryArr {
    if(!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}

- (NSMutableArray *)drugArr {
    if(!_drugArr) {
        _drugArr = [NSMutableArray array];
    }
    return _drugArr;
}

- (StatementPickView *)pickView {
    if(!_pickView) {
        _pickView = [[StatementPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _pickView;
}

- (RecipeModel *)recipeModel {
    if(!_recipeModel) {
        _recipeModel = [[RecipeModel alloc]init];
    }
    return _recipeModel;
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
