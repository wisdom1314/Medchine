//
//  MyCreateRecipeViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "MyCreateRecipeViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "PatientTableViewCell.h"
#import "RecipeTableViewCell.h"
#import "MedchineHeaderView.h"
#import "MedchineTableViewCell.h"
#import "ComputeTableViewCell.h"
#import "AddMyRecipeTempateView.h"
#import "RecipeLastView.h"
@interface MyCreateRecipeViewController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addTemplateBtn;
@property (nonatomic, strong) RecipeModel *model;
@property (nonatomic, strong) NSMutableArray *drugArr;
@property (nonatomic, copy) NSArray *bottomArr;

@end

@implementation MyCreateRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"创建处方";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MedchineHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MedchineHeaderViewId"];
    self.bottomArr = @[@[@"处方味数", @"味"],@[@"颗粒总价", @"元"],@[@"实收金额", @"元"]];
    [self requestConfig];
    
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
        
        AddMyRecipeTempateView *templateView = [AddMyRecipeTempateView createViewFromNib];
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
            [self saveTemplate];
            [alertVC dismissViewControllerAnimated:YES];
        }];
    }];
    
    if([[self.param allKeys]containsObject:@"model"] && ![[self.param allKeys]containsObject:@"isBack"]) {
        RecipeOrderItemModel *itemModel = self.param[@"model"];
        [self requestHistoryInfoWith:itemModel.recipe_name];
    }
  
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[self.param allKeys]containsObject:@"model"] && [[self.param allKeys]containsObject:@"isBack"]) {
        RecipeOrderItemModel *itemModel = self.param[@"model"];
        [self requestHistoryInfoWith:itemModel.recipe_name];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.addTemplateBtn addTopBorderWithColor:COLOR_B72E26 width:1];
    [self.addTemplateBtn addBottomBorderWithColor:COLOR_B72E26 width:1];
}

- (void)saveTemplate {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *sampleArr = [NSMutableArray array];
    for (DrugItemModel *subModel in self.drugArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSString stringWithFormat:@"%.4f",subModel.num/[subModel.useful_value floatValue]] forKey:@"granule_dose"];
        [dic setValue:subModel.hiscode forKey:@"granule_his"];
        [dic setValue:subModel.drugname forKey:@"granule_name"];
        [dic setValue:@(subModel.num) forKey:@"herb_dose"];
        [dic setValue:subModel.useful_value forKey:@"equivalent"];
        [sampleArr addObject:dic];
    }
    [dic setValue:self.model.recipesample_name forKey:@"recipesample_name"];
    [dic setValue:self.model.recipesample_symptoms forKey:@"recipesample_symptoms"];
    [dic setValue:@"SELF"   forKey:@"pharmacy_type"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:[ClassMethod arrayToJSONString:sampleArr] forKey:@"recipesampledetail_list"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SaveRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)createClick:(id)sender {
    
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
    

    if(self.model.isCommon) {
        [self addAttention]; /// 常用医嘱
    }
  
    RecipeLastView *lastView = [RecipeLastView createViewFromNib];
    TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:lastView preferredStyle:TYAlertControllerStyleAlert];
    self.model.isMy = YES;
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
        [dic setValue:[NSString stringWithFormat:@"%.4f",subModel.num/[subModel.useful_value floatValue]] forKey:@"granule_dose"];
        [dic setValue:@(subModel.num) forKey:@"herb_dose"];
        [dic setValue:subModel.herb_factor forKey:@"herb_factor"];
        [dic setValue:@(subModel.num) forKey:@"old_herb_dose"];
        [dic setValue:subModel.useful_value forKey:@"equivalent"];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.supply_price floatValue]*subModel.num] forKey:@"granule_price"];
        [dic setValue:subModel.supply_price forKey:@"supply_price"];
        [dic setValue:subModel.sell_price forKey:@"sell_price"];
        [dic setValue:[NSString stringWithFormat:@"%.4f",[subModel.sell_price floatValue]*subModel.num] forKey:@"granule_sell_price"];
        [dic setValue:subModel.hiscode forKey:@"granule_his"];
        [recipedetail_list addObject:dic];
    }
    self.model.recipedetail_list = [ClassMethod arrayToJSONString:recipedetail_list];

    
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctorname forKey:@"doctor"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [dic setValue:[MedicineManager sharedInfo].hospitalModel.hospital_id forKey:@"hospital_id"];
    self.model.force_stock_create = false;
    [dic addEntriesFromDictionary:[self.model mj_keyValues]];
    
    NSLog(@"sdsdsd %@",dic);
    
    [[RequestManager shareInstance]requestWithMethod:POST url:CreateHosRecipeURL dict:dic hasHeader:YES finished:^(id request) {
        [self.navigationController popViewControllerAnimated:YES];
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


- (void)requestHistoryInfoWith:(NSString *)recipe_name {
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
  
    [dic setValue:recipe_name forKey:@"recipe_name"];
    
    [[RequestManager shareInstance]requestWithMethod:POST url:RecipeHosDetailURL   dict:dic hasHeader:YES finished:^(id request) {
        RecipeOrderDetailModel *model = [RecipeOrderDetailModel mj_objectWithKeyValues:request];
        model.recipeModel = [RecipeOrderItemModel mj_objectWithKeyValues:model.recipe];
        self.model = [RecipeModel mj_objectWithKeyValues:[model.recipeModel mj_keyValues]] ;
        
        [self.drugArr removeAllObjects];
        for (DrugItemModel *itemModel in model.recipedetail) {
            itemModel.useful_value = itemModel.equivalent;
            itemModel.drugname = itemModel.granule_name;
            itemModel.hiscode = itemModel.granule_his;
            itemModel.num = [itemModel.herb_dose integerValue];
            [self.drugArr addObject:itemModel];
        }
        self.model.drugArr = self.drugArr;
        self.model.excipentArr = @[];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        
    }];

}



#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 6;
    }else if(section == 1) {
        return 5;
    }else if(section == 2){
        if(self.drugArr.count == 0) {
            return 2;
        }
        return self.drugArr.count + 1;
    }else {
        return self.bottomArr.count;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2) {
        return 55;
    }
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 2) {
        MedchineHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MedchineHeaderViewId"];
        @weakify(self);

       
        
        [[[headerView.historyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"HistoryDoctorOrderListVC" param:@{@"type": @1} backBlock:^(NSDictionary * _Nonnull dic) {
                RecipeOrderItemModel *itemModel = dic[@"model"];
                [self requestHistoryInfoWith:itemModel.recipe_name];
            } animated:YES];
        }];
        
        [[[headerView.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.param = @{};
            [self pushVC:@"ChooseRecipeTemplateListVC" param:nil backBlock:^(NSDictionary * _Nonnull dic) {
                NSArray *drugArr = dic[@"drugArr"];
                self.drugArr=[drugArr mutableCopy];
                self.model.drugArr = self.drugArr;
                [self.tableView reloadData];
                
                [self reloadDatasWith: self.model];
            } animated:YES];
        }];
        
        
        return headerView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return [PatientTableViewCell getCellHeightWith:indexPath];
    }else if(indexPath.section == 1){
        return [RecipeTableViewCell  getCellHeightWith:indexPath];
    }else if(indexPath.section == 2){
        return [MedchineTableViewCell getCellHeightWith:indexPath dataArrayWith:self.drugArr];
    }else {
        return [ComputeTableViewCell getCellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        PatientTableViewCell *cell = [PatientTableViewCell getTableView:tableView indexPathWith:indexPath];
        [cell setMyRegionItemModel:self.model indexPathWith:indexPath];
        @weakify(self);
        [[[cell.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.name = @"";
            self.model.sex = @"男";
            self.model.age = @"";
            self.model.phone = @"";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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
            self.model.sex  = @"男";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.sex  = @"女";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
       
        return cell;
    }else if(indexPath.section == 1){
        RecipeTableViewCell *cell = [RecipeTableViewCell getAutoTableView:tableView indexPathWith:indexPath];
        [cell setMyModel:self.model indexPathWith:indexPath];
        @weakify(self)
        [[[cell.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.model.symptoms = @"";
            self.model.times_day=@"1";
            self.model.recipe_no = @"1";
            self.model.attention = @"";
            [self.drugArr removeAllObjects];
            self.model.drugArr = self.drugArr;
            [self.tableView reloadData];
        }];
        [[[cell.doctorOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"AddDoctorOrderViewController" param:@{@"isChoose": @"1"} backBlock:^(NSDictionary * _Nonnull dic) {
                AttentionItemModel *itemModel = [dic valueForKey:@"attentionItemModel"];
                self.model.attention = itemModel.careful;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            } animated:YES];
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
            if(indexPath.row == 2) {
                NSInteger current = [self.model.times_day integerValue] + 1;
                self.model.times_day = [NSString stringWithFormat:@"%ld", current];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
            }else {
                NSInteger current = [self.model.recipe_no integerValue] + 1;
                self.model.recipe_no = [NSString stringWithFormat:@"%ld", current];
                [self.tableView reloadData];
            }
            
        }];
        
        [[[cell.numTextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            
            if(indexPath.row == 2) {
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
            [self.tableView reloadData];
        }];
        
        
        [[[cell.reduceBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if(indexPath.row == 2) {
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
                    [self.tableView reloadData];
                }else {
                    [ZZProgress showErrorWithStatus:@"最小为1"];
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
        MedchineTableViewCell *cell = [MedchineTableViewCell getTableView:tableView indexPathWith:indexPath dataArrayWith:self.drugArr];
        @weakify(self);
        if(self.drugArr.count>0 && indexPath.row <self.drugArr.count) {
            DrugItemModel *model = self.drugArr[indexPath.row];
            cell.myModel = model;
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
                [self.tableView reloadData];
            }];
            
            [[[cell.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                model.num ++;
                [self.tableView reloadData];
            }];
            
            [[[cell.numtextF rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(NSString * _Nullable x) {
                model.num = [x integerValue];
            }];
            
            [[cell rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
                @strongify(self);
                [self.tableView reloadData];
            }];
            
            [[[cell.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self.drugArr removeObjectAtIndex:indexPath.row];
                self.model.drugArr = self.drugArr;
                [self.tableView reloadData];
            }];
        }
      
        [[[cell.addMedchineBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self pushVC:@"AddMedchineViewController" param:@{@"type": @"1"} backBlock:^(NSDictionary * _Nonnull dic) {
                if([dic valueForKey:@"model"]) {
                    DrugItemModel *selecModel=[dic valueForKey:@"model"];
                    selecModel.useful_value = selecModel.equivalent;
                    BOOL isHave = NO;
                    for (DrugItemModel *subModel in self.drugArr) {
                        if([subModel.hiscode isEqualToString:selecModel.hiscode]) {
                            isHave = YES;
                        }
                    }
                    if(!isHave) {
                        [self.drugArr addObject:selecModel];
                        self.model.drugArr = self.drugArr;
                        [self.tableView reloadData];
                    }
                }
                
            } animated:YES];
        }];
        return cell;
    }else {
        ComputeTableViewCell *cell = [ComputeTableViewCell getTableView:tableView indexPathWith:indexPath];
        cell.beforeLab.text = self.bottomArr[indexPath.row][0];
        cell.unitLab.text = self.bottomArr[indexPath.row][1];
        [cell setMyModel:self.model indexPathWith:indexPath];
        return cell;
    }
   
}


- (NSMutableArray *)drugArr {
    if(!_drugArr) {
        _drugArr = [NSMutableArray array];
    }
    return _drugArr;
}

- (RecipeModel *)model {
    if(!_model) {
        _model = [[RecipeModel alloc]init];
        _model.sex = @"男";
        _model.times_day = @"1";
        _model.recipe_no = @"1";
    }
    return _model;
}



- (void)reloadDatasWith:(RecipeModel *)model {
    if([model.recipe_type integerValue] == 0) {
        /// 颗粒总价
        CGFloat totalPrice = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 4; // 设置最多四位小数
        formatter.minimumFractionDigits = 4; // 设置最少四位小数
        formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
        for (DrugItemModel *drugModel in model.drugArr) {
            drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
            CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
            CGFloat roundedValue = round(value * 10000) / 10000.0;
            totalPrice += roundedValue;
        }
        
        CGFloat fee = 0;
        if([model.delivery_mode integerValue] == 1 || totalPrice>150) {
            
            model.fee = @"0";
            fee = 0;
        }else {
            model.fee = @"10";
            fee = 10;
        }
        
        CGFloat finalPrice = totalPrice  + fee;
        
        /// 实收
        model.recipe_sale_price = [NSString stringWithFormat:@"%.2f",finalPrice];
        
    }else {
        /// 实收金额
        CGFloat totalPrice = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 4; // 设置最多四位小数
        formatter.minimumFractionDigits = 4; // 设置最少四位小数
        formatter.usesGroupingSeparator = NO; // 禁止千位分隔符
        for (DrugItemModel *drugModel in model.drugArr) {
            drugModel.herb_dose = [model.need_factor integerValue] == 1? [ClassMethod formatNumberWithCustomRounding:drugModel.num*[drugModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld", drugModel.num]; /// 是否减量
            CGFloat value = [drugModel.herb_dose floatValue] * [drugModel.sell_price floatValue];
            CGFloat roundedValue = round(value * 10000) / 10000.0;
            totalPrice += roundedValue;
        }
        totalPrice = totalPrice*[model.recipe_no  integerValue];
        
        CGFloat totalPrice1 = 0;
        NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
        formatter1.numberStyle = NSNumberFormatterDecimalStyle;
        formatter1.maximumFractionDigits = 2;
        formatter1.minimumFractionDigits = 2;
        formatter1.usesGroupingSeparator = NO; // 禁止千位分隔符
        for (ExcipientItemModel *subModel in model.excipentArr) {
            CGFloat value = subModel.num * [subModel.price floatValue];
            CGFloat roundedValue = round(value * 100) / 100.0;
            totalPrice1 += roundedValue;
        }
        
        CGFloat fee = 0;
        if([model.delivery_mode integerValue] == 1 || totalPrice>150) {
            fee = 0;
        }else {
            fee = 10;
        }
        
        CGFloat finalPrice = totalPrice + totalPrice1 + fee + [model.cost floatValue];
        model.recipe_sale_price = [NSString stringWithFormat:@"%.2f",finalPrice];
    }
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
